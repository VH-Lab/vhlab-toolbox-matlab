function results = lme_factorial_power(tbl, yName, factorNames, groupNames, nSubjectsPerGroup, effectSizes, options)
% LME_FACTORIAL_POWER - power vs. number of subjects for a factorial, nested LME (vlt.stats.lme_factorial)
%
% RESULTS = vlt.stats.power.LME_FACTORIAL_POWER(TBL, YNAME, FACTORNAMES, GROUPNAMES, ...
%       NSUBJECTSPERGROUP, EFFECTSIZES, ...)
%
% Estimates, by simulation, the statistical power of the analysis performed by
% vlt.stats.lme_factorial (crossed fixed factors, nested random intercepts) as a
% function of the number of subjects and the size of a hypothesized effect.
%
% Terminology:
%   SUBJECT     - the outermost random-effect unit (GROUPNAMES{1}), e.g. an animal
%   UNIT        - the innermost random-effect unit (GROUPNAMES{end}), e.g. a neuron
%                 within an animal. With only one grouping level, the unit is
%                 the subject.
%   OBSERVATION - one row of TBL, e.g. one dendritic segment of a neuron
%
% Process:
%   1. The model is fit to the pilot data TBL with vlt.stats.lme_factorial to
%      estimate the variance components: the SD of each nested random effect
%      (e.g., subject-to-subject and unit-to-unit within subject) and the
%      residual SD (observation-to-observation within unit).
%   2. Subjects are grouped into strata by the factors that do not vary within
%      a subject (e.g., Condition, if each animal is either ctrl or sh). Factors
%      that vary within a subject (e.g., Treatment) are left as they were in
%      the pilot subjects.
%   3. For each number of subjects N in NSUBJECTSPERGROUP, and for each of
%      NUMSIMULATIONS repetitions, N pilot subjects are drawn (with replacement)
%      from each stratum. Each drawn subject keeps the pilot design: which cells
%      it contributed to, how many units it had in each cell, and how many
%      observations each unit had. The number of units per subject and the
%      number of observations per unit can instead be set with
%      'nUnitsPerSubject' and 'nObsPerUnit'.
%   4. New data are generated from a Gaussian model with the pilot variance
%      components:
%         Y = baseline(cell) + effectSize * effectPattern(cell)
%             + subject effect + unit effect + ... + residual
%   5. vlt.stats.lme_factorial is fit to each simulated data set and the term
%      (or contrast) of interest is tested. Power is the fraction of
%      simulations with p < alpha. All effect sizes are tested on the same
%      simulated random effects and noise, so the power curves are smooth.
%
% Inputs:
%   TBL - the pilot data table
%   YNAME - the response column (e.g., 'Density')
%   FACTORNAMES - cell array of the fixed factors (e.g., {'Condition','Treatment'})
%   GROUPNAMES - cell array of the nested random effects, outermost (subject)
%       first (e.g., {'AnimalID','NeuronID'})
%   NSUBJECTSPERGROUP - vector of numbers of subjects per stratum to try (e.g., 4:2:20)
%   EFFECTSIZES - vector of effect sizes to try, in units of YNAME (e.g., [1 2 3])
%
% Output:
%   RESULTS - a structure with fields:
%       power - table with columns nSubjectsPerGroup, effectSize, power, nFailed
%       powerMatrix - numel(NSUBJECTSPERGROUP) x numel(EFFECTSIZES) matrix of power
%       requiredSubjects - table with, for each effect size, the smallest tested
%           number of subjects per group that reached targetPower (NaN if none did)
%       test - a description of the term or contrast that was tested
%       effectPattern - table of the cells and the effect pattern that was injected
%       pilot - structure with the pilot fit: formula, sigmas (SD of each random
%           effect and the residual, in that order), sigmaNames, strata, the number
%           of pilot subjects in each stratum, and the pilot cell means
%       options - the options used
%
% This function also takes name/value pairs that modify the default behavior:
% |---------------------------------|--------------------------------------------|
% | Parameter (default)             | Description                                |
% |---------------------------------|--------------------------------------------|
% | referenceCategories ({})        | Reference level of each factor (see        |
% |                                 |   vlt.stats.lme_factorial)                 |
% | testTerm ('')                   | ANOVA term to test, e.g. 'Condition',      |
% |                                 |   'Treatment', or 'Condition:Treatment'.   |
% |                                 |   Empty means the highest-order            |
% |                                 |   interaction (or the only factor).        |
% | testContrast ([])               | Instead of an ANOVA term, test the         |
% |                                 |   difference between two cells, given as   |
% |                                 |   their labels, e.g.                       |
% |                                 |   ["sh / GFP","sh / DREADDs"]              |
% | targetCell ({})                 | Levels of the cell that receives the       |
% |                                 |   effect, e.g. {'sh','DREADDs'}. Empty     |
% |                                 |   means the last cell (all non-reference   |
% |                                 |   levels).                                 |
% | effectPattern ([])              | Instead of targetCell, a vector with one   |
% |                                 |   entry per cell (in the order of          |
% |                                 |   stats.cellMeans of lme_factorial) that   |
% |                                 |   is multiplied by each effect size and    |
% |                                 |   added to the cell means.                 |
% | baseline ('null')               | 'null': all cells start at the pilot grand |
% |                                 |   mean, so the only true effect is the     |
% |                                 |   injected one. 'pilot': cells start at    |
% |                                 |   the pilot cell means.                    |
% | nUnitsPerSubject ([])           | If not empty, each simulated subject has   |
% |                                 |   this many units (e.g., neurons) in each  |
% |                                 |   cell it contributed to in the pilot      |
% |                                 |   data, instead of its pilot number. Unless|
% |                                 |   nObsPerUnit is given, the number of      |
% |                                 |   observations of each unit is drawn from  |
% |                                 |   the pilot units of the same cell.        |
% |                                 |   Requires exactly 2 grouping levels.      |
% | nObsPerUnit ([])                | If not empty, each unit has exactly this   |
% |                                 |   many observations (e.g., dendritic       |
% |                                 |   segments per neuron) in each cell. With  |
% |                                 |   one grouping level, this is the number   |
% |                                 |   of observations per subject per cell.    |
% |                                 |   Use it with nUnitsPerSubject to compare  |
% |                                 |   ways of spending the same effort, e.g.   |
% |                                 |   8 units x 3 observations vs. 2 units x   |
% |                                 |   12 observations. Requires 1 or 2         |
% |                                 |   grouping levels.                         |
% | testContrasts (struct([]))      | Planned contrasts to record in every       |
% |                                 |   simulation, in the format of the         |
% |                                 |   'plannedContrasts' option of             |
% |                                 |   vlt.stats.lme_factorial (name, weights,  |
% |                                 |   direction, margin). See "Contrasts"      |
% |                                 |   below.                                   |
% | targetPower (0.8)               | Power used for requiredSubjects            |
% | alpha (0.05)                    | Significance level                         |
% | numSimulations (500)            | Simulations per number of subjects         |
% | fitMethod ('REML')              | Passed to vlt.stats.lme_factorial          |
% | dfMethod ('satterthwaite')      | Passed to vlt.stats.lme_factorial          |
% | useParallel (true)              | Use parfor if the Parallel Computing       |
% |                                 |   Toolbox is available                     |
% | doPlot (true)                   | Plot power vs. number of subjects          |
% | verbose (true)                  | Print progress                             |
% |---------------------------------|--------------------------------------------|
%
% Notes:
%   - With the default targetCell (the last cell, e.g. sh/DREADDs), an effect
%     size of D means: the second factor changes Y by D only at the
%     non-reference level of the first factor. The interaction (difference of
%     differences) is then D, the simple effect of the second factor at that
%     level is D, and each main effect is D/2.
%   - A simulation in which the model cannot be fit, or the test cannot be
%     computed (for example, because no drawn subject contributed to one cell),
%     is counted as not significant; the number of such simulations is
%     reported in the nFailed column.
%   - The simulation is Gaussian. Outliers in the pilot data inflate the
%     residual SD, which makes the power estimates conservative.
%
% Contrasts:
%   With 'testContrasts', every simulated fit also estimates each contrast,
%   and RESULTS has two more fields:
%     contrastDraws - structure with fields names (1 x nContrasts) and
%         estimate, se, df (each nSimulations x nContrasts x
%         numel(NSUBJECTSPERGROUP) x numel(EFFECTSIZES)); NaN for failed fits
%     contrastPower - table with, for each number of subjects and effect
%         size, the power of each contrast (significant, two-sided, and in the
%         predicted direction if one is given), the power that all contrasts
%         with a predicted direction succeed together (powerAll), and the
%         power of the equivalence test for contrasts with a margin
%   Because the model is linear in the response, shifting the true cell
%   means shifts every contrast estimate by the same amount and leaves its
%   SE and DF unchanged. So draws simulated with no effect (EFFECTSIZES = 0)
%   give the power for ANY true contrast values, with
%   vlt.stats.power.contrast_power_from_draws, without new simulations.
%
% Example:
%   tbl = readtable('Big_data_spine_density_rat_DREADDs.xlsx');
%   results = vlt.stats.power.lme_factorial_power(tbl,'Density',...
%       {'Condition','Treatment'},{'AnimalID','NeuronID'},4:2:20,[1 2 3],...
%       'referenceCategories',{'ctrl','GFP'},'testTerm','Condition:Treatment');
%   disp(results.requiredSubjects);
%
%   % compare 8 neurons x 3 segments with 2 neurons x 12 segments, 8 subjects per group
%   r1 = vlt.stats.power.lme_factorial_power(tbl,'Density',{'Condition','Treatment'},...
%       {'AnimalID','NeuronID'},8,3,'nUnitsPerSubject',8,'nObsPerUnit',3);
%   r2 = vlt.stats.power.lme_factorial_power(tbl,'Density',{'Condition','Treatment'},...
%       {'AnimalID','NeuronID'},8,3,'nUnitsPerSubject',2,'nObsPerUnit',12);
%
% See also: vlt.stats.lme_factorial, vlt.stats.power.simpleLMEM,
%   vlt.stats.power.lme_power_effectsize
%

