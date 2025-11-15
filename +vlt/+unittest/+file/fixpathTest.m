classdef fixpathTest < matlab.unittest.TestCase

    methods(Test)

        function test_adds_filesep(testCase)
            path_in = 'mytestpath';
            expected_path = ['mytestpath' filesep];

            path_out = vlt.file.fixpath(path_in);

            testCase.verifyEqual(path_out, expected_path);
        end

        function test_no_change_needed(testCase)
            path_in = ['mytestpath' filesep];

            path_out = vlt.file.fixpath(path_in);

            testCase.verifyEqual(path_out, path_in);
        end

        function test_empty_string(testCase)
            % An empty string should probably error, but let's test current behavior.
            % The code will error because pathn(end) will be an invalid index.
            testCase.verifyError(@() vlt.file.fixpath(''), 'MATLAB:badsubscript');
        end

        function test_single_char(testCase)
            path_in = 'a';
            expected_path = ['a' filesep];

            path_out = vlt.file.fixpath(path_in);

            testCase.verifyEqual(path_out, expected_path);
        end

    end
end
