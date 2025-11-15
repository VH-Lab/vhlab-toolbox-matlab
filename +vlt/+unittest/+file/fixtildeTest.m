classdef fixtildeTest < matlab.unittest.TestCase

    properties
        homeDir
    end

    methods(TestMethodSetup)
        function getHomeDir(testCase)
            % Determine home directory in a platform-independent way
            currdir = pwd;
            cd('~');
            testCase.homeDir = pwd;
            cd(currdir);
        end
    end

    methods(Test)

        function test_leading_tilde(testCase)
            in_path = ['~' filesep 'testfile.txt'];
            expected_path = [testCase.homeDir filesep 'testfile.txt'];

            out_path = vlt.file.fixtilde(in_path);

            testCase.verifyEqual(out_path, expected_path);
        end

        function test_just_tilde(testCase)
            in_path = '~';
            expected_path = testCase.homeDir;

            out_path = vlt.file.fixtilde(in_path);

            testCase.verifyEqual(out_path, expected_path);
        end

        function test_no_tilde(testCase)
            in_path = ['my' filesep 'path' filesep 'testfile.txt'];

            out_path = vlt.file.fixtilde(in_path);

            testCase.verifyEqual(out_path, in_path);
        end

        function test_tilde_in_middle(testCase)
            in_path = ['my' filesep 'path~' filesep 'testfile.txt'];

            out_path = vlt.file.fixtilde(in_path);

            testCase.verifyEqual(out_path, in_path);
        end

        function test_empty_string(testCase)
            % The code will error because fn(1) will be an invalid index.
            testCase.verifyError(@() vlt.file.fixtilde(''), 'MATLAB:badsubscript');
        end

    end
end
