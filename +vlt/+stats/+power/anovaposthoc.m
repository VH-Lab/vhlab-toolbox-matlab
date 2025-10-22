function anovaposthoc_results = anovaposthoc(dataTable, differences, groupColumnNames, groupComparisons, groupShuffles, options)
% VLT.STATS.POWER.ANOVAPOSTHOC - Compute statistical power for ANOVA post-hoc tests by simulation
%
%   ANOVAPOSTHOC_RESULTS = VLT.STATS.POWER.ANOVAPOSTHOC(DATATABLE, DIFFERENCES, GROUPCOLUMNNAMES, ...
%   GROUPCOMPARISONS, GROUPSHUFFLES, ...)
%
%   Computes the statistical power for ANOVA post-hoc tests by creating simulated datasets and
%   performing ANOVA statistics with post-hoc tests.
%
%   Inputs:
%   - dataTable: A MATLAB table. The last column is assumed to be the data column.
%   - differences: A vector of differences to examine. The difference is added to one group being examined.
%   - groupColumnNames: A cell array of char arrays or a string array of column names that correspond to group labels.
%   - groupComparisons: An array of group numbers to compare (e.g., [1 2] to compare groups 1 and 2).
%   - groupShuffles: A cell array of vectors of group numbers to indicate how to shuffle data for surrogate datasets.
%
%   Optional Name-Value Pairs:
%   - 'posthocTest' ('Tukey' | ...): The post-hoc test to use. Default is 'Tukey'.
%     (Note: 'Tukey' corresponds to 'hsd' in MATLAB's multcompare function).
%   - 'numShuffles' (integer > 0): Number of simulations. Default is 10000.
%   - 'alpha' (0 < alpha < 1): The significance level. Default is 0.05.
%   - 'dataColumnName' (string): Name of the column with the data. Default is the last column name.
%
%   Outputs:
%   - anovaposthoc_results: A structure with one entry per cell array entry in groupShuffles.
%     Each entry has fields:
%       - groupComparisonName: String array of the groups being compared.
%       - groupComparisonPower: The power of the comparisons.
%
%

arguments
    dataTable table
    differences (1,:) double
    groupColumnNames cell
    groupComparisons (1,:) double
    groupShuffles cell
    options.posthocTest {mustBeMember(options.posthocTest,{'Tukey'})} = 'Tukey'
    options.numShuffles (1,1) double {mustBeInteger, mustBeGreaterThan(options.numShuffles,0)} = 10000
    options.alpha (1,1) double {mustBeGreaterThan(options.alpha,0), mustBeLessThan(options.alpha,1)} = 0.05
    options.dataColumnName (1,1) string = dataTable.Properties.VariableNames{end}
    options.plot (1,1) logical = true
end

if strcmp(options.posthocTest, 'Tukey')
    matlabPosthocTest = 'hsd'; % Tukey-Kramer
else
    error(['Unknown posthoc test: ' options.posthocTest]);
end

anovaposthoc_results = struct('groupComparisonName', [], 'groupComparisonPower', []);

for s = 1:numel(groupShuffles)

    currentShuffle = groupShuffles{s};

    % Get all possible combinations of groups to compare
    grouping_vars = cell(1, numel(groupColumnNames));
    for i = 1:numel(groupColumnNames)
        grouping_vars{i} = dataTable.(groupColumnNames{i});
    end

    if numel(grouping_vars) > 1
        model = 'interaction';
    else
        model = 'linear';
    end
    [~, ~, stats] = anovan(dataTable.(options.dataColumnName), grouping_vars, 'model', model, 'display', 'off', 'varnames', groupColumnNames);

    [c, ~, ~, gnames] = multcompare(stats, 'Dimension', groupComparisons, 'display', 'off', 'ctype', matlabPosthocTest);

    numComparisons = size(c, 1);
    comparison_names = strings(numComparisons, 1);
    for i = 1:numComparisons
        name1 = strjoin(gnames(c(i, 1), :), ',');
        name2 = strjoin(gnames(c(i, 2), :), ',');
        comparison_names(i) = [name1 ' vs. ' name2];
    end

    anovaposthoc_results(s).groupComparisonName = comparison_names;
    anovaposthoc_results(s).groupComparisonPower = zeros(numel(differences), numComparisons);

    % Determine the target group values before the simulation
    last_group_values = cell(1, numel(currentShuffle));
    for i = 1:numel(currentShuffle)
        group_values = unique(dataTable.(groupColumnNames{currentShuffle(i)}));
        last_group_values{i} = group_values(end);
    end

    for d = 1:numel(differences)

        significant_counts = zeros(1, numComparisons);

        for n = 1:options.numShuffles

            surrogateTable = dataTable;

            % Shuffle the specified group labels
            for g = 1:numel(currentShuffle)
                col_to_shuffle = groupColumnNames{currentShuffle(g)};
                surrogateTable.(col_to_shuffle) = surrogateTable.(col_to_shuffle)(randperm(height(surrogateTable)));
            end

            % Determine the target group for adding the difference *within the loop*
            target_group_indices = true(height(surrogateTable), 1);
            for i = 1:numel(currentShuffle)
                target_group_indices = target_group_indices & ...
                    (surrogateTable.(groupColumnNames{currentShuffle(i)}) == last_group_values{i});
            end

            % Add the difference
            surrogateTable.(options.dataColumnName)(target_group_indices) = ...
                surrogateTable.(options.dataColumnName)(target_group_indices) + differences(d);

            % Perform ANOVA and post-hoc test
            grouping_vars_surrogate = cell(1, numel(groupColumnNames));
            for i = 1:numel(groupColumnNames)
                grouping_vars_surrogate{i} = surrogateTable.(groupColumnNames{i});
            end

            if numel(grouping_vars_surrogate) > 1
                model = 'interaction';
            else
                model = 'linear';
            end
            [~, ~, stats_surr] = anovan(surrogateTable.(options.dataColumnName), grouping_vars_surrogate, 'model', model, 'display', 'off', 'varnames', groupColumnNames);

            c_surr = multcompare(stats_surr, 'Dimension', groupComparisons, 'display', 'off', 'ctype', matlabPosthocTest);

            % Check for significance
            significant_pairs = c_surr(c_surr(:, 6) < options.alpha, [1 2]);

            if ~isempty(significant_pairs)
                for k = 1:size(c,1)
                    if any(all(ismember(significant_pairs, c(k, [1 2])), 2))
                        significant_counts(k) = significant_counts(k) + 1;
                    end
                end
            end

        end % for n (numShuffles)

        anovaposthoc_results(s).groupComparisonPower(d, :) = significant_counts / options.numShuffles;

    end % for d (differences)

end % for s (groupShuffles)

if options.plot
    figure;
    num_plots = numel(anovaposthoc_results);
    for i = 1:num_plots
        subplot(1, num_plots, i);
        plot(differences, anovaposthoc_results(i).groupComparisonPower, '-o');
        title(['Shuffle: ' mat2str(groupShuffles{i})]);
        xlabel('Difference');
        ylabel('Power');
        legend(anovaposthoc_results(i).groupComparisonName, 'Location', 'best');
        box off;
    end
end

end