arguments
    tbl table
    yName (1,:) char
    factorNames {mustBeText}
    groupNames {mustBeText}
    nSubjectsPerGroup (1,:) double {mustBeInteger, mustBePositive}
    effectSizes (1,:) double
    options.referenceCategories {mustBeText} = {}
    options.testTerm (1,:) char = ''
    options.testContrast string = string.empty
    options.targetCell {mustBeText} = {}
    options.effectPattern double = []
    options.baseline (1,:) char {mustBeMember(options.baseline,{'null','pilot'})} = 'null'
    options.nUnitsPerSubject double {mustBeScalarOrEmpty, mustBeInteger, mustBePositive} = []
    options.nObsPerUnit double {mustBeScalarOrEmpty, mustBeInteger, mustBePositive} = []
    options.testContrasts struct = struct([])
    options.targetPower (1,1) double {mustBeInRange(options.targetPower,0,1)} = 0.8
    options.alpha (1,1) double {mustBeInRange(options.alpha,0,1)} = 0.05
    options.numSimulations (1,1) double {mustBeInteger, mustBePositive} = 500
    options.fitMethod (1,:) char {mustBeMember(options.fitMethod,{'REML','ML'})} = 'REML'
    options.dfMethod (1,:) char {mustBeMember(options.dfMethod,{'satterthwaite','residual','none'})} = 'satterthwaite'
    options.useParallel (1,1) logical = true
    options.doPlot (1,1) logical = true
    options.verbose (1,1) logical = true
