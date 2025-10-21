classdef testpower2sample < matlab.unittest.TestCase
    % TESTPOWER2SAMPLE - Test for vlt.stats.power.power2sample and its demo
    %

    properties
        InitialFigures;
    end

    methods (MethodSetup)
        function capture_initial_figures(testCase)
            testCase.InitialFigures = findall(0, 'Type', 'figure');
        end
    end

    methods (MethodTeardown)
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

        function test_power2sample_basic(testCase)
            % Test basic functionality of power2sample

            sample1 = randn(1, 15);
            sample2 = randn(1, 15);
            differences = [0 1];

            % Test ttest2
            p_ttest = vlt.stats.power.power2sample(sample1, sample2, differences, 'test', 'ttest2', 'numSimulations', 100, 'plot', false);
            testCase.verifyEqual(numel(p_ttest), numel(differences), 'Output size mismatch for ttest2');
            testCase.verifyGreaterThanOrEqual(p_ttest(2), p_ttest(1), 'Power should be monotonic for ttest2');

            % Test kstest2
            p_kstest = vlt.stats.power.power2sample(sample1, sample2, differences, 'test', 'kstest2', 'numSimulations', 100, 'plot', false);
            testCase.verifyEqual(numel(p_kstest), numel(differences), 'Output size mismatch for kstest2');
            testCase.verifyGreaterThanOrEqual(p_kstest(2), p_kstest(1), 'Power should be monotonic for kstest2');

            % Test ranksum
            p_ranksum = vlt.stats.power.power2sample(sample1, sample2, differences, 'test', 'ranksum', 'numSimulations', 100, 'plot', false);
            testCase.verifyEqual(numel(p_ranksum), numel(differences), 'Output size mismatch for ranksum');
            testCase.verifyGreaterThanOrEqual(p_ranksum(2), p_ranksum(1), 'Power should be monotonic for ranksum');
        end

        function test_power2sample_demo(testCase)
            % Test if the demo runs without error
            testCase.verifyWarningFree(@() vlt.stats.power.power2sampleDemo());
            testCase.verifyWarningFree(@() vlt.stats.power.power2sampleDemo('numSamples1', 10, 'numSamples2', 20));
            testCase.verifyWarningFree(@() vlt.stats.power.power2sampleDemo('sampleStdDev', 2.0));
            testCase.verifyWarningFree(@() vlt.stats.power.power2sampleDemo('differences', [0 0.5 1]));
        end

        function test_power2sample_pairedTTest(testCase)
            % Test pairedTTest functionality of power2sample

            sample1 = randn(1, 20);
            sample2 = randn(1, 20);
            % Add some NaNs to test NaN handling
            sample1(1) = NaN;
            sample2(5) = NaN;

            differences = [0 1];

            % Test pairedTTest
            p_pairedTTest = vlt.stats.power.power2sample(sample1, sample2, differences, 'test', 'pairedTTest', 'numSimulations', 100, 'plot', false);
            testCase.verifyEqual(numel(p_pairedTTest), numel(differences), 'Output size mismatch for pairedTTest');
            testCase.verifyGreaterThanOrEqual(p_pairedTTest(2), p_pairedTTest(1), 'Power should be monotonic for pairedTTest');

            % Test error for unequal sample sizes
            sample3 = randn(1,19);
            % The custom error doesn't have a specific ID, so expect a generic one ('')
            testCase.verifyError(@() vlt.stats.power.power2sample(sample1, sample3, differences, 'test', 'pairedTTest', 'plot', false),'');
        end

        function test_power2sample_plot_and_verbose_options(testCase)
            % Test plotting and verbose options

            sample1 = randn(1, 10);
            sample2 = randn(1, 10);
            differences = [0 1];

            % 1. Test plot=true (default) and custom labels
            custom_title = "My Custom Title";
            custom_xlabel = "X Axis";
            custom_ylabel = "Y Axis";

            vlt.stats.power.power2sample(sample1, sample2, differences, 'numSimulations', 10, ...
                'titleText', custom_title, 'xLabel', custom_xlabel, 'yLabel', custom_ylabel);

            current_figs = findall(0, 'Type', 'figure');
            new_fig = setdiff(current_figs, testCase.InitialFigures);
            testCase.verifyNumElements(new_fig, 1, 'A new figure should have been created.');

            % Verify title and labels
            ax = get(new_fig, 'CurrentAxes');
            testCase.verifyEqual(ax.Title.String, char(custom_title), 'Custom title was not set correctly.');
            testCase.verifyEqual(ax.XLabel.String, char(custom_xlabel), 'Custom xlabel was not set correctly.');
            testCase.verifyEqual(ax.YLabel.String, char(custom_ylabel), 'Custom ylabel was not set correctly.');

            % 2. Test plot=false
            vlt.stats.power.power2sample(sample1, sample2, differences, 'numSimulations', 10, 'plot', false);
            current_figs_after_no_plot = findall(0, 'Type', 'figure');
            new_figs_after_no_plot = setdiff(current_figs_after_no_plot, current_figs);
            testCase.verifyEmpty(new_figs_after_no_plot, 'No new figure should be created when plot is false.');

            % No need to test verbose, as it only affects command window output.
        end

    end

end
