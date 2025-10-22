classdef testanovaposthoc < matlab.unittest.TestCase
    % TESTANOVAPOSTHOC - Test for vlt.stats.power.anovaposthoc and its demo
    %

    properties
        InitialFigures;
    end

    methods (TestMethodSetup)
        function capture_initial_figures(testCase)
            testCase.InitialFigures = findall(0, 'Type', 'figure');
        end
    end

    methods (TestMethodTeardown)
        function close_new_figures(testCase)
            current_figs = findall(0, 'Type', 'figure');
            new_figs = setdiff(current_figs, testCase.InitialFigures);
            for i=1:numel(new_figs)
                if ishandle(new_figs(i))
                    close(new_figs(i));
                end
            end
        end
    end

    methods (Test)

        function test_anovaposthoc_2way(testCase)
            % Test 2-way ANOVA power analysis
            Animal = repelem(1:10, 4)';
            Drug = repmat(repelem(["DrugA"; "DrugB"], 2), 10, 1);
            TestDay = repmat(["Day1"; "Day2"], 20, 1);
            Measurement = randn(40, 1);
            dataTable = table(Animal, Drug, TestDay, Measurement);

            differences = [0 2];
            groupColumnNames = {'Drug', 'TestDay'};
            groupComparisons = [1 2];
            groupShuffles = {[1 2]};
            alpha = 0.05;

            results = vlt.stats.power.anovaposthoc(dataTable, differences, groupColumnNames, ...
                groupComparisons, groupShuffles, 'numShuffles', 500, 'alpha', alpha, 'plot', false);

            testCase.verifyEqual(numel(results), 1);

            power_at_zero = results.groupComparisonPower(1,:);
            power_at_diff = results.groupComparisonPower(2,:);

            % Power at zero difference should be approximately alpha
            testCase.verifyLessThan(abs(mean(power_at_zero) - alpha), 0.05, ...
                'Power at zero difference should be close to alpha');

            % Power should increase with difference
            testCase.verifyGreaterThan(mean(power_at_diff), mean(power_at_zero), ...
                'Power should increase with the effect size.');
        end

        function test_anovaposthoc_1way(testCase)
            % Test 1-way ANOVA power analysis
            Animal = repelem(1:10, 3)';
            Drug = repmat(["A"; "B"; "C"], 10, 1);
            Measurement = randn(30, 1);
            dataTable = table(Animal, Drug, Measurement);

            differences = [0 2];
            groupColumnNames = {'Drug'};
            groupComparisons = [1];
            groupShuffles = {[1]};
            alpha = 0.05;

            results = vlt.stats.power.anovaposthoc(dataTable, differences, groupColumnNames, ...
                groupComparisons, groupShuffles, 'numShuffles', 500, 'alpha', alpha, 'plot', false);

            testCase.verifyEqual(numel(results), 1);

            power_at_zero = results.groupComparisonPower(1,:);
            power_at_diff = results.groupComparisonPower(2,:);

            testCase.verifyLessThan(abs(mean(power_at_zero) - alpha), 0.05, ...
                 'Power at zero difference should be close to alpha');

            testCase.verifyGreaterThan(mean(power_at_diff), mean(power_at_zero), ...
                'Power should increase with the effect size.');
        end


        function test_anovaposthoc_demo(testCase)
            % Test if the demo runs without error
            testCase.verifyWarningFree(@() vlt.stats.power.anovaposthocDemo('numberOfAnimals', 5, 'numShuffles', 20));
        end

        function test_anovaposthoc_plot_option(testCase)
            % Test the plot option
            Animal = repelem(1:5, 4)';
            Drug = repmat(repelem(["DrugA"; "DrugB"], 2), 5, 1);
            TestDay = repmat(["Day1"; "Day2"], 10, 1);
            Measurement = randn(20, 1);
            dataTable = table(Animal, Drug, TestDay, Measurement);
            differences = [0 1];
            groupColumnNames = {'Drug', 'TestDay'};
            groupComparisons = [1 2];
            groupShuffles = {[1 2]};

            % Test plot=true (default)
            vlt.stats.power.anovaposthoc(dataTable, differences, groupColumnNames, ...
                groupComparisons, groupShuffles, 'numShuffles', 10);

            current_figs = findall(0, 'Type', 'figure');
            new_fig = setdiff(current_figs, testCase.InitialFigures);
            testCase.verifyNumElements(new_fig, 1, 'A new figure should have been created.');
            close(new_fig); % clean up

            % Test plot=false
            vlt.stats.power.anovaposthoc(dataTable, differences, groupColumnNames, ...
                groupComparisons, groupShuffles, 'numShuffles', 10, 'plot', false);

            current_figs_after_no_plot = findall(0, 'Type', 'figure');
            new_figs_after_no_plot = setdiff(current_figs_after_no_plot, testCase.InitialFigures);
            testCase.verifyEmpty(new_figs_after_no_plot, 'No new figure should be created when plot is false.');
        end

    end

end
