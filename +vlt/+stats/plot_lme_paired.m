function [h, plotInfo] = plot_lme_paired(lme, newTable, stats, options)
% PLOT_LME_PAIRED - subject means across the levels of a within-subject factor, one panel per other cell
%
% [H, PLOTINFO] = vlt.stats.PLOT_LME_PAIRED(LME, NEWTABLE, STATS, ...)
%
% For a model fit with vlt.stats.lme_factorial, plots each subject's raw mean
% (e.g., each animal) at each level of one factor (the WITHINFACTOR, e.g.
% Treatment: GFP and DREADDs) and joins the means of the same subject with a
% line. There is one panel for each combination of the levels of the other
% factors (e.g., one panel for ctrl and one for sh).
%
% A subject with data at two or more levels of WITHINFACTOR is a line, and
% the slope of the line is that subject's own effect of the factor (e.g., the
% DREADD effect within one animal). A subject with data at only one level is
% an open marker. Comparing the lines between panels shows the interaction:
% the interaction asks whether the effect of WITHINFACTOR differs between
% panels. The model's cell means +/- SE are drawn in black.
%
% Subject means are raw means (the mean of each subject's unit means; see
% vlt.stats.lme_factorial_subject_means), not model estimates. Each subject
% has the same color as in vlt.stats.plot_lme_superplot. For a log10 fit, the
% means are taken on the log scale and the y axis is logarithmic; for a rank
% fit, means are in the original units and the model cell means are converted
% from ranks to the original units.
%
% The panels are drawn in the current figure, which is cleared first. All
% panels share the same y axis.
%
% Inputs:
%   LME, NEWTABLE, STATS - the outputs of vlt.stats.lme_factorial
%
% Outputs:
%   H - handles of the plotted objects
%   PLOTINFO - a structure with fields subjectMeans (table: Panel, Subject,
%       SubjectIndex, Level, Mean, nUnits, nObs), panels (labels), nWithBoth
%       (number of subjects with data at two or more levels, per panel),
%       nSubjects (per panel), subjects, and subjectColors
%
% This function also takes name/value pairs that modify the default behavior:
% |---------------------------------|--------------------------------------------|
% | Parameter (default)             | Description                                |
% |---------------------------------|--------------------------------------------|
% | withinFactor ('')               | The factor on the x axis. Empty means the  |
% |                                 |   last factor.                             |
% | subjectColors ([])              | nSubjects x 3 colors, in the order of      |
% |                                 |   PLOTINFO.subjects; empty uses turbo      |
% | markerSize (9)                  | Marker size of the subject means           |
% | lineWidth (1.5)                 | Linewidth of the subject lines             |
% | spread (0.15)                   | Horizontal offset range between subjects,  |
% |                                 |   so overlapping means can be seen         |
% | cellMeanColor ([0 0 0])         | Color of the model cell means              |
% | cellMeanLineWidth (3)           | Linewidth of the model cell means          |
% | showLegend (true)               | Show a legend in the last panel            |
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
%   vlt.stats.plot_lme_paired(lme,newTable,stats,'yLabel','Spine density');
%
% See also: vlt.stats.lme_factorial, vlt.stats.plot_lme_superplot,
%   vlt.stats.lme_factorial_subject_means

arguments
    lme (1,1) LinearMixedModel %#ok<INUSA> (kept for a signature consistent with plot_lme_factorial)
    newTable table
    stats (1,1) struct
    options.withinFactor {mustBeTextScalar} = ''
    options.subjectColors double = []
    options.markerSize (1,1) double = 9
    options.lineWidth (1,1) double = 1.5
    options.spread (1,1) double {mustBeNonnegative} = 0.15
    options.cellMeanColor (1,3) double = [0 0 0]
    options.cellMeanLineWidth (1,1) double = 3
    options.showLegend (1,1) logical = true
    options.showStats (1,1) logical = true
    options.titleText {mustBeTextScalar} = ''
    options.yLabel {mustBeTextScalar} = ''
end

factorNames = stats.factorNames;
withinFactor = char(options.withinFactor);
if isempty(withinFactor)
    withinFactor = factorNames{end};
end
w = find(strcmp(factorNames, withinFactor));
if isempty(w)
    error('withinFactor must be one of: %s.', strjoin(factorNames,', '));
end
otherFactors = factorNames([1:w-1 w+1:end]);
levels = stats.factorLevels{w};
nLevels = numel(levels);

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
else
    toPlot = @(v) v;
end
modelToPlot = modelToPlotUnits(newTable, stats);

 % panel of each cell: the combination of the levels of the other factors
cellMeans = stats.cellMeans;
nCells = height(cellMeans);
panelOfCell = strings(nCells,1);
levelOfCell = zeros(nCells,1);
for c=1:nCells
    parts = cell(1,numel(otherFactors));
    for i=1:numel(otherFactors)
        parts{i} = cellMeans.(otherFactors{i}){c};
    end
    if isempty(parts)
        panelOfCell(c) = "all";
    else
        panelOfCell(c) = string(strjoin(parts,' / '));
    end
    levelOfCell(c) = find(strcmp(levels, cellMeans.(withinFactor){c}));
