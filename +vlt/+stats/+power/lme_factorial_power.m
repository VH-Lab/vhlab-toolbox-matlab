function results = lme_factorial_power(tbl, yName, factorNames, groupNames, nAnimalsPerGroup, effectSizes, options)
% LME_FACTORIAL_POWER - power vs. number of animals for a factorial, nested LME (vlt.stats.lme_factorial)
%
% RESULTS = vlt.stats.power.LME_FACTORIAL_POWER(TBL, YNAME, FACTORNAMES, GROUPNAMES, ...
%       NANIMALSPERGROUP, EFFECTSIZES, ...)
%
% Estimates, by simulation, the statistical power of the analysis performed by
% vlt.stats.lme_factorial (crossed fixed factors, nested random intercepts) as a
% function of the number of animals (outermost random-effect units) and the
% size of a hypothesized effect.
%
% Process:
%   1. The model is fit to the pilot data TBL with vlt.stats.lme_factorial to
%      estimate the variance components: the SD of each nested random effect
%      (e.g., animal-to-animal and neuron-to-neuron within animal) and the
%      residual SD (e.g., dendrite-to-dendrite within neuron).
%   2. Animals are grouped into strata by the factors that do not vary within
%      an animal (e.g., Condition, if each animal is either ctrl or sh). Factors
%      that vary within an animal (e.g., Treatment) are left as they were in
%      the pilot animals.
%   3. For each number of animals N in NANIMALSPERGROUP, and for each of
%      NUMSIMULATIONS repetitions, N pilot animals are drawn (with replacement)
%      from each stratum. Each drawn animal keeps the pilot design: which cells
%      it contributed to, how many inner units (e.g., neurons) it had in each
%      cell, and how many observations each inner unit had. (Optionally, the
%      number of inner units per animal per cell can be set with
%      'nInnerPerCell'.)
%   4. New data are generated from a Gaussian model with the pilot variance
%      components:
%         Y = baseline(cell) + effectSize * effectPattern(cell)
%             + animal effect + neuron effect + ... + residual
%   5. vlt.stats.lme_factorial is fit to each simulated data set and the term
%      (or contrast) of interest is tested. Power is the fraction of
%      simulations with p < alpha. All effect sizes are tested on the same
%      simulated random effects and noise, so the power curves are smooth.
%
% Inputs:
%   TBL - the pilot data table
%   YNAME - the response column (e.g., 'Density')
%   FACTORNAMES - cell array of the fixed factors (e.g., {'Condition','Treatment'})
%   GROUPNAMES - cell array of the nested random effects, outermost first
%       (e.g., {'AnimalID','NeuronID'})
%   NANIMALSPERGROUP - vector of numbers of animals per stratum to try (e.g., 4:2:20)
%   EFFECTSIZES - vector of effect sizes to try, in units of YNAME (e.g., [1 2 3])
%
% Output:
%   RESULTS - a structure with fields:
%       power - table with columns nAnimalsPerGroup, effectSize, power, nFailed
%       powerMatrix - numel(NANIMALSPERGROUP) x numel(EFFECTSIZES) matrix of power
%       requiredAnimals - table with, for each effect size, the smallest tested
%           number of animals per group that reached targetPower (NaN if none did)
%       test - a description of the term or contrast that was tested
%       effectPattern - table of the cells and the effect pattern that was injected
%       pilot - structure with the pilot fit: formula, sigmas (SD of each random
%           effect and the residual, in that order), sigmaNames, strata, the number
%           of pilot animals in each stratum, and the pilot cell means
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
% | nInnerPerCell ([])              | If not empty, each simulated animal has    |
% |                                 |   this many inner units (e.g., neurons) in |
% |                                 |   each cell it contributed to in the pilot |
% |                                 |   data, instead of its pilot number. The   |
% |                                 |   number of observations of each inner     |
% |                                 |   unit is drawn from the pilot inner units |
% |                                 |   of the same cell. Requires exactly 2     |
% |                                 |   grouping levels (e.g., animal, neuron).  |
% | targetPower (0.8)               | Power used for requiredAnimals             |
% | alpha (0.05)                    | Significance level                         |
% | numSimulations (500)            | Simulations per number of animals          |
% | fitMethod ('REML')              | Passed to vlt.stats.lme_factorial          |
% | dfMethod ('satterthwaite')      | Passed to vlt.stats.lme_factorial          |
% | useParallel (true)              | Use parfor if the Parallel Computing       |
% |                                 |   Toolbox is available                     |
% | doPlot (true)                   | Plot power vs. number of animals           |
% | verbose (true)                  | Print progress                             |
% |---------------------------------|--------------------------------------------|
%
% Notes:
%   - With the default targetCell (the last cell, e.g. sh/DREADDs), an effect
%     size of D means: the treatment changes Y by D only in the non-reference
%     condition. The interaction (difference of differences) is then D, the
%     simple effect of Treatment within sh is D, and each main effect is D/2.
%   - A simulation in which the model cannot be fit, or the test cannot be
%     computed (for example, because no drawn animal contributed to one cell),
%     is counted as not significant; the number of such simulations is
%     reported in the nFailed column.
%   - The simulation is Gaussian. Outliers in the pilot data inflate the
%     residual SD, which makes the power estimates conservative.
%
% Example:
%   tbl = readtable('Big_data_spine_density_rat_DREADDs.xlsx');
%   results = vlt.stats.power.lme_factorial_power(tbl,'Density',...
%       {'Condition','Treatment'},{'AnimalID','NeuronID'},4:2:20,[1 2 3],...
%       'referenceCategories',{'ctrl','GFP'},'testTerm','Condition:Treatment');
%   disp(results.requiredAnimals);
%
% See also: vlt.stats.lme_factorial, vlt.stats.power.simpleLMEM,
%   vlt.stats.power.lme_power_effectsize
%

