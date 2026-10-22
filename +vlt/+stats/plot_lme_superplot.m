function [h, plotInfo] = plot_lme_superplot(lme, newTable, stats, options)
% PLOT_LME_SUPERPLOT - "SuperPlot" of a factorial, nested LME: observations, unit means, and subject means
%
% [H, PLOTINFO] = vlt.stats.PLOT_LME_SUPERPLOT(LME, NEWTABLE, STATS, ...)
%
% Plots (in the current axes) the data from a model fit with
% vlt.stats.lme_factorial in the style of a SuperPlot (Lord et al., 2020,
% J Cell Biol 219:e202001064), so that every level of the nesting is visible.
% Each cell of the design is one column, and in each column:
%
%   - every observation (e.g., dendritic segment) is a small gray point;
%   - every innermost unit's raw mean (e.g., each neuron) is a medium marker,
%     colored by its subject (e.g., its animal);
%   - every subject's raw mean (the mean of its unit means) is a large marker
%     in the same color with a black edge;
%   - the model's cell mean (fixed effects only) is a thick black bar, and its
%     standard error a thick vertical bar.
%
% Each subject has the same color in every column (and in
% vlt.stats.plot_lme_paired), so the same animal can be followed across cells.
% By default each subject has its own position within a column, with its
% units around it, so subjects do not hide each other.
%
% The unit and subject markers are raw means (see
% vlt.stats.lme_factorial_subject_means), not model estimates; they are more
% spread out than the model's random effects. For a log10 fit, the means are
% taken on the log scale and the y axis is logarithmic. For a rank fit, the
% observations and means are in the original units and the model cell means
% are converted from ranks to the original units.
%
% Inputs:
%   LME, NEWTABLE, STATS - the outputs of vlt.stats.lme_factorial
%
% Outputs:
%   H - handles of the plotted objects
%   PLOTINFO - a structure with fields subjectMeans and unitMeans (tables, as
%       from vlt.stats.lme_factorial_subject_means, with an added x column),
%       subjects, subjectColors, and cellCenters
%
% This function also takes name/value pairs that modify the default behavior:
% |---------------------------------|--------------------------------------------|
% | Parameter (default)             | Description                                |
% |---------------------------------|--------------------------------------------|
% | subjectColors ([])              | nSubjects x 3 colors, in the order of      |
% |                                 |   PLOTINFO.subjects; empty uses turbo      |
% | separateSubjects (true)         | Give each subject its own position within  |
% |                                 |   a column (true) or overlap them (false)  |
% | cellWidth (0.8)                 | Width of each column                       |
% | factorSpace (0.5)               | Extra space between levels of the first    |
% |                                 |   factor                                   |
% | observationColor ([.7 .7 .7])   | Color of the observation points            |
% | observationMarkerSize (3)       | Marker size of the observation points      |
% | unitMarkerSize (6)              | Marker size of the unit means              |
% | subjectMarkerSize (12)          | Marker size of the subject means           |
% | cellMeanColor ([0 0 0])         | Color of the cell mean and SE bars         |
% | cellMeanLineWidth (3)           | Linewidth of the cell mean and SE bars     |
% | showLegend (true)               | Show a legend of the marker types          |
% | showStats (true)                | Show the ANOVA p-values in the title       |
% | titleText ('')                  | Text for the first line of the title       |
% | yLabel ('')                     | Y axis label                               |
% |---------------------------------|--------------------------------------------|
%
% Example:
%   [lme,newTable,stats] = vlt.stats.lme_factorial(tbl,'Density',...
%       {'Condition','Treatment'},{'AnimalID','NeuronID'},...
%       'referenceCategories',{'ctrl','GFP'});
%   figure;
%   vlt.stats.plot_lme_superplot(lme,newTable,stats,'yLabel','Spine density');
%
% See also: vlt.stats.lme_factorial, vlt.stats.plot_lme_paired,
%   vlt.stats.plot_lme_factorial, vlt.stats.lme_factorial_subject_means