end
panels = unique(panelOfCell,'stable');
nPanels = numel(panels);

subjectMeans = means.subjectMeans;
subjectMeans.Panel = panelOfCell(subjectMeans.Cell);
subjectMeans.Level = levelOfCell(subjectMeans.Cell);
subjectMeans = subjectMeans(:,{'Panel','Subject','SubjectIndex','Level','Mean','nUnits','nObs'});

clf;
layout = tiledlayout(1, nPanels, 'TileSpacing', 'compact');
h = [];
axesHandles = gobjects(1,nPanels);
nWithBoth = zeros(nPanels,1);
nSubjects = zeros(nPanels,1);

for p=1:nPanels
    axesHandles(p) = nexttile;
    hold on;
    rowsHere = find(subjectMeans.Panel==panels(p));
    subjectsHere = unique(subjectMeans.SubjectIndex(rowsHere));
    nSubjects(p) = numel(subjectsHere);
    for k=1:numel(subjectsHere)
        rows = rowsHere(subjectMeans.SubjectIndex(rowsHere)==subjectsHere(k));
        [~,order] = sort(subjectMeans.Level(rows));
        rows = rows(order);
        color = colors(subjectsHere(k),:);
        offset = options.spread * ((k-0.5)/numel(subjectsHere) - 0.5);
        xs = subjectMeans.Level(rows) + offset;
        ys = toPlot(subjectMeans.Mean(rows));
        if numel(rows) > 1
            nWithBoth(p) = nWithBoth(p) + 1;
            h(end+1) = plot(xs, ys, '-o', 'color', color, 'markerfacecolor', color, ...
                'markersize', options.markerSize, 'linewidth', options.lineWidth); %#ok<AGROW>
        else
            h(end+1) = plot(xs, ys, 'o', 'color', color, 'markerfacecolor', 'none', ...
                'markersize', options.markerSize, 'linewidth', options.lineWidth); %#ok<AGROW>
        end
        addDataTips(h(end), numel(rows), stats.groupNames{1}, subjects(subjectsHere(k)));
    end

     % model cell means +/- SE
    cellsHere = find(panelOfCell==panels(p));
    [~,order] = sort(levelOfCell(cellsHere));
    cellsHere = cellsHere(order);
    xm = levelOfCell(cellsHere) + options.spread/2 + 0.12;
    h(end+1) = plot(xm, modelToPlot(cellMeans.Estimate(cellsHere)), '-s', ...
        'color', options.cellMeanColor, 'markerfacecolor', options.cellMeanColor, ...
        'linewidth', options.cellMeanLineWidth, 'markersize', 6); %#ok<AGROW>
    for c=cellsHere(:)'
        h(end+1) = plot((levelOfCell(c) + options.spread/2 + 0.12)*[1 1], ...
            modelToPlot(cellMeans.Estimate(c)+[-1 1]*cellMeans.SE(c)), '-', ...
            'color', options.cellMeanColor, 'linewidth', options.cellMeanLineWidth/2); %#ok<AGROW>
    end

    xticks(1:nLevels);
    xticklabels(strrep(levels,'_','\_'));
    xlim([0.5 nLevels+0.5]);
    xlabel(withinFactor, 'Interpreter', 'none');
    if p==1
        ylabel(options.yLabel);
    end
    if isLog
        set(gca,'yscale','log');
    end
    title(char(panels(p)), 'Interpreter', 'none');
    subtitle(sprintf('%d of %d %s with more than one level', nWithBoth(p), nSubjects(p), ...
        stats.groupNames{1}), 'Interpreter', 'none');
    box off;
end
linkaxes(axesHandles, 'y');

if options.showLegend
    legendHandles = [plot(axesHandles(end), nan, nan, '-o', 'color', [0.5 0.5 0.5], ...
            'markerfacecolor', [0.5 0.5 0.5], 'markersize', options.markerSize, 'linewidth', options.lineWidth), ...
        plot(axesHandles(end), nan, nan, 'o', 'color', [0.5 0.5 0.5], 'markersize', options.markerSize, ...
            'linewidth', options.lineWidth), ...
        plot(axesHandles(end), nan, nan, '-s', 'color', options.cellMeanColor, ...
            'markerfacecolor', options.cellMeanColor, 'linewidth', options.cellMeanLineWidth)];
    legend(axesHandles(end), legendHandles, ...
        {sprintf('one %s (both levels)', stats.groupNames{1}), ...
        sprintf('%s with one level only', stats.groupNames{1}), 'model cell mean \pm SE'}, ...
        'Location', 'best');
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
    title(layout, titleLines, 'Interpreter', 'none');
end

subjectColors = colors(1:numel(subjects),:);
plotInfo = struct('subjectMeans',subjectMeans, 'panels',panels, 'nWithBoth',nWithBoth, ...
    'nSubjects',nSubjects, 'subjects',subjects, 'subjectColors',subjectColors);

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
