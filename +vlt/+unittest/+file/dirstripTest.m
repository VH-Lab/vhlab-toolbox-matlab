classdef dirstripTest < matlab.unittest.TestCase
    methods(Test)
        function test_dirstrip(testCase)
            % Test that dirstrip removes ., .., .DS_Store, and .git

            ds = struct('name', {'.', '..', 'mydir', '.DS_Store', '.git', 'anotherdir', 'afile.txt'}, 'isdir', {1, 1, 1, 0, 1, 1, 0});

            d = vlt.file.dirstrip(ds);

            expected_names = {'mydir', 'anotherdir', 'afile.txt'};

            actual_names = {d.name};

            testCase.verifyEqual(sort(actual_names), sort(expected_names));
        end

        function test_dirstrip_empty(testCase)
            % Test that dirstrip handles empty input

            ds = struct('name', {}, 'isdir', {});

            d = vlt.file.dirstrip(ds);

            testCase.verifyTrue(isempty(d));
        end

        function test_dirstrip_no_removals(testCase)
            % Test that dirstrip handles input with nothing to remove

            ds = struct('name', {'mydir', 'anotherdir', 'afile.txt'}, 'isdir', {1, 1, 0});

            d = vlt.file.dirstrip(ds);

            expected_names = {'mydir', 'anotherdir', 'afile.txt'};

            actual_names = {d.name};

            testCase.verifyEqual(sort(actual_names), sort(expected_names));
        end
    end
end
