function [h, plotInfo] = plot_lme_factorial(lme, newTable, stats, options)
% PLOT_LME_FACTORIAL - plot data, nested random effects, and cell means from vlt.stats.lme_factorial
%
% [H, PLOTINFO] = vlt.stats.PLOT_LME_FACTORIAL(LME, NEWTABLE, STATS, ...)
%
% Plots (in the current axes) the data from a model fit with
% vlt.stats.lme_factorial. Each cell of the design (for example,
% ctrl/GFP, ctrl/DREADDs, sh/GFP, sh/DREADDs) is a separate column of the
% plot. Within each cell:
%
%   - Each data point is plotted, grouped by the innermost random-effect unit
%     (for example, each neuron), and units are grouped by the outermost
%     random-effect unit (for example, each animal).
%   - The model estimate for each innermost unit (fixed effects plus all of
%     the random effects) is shown with a short horizontal bar.
%   - If there are nested grouping levels, the model estimate for each outermost
%     unit (fixed effects plus the outermost random effect) is shown with a
%     horizontal bar that spans all of that unit's inner units.
%   - The cell mean (fixed effects only) is shown with a thick horizontal bar
%     and its standard error is shown with a thick vertical bar.
%
% This is the multi-factor / nested analog of vlt.stats.plot_lme_category.
% The p-values of the main effects and interactions (from STATS.anovaTable)
% are shown in the title.
%
% Inputs:
%   LME, NEWTABLE, STATS - the outputs of vlt.stats.lme_factorial
%
% Outputs:
%   H - handles of the plotted objects
%   PLOTINFO - a structure with the x locations and values that were plotted
%
% This function also takes name/value pairs that modify the default behavior:
% |---------------------------------|--------------------------------------------|
% | Parameter (default)             | Description                                |
% |---------------------------------|--------------------------------------------|
% | colors (default plot colors)    | An Nx3 array of colors. Colors repeat if   |
% |                                 |   there are more than N colors needed.     |
% | colorBy ('cell')                | Choose the color by 'cell', or by the level|
% |                                 |   of the 'firstFactor' or 'lastFactor'     |
% | withinGroupSpace (1)            | X-axis spacing between innermost units     |
% | betweenGroupSpace (0.5)         | Extra x-axis space between outermost units |
% | acrossCellSpace (2)             | X-axis space between cells                 |
% | acrossFactorSpace (1)           | Extra x-axis space between levels of the   |
% |                                 |   first factor                             |
% | jitterWidth (0.5)               | Width of the random x jitter of the points |
% | cellMeanColor ([0 0 0])         | Color of the cell mean and SE bars         |
% | cellMeanLineWidth (4)           | Linewidth of the cell mean and SE bars     |
% | innerMeanColor ([0 0 0])        | Color of the innermost unit mean bars      |
% | innerMeanLineWidth (2)          | Linewidth of the innermost unit mean bars  |
% | outerMeanColor ([0.5 0.5 0.5])  | Color of the outermost unit mean bars      |
% | outerMeanLineWidth (2)          | Linewidth of the outermost unit mean bars  |
% | pointMarkerSize (8)             | Marker size of the data points             |
% | pointMarkerShape ('o')          | Marker shape of the data points            |
% | boxState ('off')                | Box state of the axes                      |
% | plotOriginalData (true)         | If the data were ranked, plot the original |
% |                                 |   data (true) or the ranks (false)?        |
% | sortRandomEffects (true)        | Plot units in ascending order of their     |
% |                                 |   random effect (true) or in label order   |
% | showStats (true)                | Show the ANOVA p-values in the title       |
% | yLabel ('')                     | Y axis label                               |
% |---------------------------------|--------------------------------------------|
%
% Example:
%   [lme,newTable,stats] = vlt.stats.lme_factorial(tbl,'Density',...
%       {'Condition','Treatment'},{'AnimalID','NeuronID'},...
%       'referenceCategories',{'ctrl','GFP'});
%   figure;
%   vlt.stats.plot_lme_factorial(lme,newTable,stats,'yLabel','Spine density');
%
% See also: vlt.stats.lme_factorial, vlt.stats.plot_lme_category
%

