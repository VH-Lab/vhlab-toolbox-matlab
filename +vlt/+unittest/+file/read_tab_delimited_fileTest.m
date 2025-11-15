classdef read_tab_delimited_file_test < matlab.unittest.TestCase
    properties
        TestFile
    end

    methods (TestMethodSetup)
        function createTestFile(testCase)
            % Create a temporary file for testing
            testCase.TestFile = [tempname '.txt'];
            fid = fopen(testCase.TestFile, 'w');
            fprintf(fid, '1\t2\t3\n');
            fprintf(fid, 'a\tb\tc\n');
            fprintf(fid, '4\t5.5\t11/11/2011\n');
            fprintf(fid, 'd\t6\n');
            fclose(fid);
        end
    end

    methods (TestMethodTeardown)
        function deleteTestFile(testCase)
            % Delete the temporary file
            delete(testCase.TestFile);
        end
    end

    methods (Test)
        function testReadTabDelimitedFile(testCase)
            % Test the vlt.file.read_tab_delimited_file function

            output = vlt.file.read_tab_delimited_file(testCase.TestFile);

            % Expected output
            expected = { ...
                {1, 2, 3}, ...
                {'a', 'b', 'c'}, ...
                {4, 5.5, '11/11/2011'}, ...
                {'d', 6} ...
            };

            testCase.verifyEqual(numel(output), numel(expected), 'Number of rows does not match');

            for i = 1:numel(expected)
                testCase.verifyEqual(output{i}, expected{i}, ['Row ' num2str(i) ' does not match']);
            end
        end
    end
end