arguments
    tbl table
    yName (1,:) char
    factorNames {mustBeText}
    groupNames {mustBeText}
    nAnimalsPerGroup (1,:) double {mustBeInteger, mustBePositive}
    effectSizes (1,:) double
    options.referenceCategories {mustBeText} = {}
    options.testTerm (1,:) char = ''
    options.testContrast string = string.empty
    options.targetCell {mustBeText} = {}
    options.effectPattern double = []
    options.baseline (1,:) char {mustBeMember(options.baseline,{'null','pilot'})} = 'null'
    options.nInnerPerCell double {mustBeScalarOrEmpty, mustBeInteger, mustBePositive} = []
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
    'dfMethod', options.dfMethod, 'contrasts', 'none');

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

 % step 4: strata of animals (combinations of factors that do not vary within an animal)

outerVar = groupVarNames{1};
animals = categories(removecats(pilotTable.(outerVar)));
isBetween = true(1,numel(factorNames));
for i=1:numel(factorNames)
    for a=1:numel(animals)
        levelsHere = unique(pilotTable.(factorNames{i})(pilotTable.(outerVar)==animals{a}));
        if numel(levelsHere)>1
            isBetween(i) = false;
            break;
        end
    end
end
betweenFactors = factorNames(isBetween);

animalStratum = strings(numel(animals),1);
animalRows = cell(numel(animals),1);
for a=1:numel(animals)
    animalRows{a} = find(pilotTable.(outerVar)==animals{a});
    parts = strings(1,numel(betweenFactors));
    for i=1:numel(betweenFactors)
        parts(i) = string(pilotTable.(betweenFactors{i})(animalRows{a}(1)));
    end
    if isempty(parts)
        animalStratum(a) = "all";
    else
        animalStratum(a) = strjoin(parts," / ");
    end