arguments
    lme (1,1) LinearMixedModel
    newTable table
    stats (1,1) struct
    options.colors (:,3) double = vlt.plot.colorlist()
    options.colorBy (1,:) char {mustBeMember(options.colorBy,{'cell','firstFactor','lastFactor'})} = 'cell'
    options.withinGroupSpace (1,1) double = 1
    options.betweenGroupSpace (1,1) double = 0.5
    options.acrossCellSpace (1,1) double = 2
    options.acrossFactorSpace (1,1) double = 1
    options.jitterWidth (1,1) double = 0.5
    options.cellMeanColor (1,3) double = [0 0 0]
    options.cellMeanLineWidth (1,1) double = 4
    options.innerMeanColor (1,3) double = [0 0 0]
    options.innerMeanLineWidth (1,1) double = 2
    options.outerMeanColor (1,3) double = [0.5 0.5 0.5]
    options.outerMeanLineWidth (1,1) double = 2
    options.pointMarkerSize (1,1) double = 8
    options.pointMarkerShape (1,1) char = 'o'
    options.boxState (1,:) char {mustBeMember(options.boxState,{'on','off'})} = 'off'
    options.plotOriginalData (1,1) logical = true
    options.sortRandomEffects (1,1) logical = true
    options.showStats (1,1) logical = true
    options.yLabel {mustBeText} = ''
end

groupVarNames = stats.groupVarNames;
nLevelsGroup = numel(groupVarNames);
outerVar = groupVarNames{1};
innerVar = groupVarNames{end};
cellMeans = stats.cellMeans;
nCells = height(cellMeans);

isRanked = strcmp(stats.transform,'rank');
isLog = strcmp(stats.transform,'log10');
backTransformRanks = isRanked && options.plotOriginalData;

 % model values for every observation

conditionalFit = fitted(lme,'Conditional',true);   % fixed + all random effects
fixedFit = fitted(lme,'Conditional',false);        % fixed effects only

[b,bNames] = randomEffects(lme);
outerRandomEffect = zeros(height(newTable),1);
sel = strcmp(bNames.Group,outerVar) & strcmp(bNames.Name,'(Intercept)');
[tf,loc] = ismember(string(newTable.(outerVar)),string(bNames.Level(sel)));
bOuter = b(sel);
outerRandomEffect(tf) = bOuter(loc(tf));
outerFit = fixedFit + outerRandomEffect;

if backTransformRanks
    originalData = newTable.original_data;
    rankedData = newTable.(stats.yNameFixed);
    [~,uIndexes] = unique(rankedData);
    toPlotUnits = @(v) interp1(rankedData(uIndexes),originalData(uIndexes),v,'linear');
    yData = originalData;
else
    toPlotUnits = @(v) v;
    yData = newTable.(stats.yNameFixed);
end

 % colors

firstFactor = stats.factorNames{1};
lastFactor = stats.factorNames{end};
colorIndex = zeros(nCells,1);
for c=1:nCells
    switch options.colorBy
        case 'cell'
            colorIndex(c) = c;
        case 'firstFactor'
            colorIndex(c) = find(strcmp(cellMeans.(firstFactor){c},stats.factorLevels{1}));
        case 'lastFactor'
            colorIndex(c) = find(strcmp(cellMeans.(lastFactor){c},stats.factorLevels{end}));
    end
end

 % plot

h = [];
xCenter = [];
x = {};
y = {};
unitCell = [];
unitOuterLabel = {};
unitInnerLabel = {};
unitFit = [];
cellBoundaries = nan(nCells,2);

currentSpot = 1;

holdState = ishold;
hold on;

