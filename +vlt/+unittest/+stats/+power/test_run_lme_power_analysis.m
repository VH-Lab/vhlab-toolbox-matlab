classdef test_run_lme_power_analysis < matlab.unittest.TestCase
    % TEST_RUN_LME_POWER_ANALYSIS - Test for the main power analysis pipeline

    properties
        SampleTbl
        figures_before_test
    end

    methods (TestMethodSetup)
        function create_test_data(testCase)
            % Create a sample table for testing.
            % This now creates a crossed design to avoid confounding variables, which
            % was causing the LME model to be unstable and leading to infinite loops.
            reps = 10; % Reduced reps for speed, balanced design is more important
            mfg_levels = {'A'; 'B'; 'C'; 'D'};
            year_levels = {'70'; '76'; '82'; '85'};

            [mfg_grid, year_grid] = ndgrid(1:numel(mfg_levels), 1:numel(year_levels));

            num_rows = numel(mfg_grid) * reps;

            Mfg = categorical(repmat(mfg_levels(mfg_grid(:)), reps, 1));
            Model_Year = categorical(repmat(year_levels(year_grid(:)), reps, 1));
            MPG = rand(num_rows, 1) * 20 + 10;

            testCase.SampleTbl = table(Mfg, Model_Year, MPG);
            testCase.figures_before_test = findall(0, 'type', 'figure');
        end
    end

    methods (TestMethodTeardown)
        function close_figures(testCase)
            figures_after_test = findall(0, 'type', 'figure');
            new_figures = setdiff(figures_after_test, testCase.figures_before_test);
            close(new_figures);
        end
    end

    methods (Test)

        function test_pipeline_execution_gaussian(testCase)
            % Test the full pipeline with the 'gaussian' method

            [mdes, power_curve] = vlt.stats.power.run_lme_power_analysis(...
                testCase.SampleTbl, 'Model_Year', 'MPG', '70', 'Mfg', '76', 0.10, ... % Low power target
                'Method', 'gaussian', 'NumSimulations', 10, 'EffectStep', 5, 'plot', false); % Low sims for speed

            % Verifications
            testCase.verifyClass(mdes, 'double', 'MDES should be a double.');
            testCase.verifyTrue(isscalar(mdes), 'MDES should be a scalar.');
            testCase.verifyGreaterThan(mdes, 0, 'MDES should be positive.');

            testCase.verifyClass(power_curve, 'table', 'Power curve should be a table.');
            testCase.verifyEqual(power_curve.Properties.VariableNames, {'EffectSize', 'Power'}, ...
                'Power curve table has incorrect variable names.');
            testCase.verifyGreaterThan(height(power_curve), 0, 'Power curve table should not be empty.');
        end

        function test_pipeline_execution_hierarchical(testCase)
            % Test the full pipeline with the 'hierarchical' method

            [mdes, power_curve] = vlt.stats.power.run_lme_power_analysis(...
                testCase.SampleTbl, 'Model_Year', 'MPG', '70', 'Mfg', '76', 0.10, ... % Low power target
                'Method', 'hierarchical', 'NumSimulations', 10, 'EffectStep', 5, 'plot', false); % Low sims for speed

            % Verifications
            testCase.verifyClass(mdes, 'double', 'MDES should be a double.');
            testCase.verifyTrue(isscalar(mdes), 'MDES should be a scalar.');
            testCase.verifyGreaterThan(mdes, 0, 'MDES should be positive.');

            testCase.verifyClass(power_curve, 'table', 'Power curve should be a table.');
            testCase.verifyEqual(power_curve.Properties.VariableNames, {'EffectSize', 'Power'}, ...
                'Power curve table has incorrect variable names.');
            testCase.verifyGreaterThan(height(power_curve), 0, 'Power curve table should not be empty.');
        end

        function test_plotting_functionality(testCase)
            % Test that the plot is created when 'plot' is true

            initial_figures = findall(0, 'type', 'figure');

            vlt.stats.power.run_lme_power_analysis(...
                testCase.SampleTbl, 'Model_Year', 'MPG', '70', 'Mfg', '76', 0.10, ... % Low power target
                'Method', 'gaussian', 'NumSimulations', 10, 'EffectStep', 5, 'plot', true);

            current_figures = findall(0, 'type', 'figure');
            new_figures = setdiff(current_figures, initial_figures);

            testCase.verifyEqual(numel(new_figures), 1, 'A new figure should be created.');

            % Check title of the new figure
            fig = new_figures(1);
            expected_title = 'LME Power Analysis (GAUSSIAN)';
            testCase.verifyEqual(char(fig.Name), expected_title, 'Figure title is incorrect.');
        end

        function test_posthoc_struct_syntax(testCase)
            % Test the new struct-based syntax for post-hoc tests

            % Create a more complex table for post-hoc testing
            Condition = categorical(repelem({'A'; 'B'}, 20, 1));
            Time = categorical(repmat({'T1'; 'T2'}, 20, 1));
            Subject = categorical(repelem([1:10]', 4, 1));
            Measurement = rand(40, 1) * 10;
            posthoc_tbl = table(Condition, Time, Subject, Measurement);

            reference_group = struct('Condition', 'A', 'Time', 'T1');
            test_group = struct('Condition', 'B', 'Time', 'T2');

            [mdes, ~] = vlt.stats.power.run_lme_power_analysis(...
                posthoc_tbl, {'Condition', 'Time'}, 'Measurement', ...
                reference_group, 'Subject', test_group, 0.10, ... % Low power target
                'NumSimulations', 10, 'plot', false);

            testCase.verifyClass(mdes, 'double', 'MDES should be a double.');
            testCase.verifyTrue(isscalar(mdes), 'MDES should be a scalar.');
            testCase.verifyGreaterThan(mdes, 0, 'MDES should be positive.');
        end

    end
end