end
strata = unique(animalStratum,'stable');
stratumPools = cell(numel(strata),1);
nPilotAnimals = zeros(numel(strata),1);
for s=1:numel(strata)
    stratumPools{s} = find(animalStratum==strata(s));
    nPilotAnimals(s) = numel(stratumPools{s});
end

pilot = struct('formula',pilotStats.formula, 'sigmas',sigmas, 'sigmaNames',{sigmaNames}, ...
    'betweenFactors',{betweenFactors}, 'strata',strata, 'nPilotAnimals',nPilotAnimals, ...
    'cellMeans',cellMeans);

if options.verbose
    fprintf('Pilot model: %s\n', pilotStats.formula);
    for k=1:numel(sigmas)
        fprintf('  SD of %s: %.4g\n', sigmaNames{k}, sigmas(k));
    end
    if isempty(betweenFactors)
        fprintf('No factor is constant within %s; animals are drawn from a single pool.\n', groupNames{1});
    else
        fprintf('Animals are drawn separately for each level of: %s\n', strjoin(betweenFactors,', '));
    end
    for s=1:numel(strata)
        fprintf('  %s: %d pilot animals\n', strata(s), nPilotAnimals(s));
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
design.animalRows = animalRows;
design.nInnerPerCell = options.nInnerPerCell;
if ~isempty(options.nInnerPerCell)
    if nGroupLevels~=2
        error('nInnerPerCell requires exactly 2 grouping levels (e.g., {''AnimalID'',''NeuronID''}).');
    end
     % for each cell, the rows of each pilot inner unit
    design.cellUnitRows = cell(nCells,1);
    for c=1:nCells
        I = pilotStats.cellIndexes{c};
        [~,~,unitIndex] = unique(design.groupLabels{2}(I));
        design.cellUnitRows{c} = accumarray(unitIndex,I,[],@(r) {r});
    end
     % for each pilot animal, the cells it contributed to
    design.animalCells = cellfun(@(r) unique(cellOfRow(r)), animalRows, 'UniformOutput', false);
end
design.stratumPools = stratumPools;
design.sigmas = sigmas;
design.baseline = baseline;
design.effectPattern = effectPattern;
design.effectSizes = effectSizes;
design.test = test;
design.fitMethod = options.fitMethod;
design.dfMethod = options.dfMethod;

useParallel = options.useParallel && ~isempty(ver('parallel'));

nN = numel(nAnimalsPerGroup);
nES = numel(effectSizes);
powerMatrix = zeros(nN,nES);
failedMatrix = zeros(nN,nES);

for n=1:nN
    nAnimals = nAnimalsPerGroup(n);
    pValues = nan(options.numSimulations,nES);
    if useParallel
        parfor i=1:options.numSimulations
            pValues(i,:) = simulateOnce(design,nAnimals);
        end
    else
        for i=1:options.numSimulations
            pValues(i,:) = simulateOnce(design,nAnimals);
        end
    end
    powerMatrix(n,:) = sum(pValues<options.alpha,1) / options.numSimulations;
    failedMatrix(n,:) = sum(isnan(pValues),1);
    if options.verbose
        fprintf('%d animals per group: power = %s\n', nAnimals, ...
            strjoin(arrayfun(@(es,p) sprintf('%.2f (effect %g)',p,es), effectSizes, powerMatrix(n,:), ...
            'UniformOutput', false), ', '));
    end
end

 % step 6: compile the results

[nGrid,esGrid] = ndgrid(nAnimalsPerGroup,effectSizes);
powerTable = table(nGrid(:), esGrid(:), powerMatrix(:), failedMatrix(:), ...
    'VariableNames',{'nAnimalsPerGroup','effectSize','power','nFailed'});

required = nan(nES,1);
for e=1:nES
    firstGood = find(powerMatrix(:,e)>=options.targetPower,1);
    if ~isempty(firstGood)
        required(e) = nAnimalsPerGroup(firstGood);
    end