end

factorNames = cellstr(factorNames);
groupNames = cellstr(groupNames);

 % step 1: fit the pilot data

[pilotLme, pilotTable, pilotStats] = vlt.stats.lme_factorial(tbl, yName, factorNames, groupNames, ...
    'referenceCategories', options.referenceCategories, 'fitMethod', options.fitMethod, ...
    'dfMethod', options.dfMethod, 'contrasts', 'none', 'computeEffects', false);

referenceCategories = cellfun(@(levels) levels{1}, pilotStats.factorLevels, 'UniformOutput', false);
groupVarNames = pilotStats.groupVarNames;
nGroupLevels = numel(groupVarNames);

psi = covarianceParameters(pilotLme);
sigmas = zeros(1,nGroupLevels+1);
for k=1:nGroupLevels
    sigmas(k) = sqrt(psi{k}(1,1));
end
sigmas(end) = sqrt(pilotLme.MSE);
sigmaNames = [groupNames {'residual'}];

cellMeans = pilotStats.cellMeans;
nCells = height(cellMeans);
cellOfRow = zeros(height(pilotTable),1);
for c=1:nCells
    cellOfRow(pilotStats.cellIndexes{c}) = c;
end

 % step 2: the effect pattern and baseline

if ~isempty(options.effectPattern)
    effectPattern = options.effectPattern(:);
    if numel(effectPattern)~=nCells
        error(['effectPattern must have one entry per cell (' int2str(nCells) ').']);
    end
