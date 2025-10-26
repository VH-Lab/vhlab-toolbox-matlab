classdef test_savefigurelist < matlab.unittest.TestCase
    properties
        tempDir
        fig
    end

    methods(TestMethodSetup)
        function setup(testCase)
            % Create a temporary directory for test file output
            testCase.tempDir = tempname;
            mkdir(testCase.tempDir);

            % Create a figure with a known tag
            testCase.fig = figure('Visible', 'off', 'Tag', 'myTestFigure');
        end
    end

    methods(TestMethodTeardown)
        function teardown(testCase)
            % Close the figure and remove the temporary directory
            close(testCase.fig);
            rmdir(testCase.tempDir, 's');
        end
    end

    methods(Test)
        function test_savefigurelist_saves_files(testCase)
            % Test that savefigurelist saves files in the specified formats

            % Get the current working directory to restore it later
            originalDir = pwd;
            % Change to the temporary directory
            cd(testCase.tempDir);

            % Define the formats to save
            formatsToSave = {'fig', 'pdf'};

            % Run the function
            savefigurelist(testCase.fig, 'Formats', formatsToSave);

            % Change back to the original directory
            cd(originalDir);

            % Verify that the files were created in the temporary directory
            for i = 1:length(formatsToSave)
                expectedFile = fullfile(testCase.tempDir, ['myTestFigure.' formatsToSave{i}]);
                testCase.verifyTrue(exist(expectedFile, 'file') == 2, ...
                    ['File ' expectedFile ' was not created.']);
            end
        end

        function test_savefigurelist_error_on_empty_tag(testCase)
            % Test that an error is thrown for a figure with an empty tag

            % Create a figure with an empty tag
            fig_no_tag = figure('Visible', 'off', 'Tag', '');

            % Verify that the function throws an error
            testCase.verifyError(@() savefigurelist(fig_no_tag), '');

            % Clean up the extra figure
            close(fig_no_tag);
        end
    end
end