for c=1:nCells
    I = stats.cellIndexes{c};
    if c>1 && ~strcmp(cellMeans.(firstFactor){c},cellMeans.(firstFactor){c-1})
        currentSpot = currentSpot + options.acrossFactorSpace;
    end
    cellBoundaries(c,1) = currentSpot;
    colorHere = options.colors(1+mod(colorIndex(c)-1,size(options.colors,1)),:);

    outerLabels = unique(newTable.(outerVar)(I));
    outerOrderValue = zeros(numel(outerLabels),1);
    for o=1:numel(outerLabels)
        outerOrderValue(o) = outerFit(I(find(newTable.(outerVar)(I)==outerLabels(o),1)));
    end
    if options.sortRandomEffects
        [~,order] = sort(outerOrderValue);
        outerLabels = outerLabels(order);
    end

    for o=1:numel(outerLabels)
        Io = I(newTable.(outerVar)(I)==outerLabels(o));
        outerStart = currentSpot;

        innerLabels = unique(newTable.(innerVar)(Io));
        innerOrderValue = zeros(numel(innerLabels),1);
        for u=1:numel(innerLabels)
            innerOrderValue(u) = conditionalFit(Io(find(newTable.(innerVar)(Io)==innerLabels(u),1)));
        end
        if options.sortRandomEffects
            [~,order] = sort(innerOrderValue);
            innerLabels = innerLabels(order);
        end

        for u=1:numel(innerLabels)
            Iu = Io(newTable.(innerVar)(Io)==innerLabels(u));
            n = numel(Iu);
            xHere = currentSpot + options.withinGroupSpace*0.5;
            x{end+1} = xHere + (rand(n,1)-0.5)*options.jitterWidth;
            y{end+1} = yData(Iu);
            xCenter(end+1) = xHere;
            unitCell(end+1) = c;
            unitOuterLabel{end+1} = char(outerLabels(o));
            unitInnerLabel{end+1} = char(innerLabels(u));
            unitFit(end+1) = conditionalFit(Iu(1));

            h(end+1) = plot(x{end},y{end},options.pointMarkerShape,'color',colorHere,...
                'markersize',options.pointMarkerSize);
            addDataTips(h(end),n,cellMeans.Label(c),unitInnerLabel{end});

            h(end+1) = plot(xHere+[-0.4 0.4]*options.withinGroupSpace,...
                toPlotUnits(unitFit(end))*[1 1],'-','color',options.innerMeanColor,...
                'linewidth',options.innerMeanLineWidth);
            addDataTips(h(end),2,cellMeans.Label(c),unitInnerLabel{end});

            currentSpot = currentSpot + options.withinGroupSpace;
        end

        if nLevelsGroup>1
            h(end+1) = plot([outerStart currentSpot],toPlotUnits(outerFit(Io(1)))*[1 1],'-',...
                'color',options.outerMeanColor,'linewidth',options.outerMeanLineWidth);
            addDataTips(h(end),2,cellMeans.Label(c),unitOuterLabel{end});
            vlt.plot.movetoback(h(end));
            if o<numel(outerLabels)
                currentSpot = currentSpot + options.betweenGroupSpace;
            end
        end
    end

    cellBoundaries(c,2) = currentSpot;
    currentSpot = currentSpot + options.acrossCellSpace;

     % cell mean and standard error
    if ~isnan(cellMeans.Estimate(c))
        meanValue = toPlotUnits(cellMeans.Estimate(c));
        seBar = toPlotUnits(cellMeans.Estimate(c) + [-1 1]*cellMeans.SE(c));
        h(end+1) = plot(cellBoundaries(c,:),[1 1]*meanValue,...
            'linewidth',options.cellMeanLineWidth,'color',options.cellMeanColor);
        vlt.plot.movetoback(h(end));
        h(end+1) = plot(mean(cellBoundaries(c,:))*[1 1],seBar,...
            'linewidth',options.cellMeanLineWidth,'color',options.cellMeanColor);
        vlt.plot.movetoback(h(end));
    end
end

if isLog
    for i=1:numel(h)
        set(h(i),'YData',10.^get(h(i),'YData'));
    end
    set(gca,'yscale','log');
end

if ~holdState
    hold off;
end

A = axis;
axis([1-options.withinGroupSpace max(cellBoundaries(:,2))+options.withinGroupSpace A(3) A(4)]);

box(gca,options.boxState);

ylabel(options.yLabel);

tickLabels = cell(nCells,1);
for c=1:nCells
    parts = cell(1,numel(stats.factorNames));
    for i=1:numel(stats.factorNames)
        parts{i} = strrep(cellMeans.(stats.factorNames{i}){c},'_','\_');
    end
    tickLabels{c} = strjoin(parts,'\newline');
end
set(gca,'xtick',mean(cellBoundaries,2),'xticklabel',tickLabels,'TickLabelInterpreter','tex');

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
    title(strjoin(titleParts,', '),'Interpreter','none');
end

plotInfo = vlt.data.var2struct('xCenter','x','y','unitCell','unitOuterLabel','unitInnerLabel',...
    'unitFit','cellBoundaries','options');

end

function addDataTips(hLine, n, cellLabel, unitLabel)
% ADDDATATIPS - add cell and unit labels to the data tips of a line
    try
        dataTipTemplate = get(hLine,'DataTipTemplate');
        dataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Cell',repmat({char(cellLabel)},n,1));
        dataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Unit',repmat({unitLabel},n,1));
    catch
        % data tips are not available in this version of MATLAB
    end
end