arguments
    lme (1,1) LinearMixedModel %#ok<INUSA> (kept for a signature consistent with plot_lme_factorial)
    newTable table
    stats (1,1) struct
    options.subjectColors double = []
    options.separateSubjects (1,1) logical = true
    options.cellWidth (1,1) double {mustBePositive} = 0.8
    options.factorSpace (1,1) double {mustBeNonnegative} = 0.5
    options.observationColor (1,3) double = [0.7 0.7 0.7]
    options.observationMarkerSize (1,1) double = 3
    options.unitMarkerSize (1,1) double = 6
    options.subjectMarkerSize (1,1) double = 12
    options.cellMeanColor (1,3) double = [0 0 0]
    options.cellMeanLineWidth (1,1) double = 3
    options.showLegend (1,1) logical = true
    options.showStats (1,1) logical = true
    options.titleText {mustBeTextScalar} = ''
    options.yLabel {mustBeTextScalar} = ''
end

means = vlt.stats.lme_factorial_subject_means(newTable, stats);
subjects = means.subjects;
colors = options.subjectColors;
if isempty(colors)
    colors = turbo(max(numel(subjects),2));
end
if size(colors,1) < numel(subjects) || size(colors,2) ~= 3
    error('subjectColors must have one row (RGB) per subject (%d).', numel(subjects));
end

isLog = strcmp(means.scale,'log10');
if isLog
    toPlot = @(v) 10.^v;
    observations = newTable.(stats.yNameFixed);
else
    toPlot = @(v) v;
    observations = newTable.original_data;
end
modelToPlot = modelToPlotUnits(newTable, stats);

cellMeans = stats.cellMeans;
nCells = height(cellMeans);
firstFactor = stats.factorNames{1};
cellCenters = zeros(nCells,1);
x = 1;
for c=1:nCells
    if c>1 && ~strcmp(cellMeans.(firstFactor){c}, cellMeans.(firstFactor){c-1})
        x = x + options.factorSpace;
    end
    cellCenters(c) = x;
    x = x + 1;
end
halfWidth = options.cellWidth/2;

subjectLabels = string(newTable.(stats.groupVarNames{1}));
subjectMeans = means.subjectMeans;
unitMeans = means.unitMeans;
subjectMeans.x = nan(height(subjectMeans),1);
unitMeans.x = nan(height(unitMeans),1);

holdState = ishold;
hold on;
h = [];

for c=1:nCells
    I = stats.cellIndexes{c};
    if isempty(I)
        continue;
    end
     % observations, spread over the whole column
    xObs = cellCenters(c) + (rand(numel(I),1)-0.5)*options.cellWidth;
    h(end+1) = plot(xObs, toPlot(observations(I)), '.', 'color', options.observationColor, ...
        'markersize', 2*options.observationMarkerSize); %#ok<AGROW>

    rows = find(subjectMeans.Cell==c);
    nHere = numel(rows);
    for k=1:nHere
        r = rows(k);
        if options.separateSubjects
            xs = cellCenters(c) - halfWidth + (k-0.5)*options.cellWidth/nHere;
            spread = 0.6*options.cellWidth/nHere;
        else
            xs = cellCenters(c);
            spread = 0.5*options.cellWidth;
        end
        subjectMeans.x(r) = xs;
        color = colors(subjectMeans.SubjectIndex(r),:);

        unitRows = find(unitMeans.Cell==c & unitMeans.Subject==subjectMeans.Subject(r));
        xu = xs + (rand(numel(unitRows),1)-0.5)*spread;
        unitMeans.x(unitRows) = xu;
        h(end+1) = plot(xu, toPlot(unitMeans.Mean(unitRows)), 'o', 'color', 0.6*color, ...
            'markerfacecolor', color, 'markersize', options.unitMarkerSize); %#ok<AGROW>
        addDataTips(h(end), numel(unitRows), stats.groupNames{1}, subjectMeans.Subject(r));

        h(end+1) = plot(xs, toPlot(subjectMeans.Mean(r)), 'o', 'color', [0 0 0], ...
            'markerfacecolor', color, 'markersize', options.subjectMarkerSize, 'linewidth', 1.5); %#ok<AGROW>
        addDataTips(h(end), 1, stats.groupNames{1}, subjectMeans.Subject(r));
    end

     % model cell mean +/- SE
    if ~isnan(cellMeans.Estimate(c))
        h(end+1) = plot(cellCenters(c)+[-halfWidth halfWidth], ...
            modelToPlot(cellMeans.Estimate(c))*[1 1], '-', 'color', options.cellMeanColor, ...
            'linewidth', options.cellMeanLineWidth); %#ok<AGROW>
        h(end+1) = plot(cellCenters(c)*[1 1], ...
            modelToPlot(cellMeans.Estimate(c)+[-1 1]*cellMeans.SE(c)), '-', ...
            'color', options.cellMeanColor, 'linewidth', options.cellMeanLineWidth); %#ok<AGROW>
    end
