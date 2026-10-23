function means = lme_factorial_subject_means(newTable, stats)
% LME_FACTORIAL_SUBJECT_MEANS - raw means of each unit and each subject in each cell of a factorial LME
%
% MEANS = vlt.stats.LME_FACTORIAL_SUBJECT_MEANS(NEWTABLE, STATS)
%
% Computes, from the data used by vlt.stats.lme_factorial (its outputs
% NEWTABLE and STATS), the raw (not model-based) means at each level of the
% nesting, separately for each cell of the design:
%
%   - the mean of each innermost unit (e.g., each neuron): the mean of its
%     observations (e.g., dendritic segments) in that cell
%   - the mean of each subject (outermost unit, e.g., each animal): the mean
%     of its unit means in that cell, so that every unit counts equally no
%     matter how many observations it has. With only one grouping level, the
%     subject mean is the mean of its observations.
%
% Means are taken on the scale that was fit: for a log10 fit, they are
% means of log10(Y) (MEANS.scale is 'log10'; 10.^mean is a geometric mean);
% otherwise they are means of the original Y (MEANS.scale is 'linear'),
% including for a rank fit.
%
% These raw means are pictures of the data. They are more spread out than
% the model's random-effect estimates, which are pulled toward the cell
% means in proportion to how little information each unit carries.
%
% Output:
%   MEANS - a structure with fields:
%     unitMeans - table with columns Cell (index into STATS.cellMeans),
%         CellLabel, Subject, Unit, SubjectIndex, Mean, nObs
%     subjectMeans - table with columns Cell, CellLabel, Subject,
%         SubjectIndex, Mean, nUnits, nObs
%     subjects - string array of all subjects, sorted; SubjectIndex indexes
%         into it, so a subject has the same index (and can have the same
%         color) in every cell and every plot
%     scale - 'log10' or 'linear'
%
% See also: vlt.stats.lme_factorial, vlt.stats.plot_lme_superplot,
%   vlt.stats.plot_lme_paired

arguments
    newTable table
    stats (1,1) struct
end

outerVar = stats.groupVarNames{1};
innerVar = stats.groupVarNames{end};

if strcmp(stats.transform,'log10')
    y = newTable.(stats.yNameFixed);
    scale = 'log10';
else
    y = newTable.original_data;
    scale = 'linear';
end

subjectLabels = string(newTable.(outerVar));
unitLabels = string(newTable.(innerVar));
subjects = unique(subjectLabels);

unitRows = {};
subjectRows = {};
for c=1:numel(stats.cellIndexes)
    I = stats.cellIndexes{c};
    cellLabel = stats.cellMeans.Label(c);
    subjectsHere = unique(subjectLabels(I));
    for s=1:numel(subjectsHere)
        Is = I(subjectLabels(I)==subjectsHere(s));
        subjectIndex = find(subjects==subjectsHere(s));
        unitsHere = unique(unitLabels(Is));
        unitMean = zeros(numel(unitsHere),1);
        for u=1:numel(unitsHere)
            Iu = Is(unitLabels(Is)==unitsHere(u));
            unitMean(u) = mean(y(Iu));
            unitRows(end+1,:) = {c, cellLabel, subjectsHere(s), unitsHere(u), subjectIndex, ...
                unitMean(u), numel(Iu)}; %#ok<AGROW>
        end
        subjectRows(end+1,:) = {c, cellLabel, subjectsHere(s), subjectIndex, mean(unitMean), ...
            numel(unitsHere), numel(Is)}; %#ok<AGROW>
    end
end

unitMeans = cell2table(unitRows, 'VariableNames', ...
    {'Cell','CellLabel','Subject','Unit','SubjectIndex','Mean','nObs'});
subjectMeans = cell2table(subjectRows, 'VariableNames', ...
    {'Cell','CellLabel','Subject','SubjectIndex','Mean','nUnits','nObs'});

means = struct('unitMeans',unitMeans, 'subjectMeans',subjectMeans, ...
    'subjects',subjects, 'scale',scale);

end