end
requiredAnimals = table(effectSizes(:), required, ...
    'VariableNames',{'effectSize',['nAnimalsPerGroupFor' int2str(round(100*options.targetPower)) 'Percent']});

effectPatternTable = table(cellMeans.Label, baseline, effectPattern, ...
    'VariableNames',{'Cell','Baseline','EffectPattern'});

results = struct('power',powerTable, 'powerMatrix',powerMatrix, 'requiredAnimals',requiredAnimals, ...
    'nAnimalsPerGroup',nAnimalsPerGroup, 'effectSizes',effectSizes, 'test',test, ...
    'effectPattern',effectPatternTable, 'pilot',pilot, 'options',options);

if options.doPlot
    figure;
    hold on;
    colors = vlt.plot.colorlist();
    legendText = cell(1,nES);
    for e=1:nES
        plot(nAnimalsPerGroup, 100*powerMatrix(:,e), '-o', 'linewidth', 1.5, ...
            'color', colors(1+mod(e-1,size(colors,1)),:));
        legendText{e} = sprintf('effect = %g', effectSizes(e));
    end
    yline(100*options.targetPower, '--k');
    xlabel(['Animals per ' strjoin(betweenFactors,' / ') ' group']);
    ylabel('Power (%)');
    ylim([0 100]);
    title(['Power for ' test.description],'Interpreter','none');
    legend(legendText,'Location','southeast');
    box off;
end

end

function pValues = simulateOnce(design, nAnimals)
% SIMULATEONCE - draw animals, simulate data for each effect size, fit, and return p-values

    nES = numel(design.effectSizes);
    pValues = nan(1,nES);

     % draw animals and collect their pilot rows
    rows = [];
    newAnimal = strings(0,1);
    newInner = strings(0,1);
    for s=1:numel(design.stratumPools)
        pool = design.stratumPools{s};
        drawn = pool(randi(numel(pool),nAnimals,1));
        for j=1:nAnimals
            animalLabel = "s" + s + "a" + j;
            if isempty(design.nInnerPerCell)
                r = design.animalRows{drawn(j)};
                rows = [rows; r]; %#ok<AGROW>
                newAnimal = [newAnimal; repmat(animalLabel, numel(r), 1)]; %#ok<AGROW>
            else
                cellsHere = design.animalCells{drawn(j)};
                for c=cellsHere(:)'
                    units = design.cellUnitRows{c};
                    for u=1:design.nInnerPerCell
                        r = units{randi(numel(units))};
                        rows = [rows; r]; %#ok<AGROW>
                        newAnimal = [newAnimal; repmat(animalLabel, numel(r), 1)]; %#ok<AGROW>
                        newInner = [newInner; repmat("c" + c + "u" + u, numel(r), 1)]; %#ok<AGROW>
                    end
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
            labels = newAnimal;
        elseif ~isempty(design.nInnerPerCell)
            labels = newAnimal + "|" + newInner;
        else
            labels = newAnimal + "|" + design.groupLabels{k}(rows);
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
                    'dfMethod', design.dfMethod, 'contrasts', 'none');
                p = st.anovaTable.pValue(strcmp(st.anovaTable.Term,design.test.term));
            else
                [~,~,st] = vlt.stats.lme_factorial(simTable, 'simY', design.factorNames, design.groupNames, ...
                    'referenceCategories', design.referenceCategories, 'fitMethod', design.fitMethod, ...
                    'dfMethod', design.dfMethod, 'contrasts', 'all', 'multipleComparisons', 'none');
                match = (st.contrasts.Cell1==design.test.cells(1) & st.contrasts.Cell2==design.test.cells(2)) | ...
                    (st.contrasts.Cell1==design.test.cells(2) & st.contrasts.Cell2==design.test.cells(1));
                p = st.contrasts.pValue(match);
            end
            if isscalar(p)
                pValues(e) = p;
            end
        catch
            % fit failed; leave as NaN (counted as not significant)
        end
    end
end