else
    targetCell = cellstr(options.targetCell);
    if isempty(targetCell)
        targetCell = cellfun(@(levels) levels{end}, pilotStats.factorLevels, 'UniformOutput', false);
    end
    if numel(targetCell)~=numel(factorNames)
        error('targetCell must have one level per factor.');
    end
    isTarget = true(nCells,1);
    for i=1:numel(factorNames)
        isTarget = isTarget & strcmp(cellMeans.(factorNames{i}),targetCell{i});
    end
    if ~any(isTarget)
        error(['No cell matches targetCell ' strjoin(targetCell,' / ') '.']);
    end
    effectPattern = double(isTarget);
end

switch options.baseline
    case 'null'
        baseline = repmat(mean(cellMeans.Estimate,'omitnan'),nCells,1);
    case 'pilot'
        baseline = cellMeans.Estimate;
end

 % step 3: the test

if ~isempty(options.testContrast)
    if numel(options.testContrast)~=2
        error('testContrast must name exactly two cells.');
    end
    if ~all(ismember(options.testContrast,cellMeans.Label))
        error(['testContrast cells must be among: ' char(strjoin(cellMeans.Label,', ')) '.']);
    end
    test = struct('type','contrast','cells',options.testContrast(:)', ...
        'description',char(options.testContrast(1) + " vs " + options.testContrast(2)));
