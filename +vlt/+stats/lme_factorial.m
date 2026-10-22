function [lme, newTable, stats] = lme_factorial(tbl, yName, factorNames, groupNames, options)
% LME_FACTORIAL - linear mixed effects model with crossed fixed factors and nested random effects
%
% [LME, NEWTABLE, STATS] = vlt.stats.LME_FACTORIAL(TBL, YNAME, FACTORNAMES, GROUPNAMES, ...)
%
% Fits a linear mixed effects model to the variable YNAME in the table TBL
% with one or more categorical fixed factors (for example, a 2 x 2 design of
% Condition x Treatment) and one or more NESTED random intercepts (for example,
% neurons nested within animals). This extends vlt.stats.lme_category, which
% handles only a single fixed factor and a single random effect.
%
% The model that is fit is (for 2 factors and 2 nested grouping levels):
%
%    Y ~ 1 + F1*F2 + (1|G1) + (1|G2_in_G1)
%
% where G2_in_G1 is a new grouping variable made by combining the labels of
% G1 and G2, so that unit G2 is always treated as being inside G1 (for example,
% 'image34' in animal 92825 is a different neuron than 'image34' in animal 92925).
%
% Inputs:
%   TBL - a table with the data
%   YNAME - the name of the TBL column with the response variable (e.g., 'Density')
%   FACTORNAMES - a cell array of TBL column names with the fixed factors
%       (e.g., {'Condition','Treatment'}). One factor is also allowed.
%   GROUPNAMES - a cell array of TBL column names with the random effect
%       groupings, ordered from OUTERMOST to INNERMOST (e.g., {'AnimalID','NeuronID'}).
%
% Outputs:
%   LME - the LinearMixedModel object
%   NEWTABLE - the table used for fitting. It contains the factors (as categoricals,
%       with the reference category first), the nested grouping variables (as
%       categoricals), the (possibly transformed) response, and the column
%       'original_data' with the untransformed response.
%   STATS - a structure with fields:
%       formula - the model formula
%       factorNames - the fixed factor names
%       factorLevels - a cell array of the levels of each factor (reference first)
%       groupNames - the original grouping names (outermost to innermost)
%       groupVarNames - the names of the nested grouping variables in NEWTABLE
%       yNameFixed - the name of the response column in NEWTABLE
%       transform - 'none', 'log10', or 'rank'
%       dfMethod - the degrees of freedom method used for the tests
%       anova - the output of ANOVA(LME,'DFMethod',dfMethod); tests of the
%           main effects and interaction(s)
%       anovaTable - the same information as a table
%       cellMeans - a table with one row per cell of the design: the factor levels,
%           the model estimate of the cell mean (fixed effects only), its SE, the
%           number of observations, and the number of units at each grouping level
%       contrasts - a table of pairwise comparisons between cell means (see
%           'contrasts' option) with Satterthwaite (or other) DF and p-values
%           adjusted for multiple comparisons
%       effects - a table with one row per main effect and interaction (the
%           terms of anovaTable), each expressed as a difference of cell means
%           in the units of the fitted response, with its definition, SE, DF,
%           95% confidence interval, and p-value (see "Effects" below)
%       effectsUnits - the units of effects.Estimate (see "Effects" below)
%
% This function also takes name/value pairs that modify the default behavior:
% |---------------------------------|--------------------------------------------|
% | Parameter (default)             | Description                                |
% |---------------------------------|--------------------------------------------|
% | referenceCategories ({})        | Cell array, one entry per factor, with the |
% |                                 |   reference level of each factor. An empty |
% |                                 |   entry (or {}) uses the first level.      |
% | yOp ('')                        | Operation to perform on Y before fitting,  |
% |                                 |   such as '1-Y' or 'sin(Y)'. Empty is 'Y'. |
% | interaction (true)              | Include interaction terms (F1*F2) (true)   |
% |                                 |   or main effects only (F1+F2) (false)     |
% | rankOrder (false)               | Fit the ranks of the data (non-parametric) |
% | logData (false)                 | Fit log10 of the data                      |
% | dummyVarCoding ('effects')      | Coding of the categorical factors. With    |
% |                                 |   'effects' coding, the ANOVA main effects |
% |                                 |   are true main effects even when an       |
% |                                 |   interaction is present. ('reference'     |
% |                                 |   coding gives simple effects at the       |
% |                                 |   reference level instead.)                |
% | fitMethod ('REML')              | 'REML' or 'ML'                             |
% | dfMethod ('satterthwaite')      | 'satterthwaite', 'residual', or 'none'.    |
% |                                 |   Satterthwaite DF account for the fact    |
% |                                 |   that the effective sample size is closer |
% |                                 |   to the number of animals/neurons than    |
% |                                 |   the number of observations.              |
% | contrasts ('simple')            | 'simple' compares cells that differ in     |
% |                                 |   only one factor (4 tests in a 2x2);      |
% |                                 |   'all' compares all pairs of cells;       |
% |                                 |   'none' skips the comparisons.            |
% | multipleComparisons ('holm')    | 'holm', 'bonferroni', or 'none' p-value    |
% |                                 |   adjustment across the contrasts          |
% | computeEffects (true)           | Compute STATS.effects. Set false to save   |
% |                                 |   time when only the tests are needed      |
% |                                 |   (e.g., in simulations); STATS.effects is |
% |                                 |   then an empty table.                     |
% | randomTerms ('')                | If not empty, use this string for the      |
% |                                 |   random-effects part of the formula       |
% |                                 |   instead of the default nested intercepts |
% |                                 |   (e.g., '(1+Treatment|AnimalID) +         |
% |                                 |   (1|NeuronID_in_AnimalID)').              |
% |---------------------------------|--------------------------------------------|
%
% Effects:
%   The coefficients of LME depend on the coding of the factors (with effects
%   coding, a two-level main effect coefficient is half of the difference
%   between levels and a two-way interaction coefficient is a quarter of the
%   difference of differences). STATS.effects reports each term directly as
%   a difference of model cell means, so its size and sign do not depend on
%   the coding:
%     - a main effect is (non-reference level) - (reference level), averaged
%       over the levels of the other factors;
%     - a two-way interaction is a difference of differences, e.g.
%       (sh / DREADDs - sh / GFP) - (ctrl / DREADDs - ctrl / GFP);
%     - a three-way interaction is a difference of differences of differences,
%       and so on.
%   The Definition column spells out each one. The SE comes from the
%   covariance of the fixed effects, and the DF and p-value from COEFTEST with
%   the chosen dfMethod; the 95% CI is Estimate +/- tinv(0.975,DF)*SE. With
%   the default 'effects' coding, and factors with two levels, each p-value
%   equals the one for the same term in anovaTable. (With 'reference' coding,
%   anovaTable tests main effects at the reference level of the other
%   factors, but STATS.effects still reports the averaged main effects.) A term that involves a factor with more than two levels is not
%   a single difference; its row is NaN, and cellMeans and contrasts describe it.
%   The units of the estimate are the units of the fitted response
%   (STATS.effectsUnits):
%     - default: the units of Y (after yOp, if given);
%     - logData: log10 units. The columns Ratio, RatioCILower, and
%       RatioCIUpper give 10.^Estimate and its CI: a ratio for a main effect,
%       a ratio of ratios for a two-way interaction;
%     - rankOrder: ranks. The p-value is valid, but the estimate and CI depend
%       on the sample size and are not interpretable as the size of an effect.
%
% Example:
%   tbl = readtable('Big_data_spine_density_rat_DREADDs.xlsx');
%   [lme,newTable,stats] = vlt.stats.lme_factorial(tbl,'Density',...
%       {'Condition','Treatment'},{'AnimalID','NeuronID'},...
%       'referenceCategories',{'ctrl','GFP'});
%   disp(stats.anovaTable);
%   disp(stats.cellMeans);
%   disp(stats.contrasts);
%   disp(stats.effects);   % e.g., the interaction as a difference of differences
%   figure;
%   vlt.stats.plot_lme_factorial(lme,newTable,stats,'yLabel','Spine density');
%
% See also: vlt.stats.plot_lme_factorial, vlt.stats.lme_category, fitlme
%

arguments
    tbl table
    yName (1,:) char
    factorNames {mustBeText}
    groupNames {mustBeText}
    options.referenceCategories {mustBeText} = {}
    options.yOp (1,:) char = ''
    options.interaction (1,1) logical = true
    options.rankOrder (1,1) logical = false
    options.logData (1,1) logical = false
    options.dummyVarCoding (1,:) char {mustBeMember(options.dummyVarCoding,{'effects','reference'})} = 'effects'
    options.fitMethod (1,:) char {mustBeMember(options.fitMethod,{'REML','ML'})} = 'REML'
    options.dfMethod (1,:) char {mustBeMember(options.dfMethod,{'satterthwaite','residual','none'})} = 'satterthwaite'
    options.contrasts (1,:) char {mustBeMember(options.contrasts,{'simple','all','none'})} = 'simple'
    options.multipleComparisons (1,:) char {mustBeMember(options.multipleComparisons,{'holm','bonferroni','none'})} = 'holm'
    options.computeEffects (1,1) logical = true
    options.randomTerms (1,:) char = ''
end

factorNames = cellstr(factorNames);
groupNames = cellstr(groupNames);
referenceCategories = cellstr(options.referenceCategories);
if isempty(referenceCategories)
    referenceCategories = repmat({''},1,numel(factorNames));
end
if numel(referenceCategories)~=numel(factorNames)
    error('referenceCategories must have one entry per factor.');
end

if options.rankOrder && options.logData
    error('Choose either rankOrder or logData, not both.');
end

 % step 1: the response variable

Y = tbl.(yName);
if ~isempty(options.yOp)
    Y = eval(options.yOp);
end
Y = double(Y(:));

 % step 2: remove rows with missing values in any of the variables used

isMissing = isnan(Y);
for i=1:numel(factorNames)
    isMissing = isMissing | ismissing(labelsOf(tbl.(factorNames{i})));
end
for i=1:numel(groupNames)
    isMissing = isMissing | ismissing(labelsOf(tbl.(groupNames{i})));
end
if any(isMissing)
    warning(['Excluding ' int2str(sum(isMissing)) ' rows with missing values.']);
end
keep = ~isMissing;
Y = Y(keep);

 % step 3: build the fitting table

newTable = table();

factorLevels = cell(1,numel(factorNames));
for i=1:numel(factorNames)
    labels = labelsOf(tbl.(factorNames{i}));
    categor = categorical(labels(keep));
    cats = categories(categor);
    if isempty(referenceCategories{i})
        rc = 1;
    else
        rc = find(strcmp(referenceCategories{i},cats));
        if isempty(rc)
            error(['No category named ' referenceCategories{i} ' found in ' factorNames{i} '.']);
        end
    end
    cats = cats([rc 1:rc-1 rc+1:end]);
    newTable.(factorNames{i}) = reordercats(categor,cats);
    factorLevels{i} = cats(:)';
end

groupVarNames = cell(1,numel(groupNames));
nestedLabels = strings(sum(keep),1);
for k=1:numel(groupNames)
    labels = labelsOf(tbl.(groupNames{k}));
    labels = labels(keep);
    if k==1
        nestedLabels = labels;
        groupVarNames{k} = groupNames{k};
    else
        nestedLabels = nestedLabels + "/" + labels;
        groupVarNames{k} = strjoin(fliplr(groupNames(1:k)),'_in_');
    end
    newTable.(groupVarNames{k}) = categorical(nestedLabels);
end

if options.rankOrder
    data = tiedrank(Y);
    transform = 'rank';
elseif options.logData
    if any(Y<=0)
        error('logData requires all data to be positive.');
    end
    data = log10(Y);
    transform = 'log10';
else
    data = Y;
    transform = 'none';
end

yNameFixed = strrep(yName,'.','__');
newTable.(yNameFixed) = data;
newTable.original_data = Y;

 % step 4: fit the model

if options.interaction
    fixedPart = strjoin(factorNames,'*');
else
    fixedPart = strjoin(factorNames,' + ');
end
if isempty(options.randomTerms)
    randomPart = strjoin(strcat('(1|',groupVarNames,')'),' + ');
else
    randomPart = options.randomTerms;
end
formula = [yNameFixed ' ~ 1 + ' fixedPart ' + ' randomPart];

lme = fitlme(newTable, formula, 'FitMethod', options.fitMethod, ...
    'DummyVarCoding', options.dummyVarCoding);

 % step 5: tests of main effects and interactions

a = anova(lme,'DFMethod',options.dfMethod);
anovaTable = table(cellstr(a.Term), double(a.FStat), double(a.DF1), double(a.DF2), double(a.pValue), ...
    'VariableNames',{'Term','FStat','DF1','DF2','pValue'});

 % step 6: cell means and their standard errors (fixed effects only)
 % Because all fixed effects are categorical, every observation in a cell
 % has the same row in the fixed effects design matrix.

X = designMatrix(lme,'Fixed');
beta = fixedEffects(lme);
covB = lme.CoefficientCovariance;

nLevels = cellfun(@numel,factorLevels);
nCells = prod(nLevels);
subs = cell(1,numel(factorNames));
[subs{:}] = ind2sub([fliplr(nLevels) 1],(1:nCells)'); % last factor varies fastest
combos = fliplr([subs{:}]);

cellMeans = table();
for i=1:numel(factorNames)
    cellMeans.(factorNames{i}) = reshape(factorLevels{i}(combos(:,i)),nCells,1);
end
cellMeans.Label = strings(nCells,1);
cellMeans.Estimate = nan(nCells,1);
cellMeans.SE = nan(nCells,1);
cellMeans.N = zeros(nCells,1);
for k=1:numel(groupNames)
    cellMeans.(['n_' groupNames{k}]) = zeros(nCells,1);
end
cellRows = zeros(nCells,size(X,2));
cellIndexes = cell(nCells,1);

for c=1:nCells
    inCell = true(height(newTable),1);
    labelParts = cell(1,numel(factorNames));
    for i=1:numel(factorNames)
        inCell = inCell & newTable.(factorNames{i})==cellMeans.(factorNames{i}){c};
        labelParts{i} = cellMeans.(factorNames{i}){c};
    end
    cellMeans.Label(c) = string(strjoin(labelParts,' / '));
    I = find(inCell);
    cellIndexes{c} = I;
    cellMeans.N(c) = numel(I);
    for k=1:numel(groupNames)
        cellMeans.(['n_' groupNames{k}])(c) = numel(unique(newTable.(groupVarNames{k})(I)));
    end
    if ~isempty(I)
        x = X(I(1),:);
        cellRows(c,:) = x;
        cellMeans.Estimate(c) = x*beta;
        cellMeans.SE(c) = sqrt(x*covB*x');
    else
        cellRows(c,:) = NaN;
    end
end
if strcmp(transform,'log10')
    cellMeans.EstimateOriginalUnits = 10.^cellMeans.Estimate;
end

 % step 7: pairwise comparisons of cell means

contrasts = table();
if ~strcmp(options.contrasts,'none') && nCells>1
    pairs = nchoosek(1:nCells,2);
    if strcmp(options.contrasts,'simple')
        nDiffer = zeros(size(pairs,1),1);
        for i=1:numel(factorNames)
            nDiffer = nDiffer + ~strcmp(cellMeans.(factorNames{i})(pairs(:,1)), ...
                cellMeans.(factorNames{i})(pairs(:,2)));
        end
        pairs = pairs(nDiffer==1,:);
    end
    nPairs = size(pairs,1);
    estimate = nan(nPairs,1);
    se = nan(nPairs,1);
    tStat = nan(nPairs,1);
    df = nan(nPairs,1);
    pValue = nan(nPairs,1);
    for p=1:nPairs
        L = cellRows(pairs(p,2),:) - cellRows(pairs(p,1),:);
        if any(isnan(L))
            continue; % an empty cell
        end
        estimate(p) = L*beta;
        se(p) = sqrt(L*covB*L');
        [pValue(p),F,~,df(p)] = coefTest(lme,L,0,'DFMethod',options.dfMethod);
        tStat(p) = sign(estimate(p))*sqrt(F);
    end
    pAdjusted = adjustPValues(pValue, options.multipleComparisons);
    contrasts = table(cellMeans.Label(pairs(:,1)), cellMeans.Label(pairs(:,2)), ...
        estimate, se, tStat, df, pValue, pAdjusted, ...
        'VariableNames',{'Cell1','Cell2','Difference','SE','tStat','DF','pValue','pAdjusted'});
end

 % step 8: main effects and interactions as differences of cell means, in the units of the response

if options.computeEffects
    [effects, effectsUnits] = termEffects(lme, anovaTable.Term, factorNames, factorLevels, ...
        cellMeans, cellRows, options.dfMethod, transform);
else
    effects = table();
    effectsUnits = '';
end

stats = struct('formula',formula, 'factorNames',{factorNames}, 'factorLevels',{factorLevels}, ...
    'groupNames',{groupNames}, 'groupVarNames',{groupVarNames}, 'yName',yName, ...
    'yNameFixed',yNameFixed, 'transform',transform, 'dfMethod',options.dfMethod, ...
    'anova',a, 'anovaTable',anovaTable, 'cellMeans',cellMeans, 'contrasts',contrasts, ...
    'effects',effects, 'effectsUnits',effectsUnits);
stats.cellIndexes = cellIndexes;

end

function [effects, units] = termEffects(lme, terms, factorNames, factorLevels, cellMeans, cellRows, dfMethod, transform)
% TERMEFFECTS - each main effect and interaction as a difference of cell means
%
% For a term made of the factors T, the weight of cell c is the product, over
% the factors in T, of +1 (non-reference level) or -1 (reference level),
% divided by the number of cells of the other factors (to average over them).
% The effect is the weighted sum of the model cell means.

    beta = fixedEffects(lme);
    covB = lme.CoefficientCovariance;
    nLevels = cellfun(@numel,factorLevels);

    terms = terms(~strcmp(terms,'(Intercept)'));
    nTerms = numel(terms);
    definition = strings(nTerms,1);
    estimate = nan(nTerms,1);
    se = nan(nTerms,1);
    df = nan(nTerms,1);
    ciLower = nan(nTerms,1);
    ciUpper = nan(nTerms,1);
    pValue = nan(nTerms,1);

    for t=1:nTerms
        termFactors = strsplit(terms{t},':');
        inTerm = ismember(factorNames,termFactors);
        tooMany = factorNames(inTerm & nLevels~=2);
        if ~isempty(tooMany)
            definition(t) = "not a single difference (" + strjoin(string(tooMany),', ') + ...
                " has more than two levels); see cellMeans and contrasts";
            continue;
        end
        termIndexes = find(inTerm);

        weights = ones(height(cellMeans),1) / prod(nLevels(~inTerm));
        for i=termIndexes(:)'
            isOther = strcmp(cellMeans.(factorNames{i}), factorLevels{i}{2});
            weights = weights .* (2*isOther - 1);
        end

        definition(t) = differenceText(factorNames, factorLevels, termIndexes, 1, {});
        averagedOver = factorNames(~inTerm);
        if ~isempty(averagedOver)
            definition(t) = definition(t) + "; averaged over " + strjoin(string(averagedOver),', ');
        end

        L = weights' * cellRows;
        if any(isnan(L))
            continue; % an empty cell
        end
        estimate(t) = L*beta;
        se(t) = sqrt(L*covB*L');
        [pValue(t),~,~,df(t)] = coefTest(lme,L,0,'DFMethod',dfMethod);
        halfWidth = tinv(0.975,df(t)) * se(t);
        ciLower(t) = estimate(t) - halfWidth;
        ciUpper(t) = estimate(t) + halfWidth;
    end

    effects = table(string(terms(:)), definition, estimate, se, df, ciLower, ciUpper, pValue, ...
        'VariableNames',{'Term','Definition','Estimate','SE','DF','CILower','CIUpper','pValue'});

    switch transform
        case 'log10'
            units = 'log10 units of Y; Ratio = 10^Estimate (a ratio for a main effect, a ratio of ratios for a two-way interaction)';
            effects.Ratio = 10.^estimate;
            effects.RatioCILower = 10.^ciLower;
            effects.RatioCIUpper = 10.^ciUpper;
        case 'rank'
            units = 'ranks; the p-values are valid, but Estimate and the CI are not interpretable as effect sizes';
        otherwise
            units = 'units of Y';
    end
end

function text = differenceText(factorNames, factorLevels, termIndexes, k, assigned)
% DIFFERENCETEXT - write out a (nested) difference of cells, e.g.
% "(sh / DREADDs - sh / GFP) - (ctrl / DREADDs - ctrl / GFP)"
    if k > numel(termIndexes)
        text = string(strjoin(assigned,' / '));
        return;
    end
    levels = factorLevels{termIndexes(k)};
    a = differenceText(factorNames, factorLevels, termIndexes, k+1, [assigned levels(2)]);
    b = differenceText(factorNames, factorLevels, termIndexes, k+1, [assigned levels(1)]);
    if k == numel(termIndexes)
        text = a + " - " + b;
    else
        text = "(" + a + ") - (" + b + ")";
    end
end

function labels = labelsOf(v)
% LABELSOF - convert a table column (numeric, char, cellstr, string, categorical) to a string column
    if ischar(v)
        v = cellstr(v);
    end
    labels = strtrim(string(v(:)));
end

function pAdj = adjustPValues(p, method)
% ADJUSTPVALUES - Holm or Bonferroni adjustment of a vector of p-values (NaNs are ignored)
    pAdj = p;
    good = find(~isnan(p));
    m = numel(good);
    switch method
        case 'bonferroni'
            pAdj(good) = min(1, p(good)*m);
        case 'holm'
            [ps,order] = sort(p(good));
            adj = min(1, cummax(ps(:) .* (m - (1:m)' + 1)));
            pAdj(good(order)) = adj;
        otherwise
            % no adjustment
    end
end