end

if isLog
    set(gca,'yscale','log');
end
xlim([cellCenters(1)-0.6 cellCenters(end)+0.6]);

tickLabels = cell(nCells,1);
for c=1:nCells
    tickLabels{c} = strrep(cellMeans.(stats.factorNames{1}){c},'_','\_');
    for i=2:numel(stats.factorNames)
        % concatenate rather than strjoin: strjoin would turn the \n of \newline into a line break
        tickLabels{c} = [tickLabels{c} '\newline' strrep(cellMeans.(stats.factorNames{i}){c},'_','\_')];
    end
end
set(gca,'xtick',cellCenters,'xticklabel',tickLabels,'TickLabelInterpreter','tex');
ylabel(options.yLabel);
box off;

if options.showLegend
    nestedNames = stats.groupNames;
    legendHandles = gobjects(0);
    legendText = {};
    legendHandles(end+1) = plot(nan, nan, '.', 'color', options.observationColor, ...
        'markersize', 2*options.observationMarkerSize);
    legendText{end+1} = 'observations';
    if numel(stats.groupVarNames) > 1
        legendHandles(end+1) = plot(nan, nan, 'o', 'color', [0.4 0.4 0.4], ...
            'markerfacecolor', [0.6 0.6 0.6], 'markersize', options.unitMarkerSize);
        legendText{end+1} = sprintf('%s means (color: %s)', nestedNames{end}, nestedNames{1});
    end
    legendHandles(end+1) = plot(nan, nan, 'o', 'color', [0 0 0], 'markerfacecolor', [0.6 0.6 0.6], ...
        'markersize', options.subjectMarkerSize, 'linewidth', 1.5);
    legendText{end+1} = sprintf('%s means', nestedNames{1});
    legendHandles(end+1) = plot(nan, nan, '-', 'color', options.cellMeanColor, ...
        'linewidth', options.cellMeanLineWidth);
    legendText{end+1} = 'model cell mean \pm SE';
    legend(legendHandles, legendText, 'Location', 'best');
end

titleLines = {};
if ~isempty(options.titleText)
    titleLines{end+1} = char(options.titleText);
end
if options.showStats
    terms = stats.anovaTable.Term;
    pValues = stats.anovaTable.pValue;
    keep = ~strcmp(terms,'(Intercept)');
    terms = terms(keep);
    pValues = pValues(keep);
    titleParts = cell(1,numel(terms));
    for i=1:numel(terms)
        titleParts{i} = sprintf('%s: p = %.3g',terms{i},pValues(i));
    end
    titleLines{end+1} = strjoin(titleParts,', ');
end
if ~isempty(titleLines)
    title(titleLines,'Interpreter','none');
end

if ~holdState
    hold off;
end

subjectColors = colors(1:numel(subjects),:);
plotInfo = struct('subjectMeans',subjectMeans, 'unitMeans',unitMeans, 'subjects',subjects, ...
    'subjectColors',subjectColors, 'cellCenters',cellCenters);

end

function f = modelToPlotUnits(newTable, stats)
% MODELTOPLOTUNITS - function that converts model values (fit scale) to the plotted units
    switch stats.transform
        case 'log10'
            f = @(v) 10.^v;
        case 'rank'
            ranked = newTable.(stats.yNameFixed);
            original = newTable.original_data;
            [~,u] = unique(ranked);
            f = @(v) interp1(ranked(u), original(u), v, 'linear');
        otherwise
            f = @(v) v;
    end
end

function addDataTips(hLine, n, name, label)
% ADDDATATIPS - add the subject label to the data tips of a line
    try
        dataTipTemplate = get(hLine,'DataTipTemplate');
        dataTipTemplate.DataTipRows(end+1) = dataTipTextRow(name, repmat({char(label)},n,1));
    catch
        % data tips are not available in this version of MATLAB
    end
end
