classdef TestKiCadGerber2OSHPark < matlab.unittest.TestCase
    % Test for the vlt.pcb.KiCadGerber2OSHPark function

    properties
        testDir
        oshParkDir
        originalFiles
        originalContent
        expectedNewFiles
    end

    methods (TestClassSetup)
        function createTestEnvironment(testCase)
            % Create a temporary directory for our test files
            testCase.testDir = tempname;
            mkdir(testCase.testDir);
            testCase.oshParkDir = fullfile(testCase.testDir, 'OSHPark');

            % Define the files to be created and their expected new names
            testCase.originalFiles = { 'B.Cu.gbr', 'B.Mask.gbr', 'B.SilkS.gbr', 'F.Cu.gbr', 'F.Mask.gbr', ...
                'F.SilkS.gbr', 'Edge.Cuts.gbr', 'test-job.drl' };

            testCase.expectedNewFiles = {'B.Cu.gbr.GBL', 'B.Mask.gbr.GBS', 'B.SilkS.gbr.GBO', ...
                'F.Cu.gbr.GTL', 'F.Mask.gbr.GTS', 'F.SilkS.gbr.GTO', ...
                'Edge.Cuts.gbr.GKO', 'drl.XLN'};

            % Create the dummy files with unique content
            testCase.originalContent = cell(size(testCase.originalFiles));
            for i = 1:numel(testCase.originalFiles)
                testCase.originalContent{i} = sprintf('File content for %s', testCase.originalFiles{i});
                fid = fopen(fullfile(testCase.testDir, testCase.originalFiles{i}), 'w');
                fprintf(fid, '%s', testCase.originalContent{i});
                fclose(fid);
            end
        end
    end

    methods (TestClassTeardown)
        function cleanupTestEnvironment(testCase)
            % Remove the temporary directory and all its contents
            if exist(testCase.testDir, 'dir')
                rmdir(testCase.testDir, 's');
            end
        end
    end

    methods (Test)
        function testFileRenamingAndContent(testCase)
            % Run the function under test
            vlt.pcb.KiCadGerber2OSHPark(testCase.testDir);

            % Verify that the OSHPark directory was created
            testCase.verifyTrue(exist(testCase.oshParkDir, 'dir') > 0, ...
                'The OSHPark output directory was not created.');

            % Verify that each expected file was created and has the correct content
            for i = 1:numel(testCase.expectedNewFiles)
                newFilePath = fullfile(testCase.oshParkDir, testCase.expectedNewFiles{i});

                % Check if the file exists
                testCase.verifyTrue(exist(newFilePath, 'file') > 0, ...
                    sprintf('Expected file "%s" was not created.', testCase.expectedNewFiles{i}));

                % Read the content of the newly created file
                newContent = fileread(newFilePath);

                % Find the corresponding original content
                if strcmp(testCase.expectedNewFiles{i}, 'drl.XLN')
                    % The .drl file is a special case; it is renamed to drl.XLN
                    originalIndex = find(endsWith(testCase.originalFiles, '.drl'));
                    expectedContent = testCase.originalContent{originalIndex};
                else
                    % For other files, the name mapping is 1-to-1
                    expectedContent = testCase.originalContent{i};
                end

                % Verify the content matches the original
                testCase.verifyEqual(newContent, expectedContent, ...
                    sprintf('The content of the new file "%s" does not match the original.', newFilePath));
            end
        end
    end
end