else
    testTerm = options.testTerm;
    if isempty(testTerm)
        testTerm = strjoin(factorNames,':');
    end
    if ~any(strcmp(pilotStats.anovaTable.Term,testTerm))
        error(['testTerm must be one of: ' strjoin(pilotStats.anovaTable.Term',', ') '.']);
    end
    test = struct('type','term','term',testTerm,'description',testTerm);
end

 % step 4: strata of subjects (combinations of factors that do not vary within a subject)

outerVar = groupVarNames{1};
subjects = categories(removecats(pilotTable.(outerVar)));
isBetween = true(1,numel(factorNames));
for i=1:numel(factorNames)
    for a=1:numel(subjects)
        levelsHere = unique(pilotTable.(factorNames{i})(pilotTable.(outerVar)==subjects{a}));
        if numel(levelsHere)>1
            isBetween(i) = false;
            break;
        end
    end
end
betweenFactors = factorNames(isBetween);

subjectStratum = strings(numel(subjects),1);
subjectRows = cell(numel(subjects),1);
for a=1:numel(subjects)
    subjectRows{a} = find(pilotTable.(outerVar)==subjects{a});
    parts = strings(1,numel(betweenFactors));
    for i=1:numel(betweenFactors)
        parts(i) = string(pilotTable.(betweenFactors{i})(subjectRows{a}(1)));
    end
    if isempty(parts)
        subjectStratum(a) = "all";
    else
        subjectStratum(a) = strjoin(parts," / ");
    end
end
strata = unique(subjectStratum,'stable');
stratumPools = cell(numel(strata),1);
nPilotSubjects = zeros(numel(strata),1);
for s=1:numel(strata)
    stratumPools{s} = find(subjectStratum==strata(s));
    nPilotSubjects(s) = numel(stratumPools{s});
end

pilot = struct('formula',pilotStats.formula, 'sigmas',sigmas, 'sigmaNames',{sigmaNames}, ...
    'betweenFactors',{betweenFactors}, 'strata',strata, 'nPilotSubjects',nPilotSubjects, ...
    'cellMeans',cellMeans);

if options.verbose
    fprintf('Pilot model: %s\n', pilotStats.formula);
    for k=1:numel(sigmas)
        fprintf('  SD of %s: %.4g\n', sigmaNames{k}, sigmas(k));
    end
    if isempty(betweenFactors)
        fprintf('No factor is constant within %s; subjects are drawn from a single pool.\n', groupNames{1});
    else
        fprintf('Subjects are drawn separately for each level of: %s\n', strjoin(betweenFactors,', '));
    end
    for s=1:numel(strata)
        fprintf('  %s: %d pilot subjects\n', strata(s), nPilotSubjects(s));
    end
    fprintf('Testing: %s\n', test.description);
end

 % step 5: simulate

design = struct();
design.factorNames = factorNames;
design.groupNames = groupNames;
design.groupVarNames = groupVarNames;
design.referenceCategories = referenceCategories;
design.factorLabels = cell(1,numel(factorNames));
for i=1:numel(factorNames)
    design.factorLabels{i} = string(pilotTable.(factorNames{i}));
end
design.groupLabels = cell(1,nGroupLevels);
for k=1:nGroupLevels
    design.groupLabels{k} = string(pilotTable.(groupVarNames{k}));
end
design.cellOfRow = cellOfRow;
design.subjectRows = subjectRows;
design.nUnitsPerSubject = options.nUnitsPerSubject;
design.nObsPerUnit = options.nObsPerUnit;
design.customDesign = ~isempty(options.nUnitsPerSubject) || ~isempty(options.nObsPerUnit);
if ~isempty(options.nUnitsPerSubject) && nGroupLevels~=2
    error('nUnitsPerSubject requires exactly 2 grouping levels (e.g., {''AnimalID'',''NeuronID''}).');
end
if ~isempty(options.nObsPerUnit) && nGroupLevels>2
    error('nObsPerUnit requires 1 or 2 grouping levels.');
end
if design.customDesign
     % for each pilot subject: the cells it contributed to, and its rows in each cell
     % (with 2 grouping levels, split into the rows of each unit)
    design.subjectCells = cell(numel(subjects),1);
    design.subjectCellRows = cell(numel(subjects),1);
    for a=1:numel(subjects)
        r = subjectRows{a};
        design.subjectCells{a} = unique(cellOfRow(r));
        design.subjectCellRows{a} = cell(nCells,1);
        for c=design.subjectCells{a}(:)'
            rc = r(cellOfRow(r)==c);
            if nGroupLevels==2
                [~,~,unitIndex] = unique(design.groupLabels{2}(rc));
                rc = accumarray(unitIndex,rc,[],@(x) {x});
            end
            design.subjectCellRows{a}{c} = rc;
        end
    end
    if nGroupLevels==2
         % for each cell, the rows of each pilot unit (to draw observation counts)
        design.cellUnitRows = cell(nCells,1);
        for c=1:nCells
            I = pilotStats.cellIndexes{c};
            [~,~,unitIndex] = unique(design.groupLabels{2}(I));
            design.cellUnitRows{c} = accumarray(unitIndex,I,[],@(x) {x});
        end
    end
end
design.stratumPools = stratumPools;
design.sigmas = sigmas;
design.baseline = baseline;
design.effectPattern = effectPattern;
design.effectSizes = effectSizes;
design.test = test;
design.testContrasts = options.testContrasts;
design.fitMethod = options.fitMethod;
design.dfMethod = options.dfMethod;

useParallel = options.useParallel && ~isempty(ver('parallel'));

nN = numel(nSubjectsPerGroup);
nES = numel(effectSizes);
nC = numel(options.testContrasts);
powerMatrix = zeros(nN,nES);
failedMatrix = zeros(nN,nES);
contrastEstimate = nan(options.numSimulations, nC, nN, nES);
contrastSE = nan(size(contrastEstimate));
contrastDF = nan(size(contrastEstimate));

for n=1:nN
    nSubjects = nSubjectsPerGroup(n);
    pValues = nan(options.numSimulations,nES);
    draws = nan(options.numSimulations,nES,nC,3);
    if useParallel
        parfor i=1:options.numSimulations
            [pv, dr] = simulateOnce(design,nSubjects);
            pValues(i,:) = pv;
            draws(i,:,:,:) = dr;
        end
    else
        for i=1:options.numSimulations
            [pv, dr] = simulateOnce(design,nSubjects);
            pValues(i,:) = pv;
            draws(i,:,:,:) = dr;
        end
    end
    for e=1:nES
        contrastEstimate(:,:,n,e) = reshape(draws(:,e,:,1), options.numSimulations, nC);
        contrastSE(:,:,n,e) = reshape(draws(:,e,:,2), options.numSimulations, nC);
        contrastDF(:,:,n,e) = reshape(draws(:,e,:,3), options.numSimulations, nC);
    end
    powerMatrix(n,:) = sum(pValues<options.alpha,1) / options.numSimulations;
    failedMatrix(n,:) = sum(isnan(pValues),1);
    if options.verbose
        fprintf('%d subjects per group: power = %s\n', nSubjects, ...
            strjoin(arrayfun(@(es,p) sprintf('%.2f (effect %g)',p,es), effectSizes, powerMatrix(n,:), ...
            'UniformOutput', false), ', '));
    end
end

 % step 6: compile the results

[nGrid,esGrid] = ndgrid(nSubjectsPerGroup,effectSizes);
powerTable = table(nGrid(:), esGrid(:), powerMatrix(:), failedMatrix(:), ...
    'VariableNames',{'nSubjectsPerGroup','effectSize','power','nFailed'});

required = nan(nES,1);
for e=1:nES
    firstGood = find(powerMatrix(:,e)>=options.targetPower,1);
    if ~isempty(firstGood)
        required(e) = nSubjectsPerGroup(firstGood);
    end
end
requiredSubjects = table(effectSizes(:), required, ...
    'VariableNames',{'effectSize',['nSubjectsPerGroupFor' int2str(round(100*options.targetPower)) 'Percent']});

effectPatternTable = table(cellMeans.Label, baseline, effectPattern, ...
    'VariableNames',{'Cell','Baseline','EffectPattern'});

results = struct('power',powerTable, 'powerMatrix',powerMatrix, 'requiredSubjects',requiredSubjects, ...
    'nSubjectsPerGroup',nSubjectsPerGroup, 'effectSizes',effectSizes, 'test',test, ...
    'effectPattern',effectPatternTable, 'pilot',pilot, 'options',options);

if nC > 0
    contrastNames = string(arrayfun(@(c) char(c.name), options.testContrasts(:)', 'UniformOutput', false));
    results.contrastDraws = struct('names', contrastNames, 'estimate', contrastEstimate, ...
        'se', contrastSE, 'df', contrastDF);
    rows = {};
    for n=1:nN
        for e=1:nES
            cp = vlt.stats.power.contrast_power_from_draws(contrastEstimate(:,:,n,e), ...
                contrastSE(:,:,n,e), contrastDF(:,:,n,e), zeros(1,nC), options.testContrasts, ...
                'alpha', options.alpha);
            rows(end+1,:) = {nSubjectsPerGroup(n), effectSizes(e), cp.powerEach, cp.powerAll, ...
                cp.powerEquivalent}; %#ok<AGROW>
        end
    end
    results.contrastPower = cell2table(rows, 'VariableNames', ...
        {'nSubjectsPerGroup','effectSize','powerEach','powerAll','powerEquivalent'});
    results.contrastPower.Properties.UserData = contrastNames;
end

if options.doPlot
    figure;
    hold on;
    colors = vlt.plot.colorlist();
    legendText = cell(1,nES);
    for e=1:nES
        plot(nSubjectsPerGroup, 100*powerMatrix(:,e), '-o', 'linewidth', 1.5, ...
            'color', colors(1+mod(e-1,size(colors,1)),:));
        legendText{e} = sprintf('effect = %g', effectSizes(e));
    end
    yline(100*options.targetPower, '--k');
    if isempty(betweenFactors)
        xlabel(['Number of ' groupNames{1}]);
    else
        xlabel([groupNames{1} ' per ' strjoin(betweenFactors,' / ') ' group']);
    end
    ylabel('Power (%)');
    ylim([0 100]);
    title(['Power for ' test.description],'Interpreter','none');
    legend(legendText,'Location','southeast');
    box off;
end

end

function [pValues, draws] = simulateOnce(design, nSubjects)
% SIMULATEONCE - draw subjects, simulate data for each effect size, fit, and return p-values

    nES = numel(design.effectSizes);
    pValues = nan(1,nES);
    nC = numel(design.testContrasts);
    draws = nan(nES, nC, 3); % estimate, SE, DF of each test contrast

     % draw subjects and collect the pilot rows that set their design
     % (the pilot rows only supply the factor levels; Y is simulated below)
    rows = [];
    newSubject = strings(0,1);
    newUnit = strings(0,1);
    oneLevel = numel(design.groupVarNames)==1;
    for s=1:numel(design.stratumPools)
        pool = design.stratumPools{s};
        drawn = pool(randi(numel(pool),nSubjects,1));
        for j=1:nSubjects
            subjectLabel = "s" + s + "a" + j;
            if ~design.customDesign
                r = design.subjectRows{drawn(j)};
                rows = [rows; r]; %#ok<AGROW>
                newSubject = [newSubject; repmat(subjectLabel, numel(r), 1)]; %#ok<AGROW>
                continue;
            end
            for c=design.subjectCells{drawn(j)}(:)'
                if oneLevel
                    r = design.subjectCellRows{drawn(j)}{c};
                    r = r(randi(numel(r),design.nObsPerUnit,1));
                    rows = [rows; r]; %#ok<AGROW>
                    newSubject = [newSubject; repmat(subjectLabel, numel(r), 1)]; %#ok<AGROW>
                    continue;
                end
                if isempty(design.nUnitsPerSubject)
                    units = design.subjectCellRows{drawn(j)}{c}; % this subject's pilot units
                    nUnits = numel(units);
                else
                    units = design.cellUnitRows{c}; % any pilot unit of this cell
                    nUnits = design.nUnitsPerSubject;
                end
                for u=1:nUnits
                    if isempty(design.nUnitsPerSubject)
                        r = units{u};
                    else
                        r = units{randi(numel(units))};
                    end
                    if ~isempty(design.nObsPerUnit)
                        r = r(randi(numel(r),design.nObsPerUnit,1));
                    end
                    rows = [rows; r]; %#ok<AGROW>
                    newSubject = [newSubject; repmat(subjectLabel, numel(r), 1)]; %#ok<AGROW>
                    newUnit = [newUnit; repmat("c" + c + "u" + u, numel(r), 1)]; %#ok<AGROW>
                end
            end
        end
    end
    nRows = numel(rows);

     % random effects and residuals (shared by all effect sizes)
    noise = zeros(nRows,1);
    simTable = table();
    for i=1:numel(design.factorNames)
        simTable.(design.factorNames{i}) = design.factorLabels{i}(rows);
    end
    for k=1:numel(design.groupVarNames)
        if k==1
            labels = newSubject;
        elseif design.customDesign
            labels = newSubject + "|" + newUnit;
        else
            labels = newSubject + "|" + design.groupLabels{k}(rows);
        end
        simTable.(design.groupNames{k}) = labels;
        [~,~,unitIndex] = unique(labels);
        b = randn(max(unitIndex),1) * design.sigmas(k);
        noise = noise + b(unitIndex);
    end
    noise = noise + randn(nRows,1) * design.sigmas(end);

    cellHere = design.cellOfRow(rows);

    for e=1:nES
        simTable.simY = design.baseline(cellHere) + ...
            design.effectSizes(e)*design.effectPattern(cellHere) + noise;
        try
            if strcmp(design.test.type,'term')
                [~,~,st] = vlt.stats.lme_factorial(simTable, 'simY', design.factorNames, design.groupNames, ...
                    'referenceCategories', design.referenceCategories, 'fitMethod', design.fitMethod, ...
                    'dfMethod', design.dfMethod, 'contrasts', 'none', 'computeEffects', false, ...
                    'plannedContrasts', design.testContrasts);
                p = st.anovaTable.pValue(strcmp(st.anovaTable.Term,design.test.term));
            else
                [~,~,st] = vlt.stats.lme_factorial(simTable, 'simY', design.factorNames, design.groupNames, ...
                    'referenceCategories', design.referenceCategories, 'fitMethod', design.fitMethod, ...
                    'dfMethod', design.dfMethod, 'contrasts', 'all', 'multipleComparisons', 'none', ...
                    'computeEffects', false, 'plannedContrasts', design.testContrasts);
                match = (st.contrasts.Cell1==design.test.cells(1) & st.contrasts.Cell2==design.test.cells(2)) | ...
                    (st.contrasts.Cell1==design.test.cells(2) & st.contrasts.Cell2==design.test.cells(1));
                p = st.contrasts.pValue(match);
            end
            if isscalar(p)
                pValues(e) = p;
            end
            if nC > 0 && height(st.plannedContrasts) == nC
                draws(e,:,1) = st.plannedContrasts.Estimate;
                draws(e,:,2) = st.plannedContrasts.SE;
                draws(e,:,3) = st.plannedContrasts.DF;
            end
        catch
            % fit failed; leave as NaN (counted as not significant)
        end
    end
end
