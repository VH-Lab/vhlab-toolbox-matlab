classdef dirlist_trimdotsTest < matlab.unittest.TestCase
    methods(Test)
        function test_cell_array_input(testCase)
            % Test with a cell array of strings
            dirlist = {'.', '..', 'mydir', '.DS_Store', '.git', '.svn', '__pycache__', 'anotherdir'};
            expected = {'mydir', 'anotherdir'};
            actual = vlt.file.dirlist_trimdots(dirlist);
            testCase.verifyEqual(sort(actual), sort(expected));
        end

        function test_struct_input(testCase)
            % Test with a struct from MATLAB's dir function
            dirlist = struct('name', {'.', '..', 'mydir', '.DS_Store', '.git', '.svn', '__pycache__', 'anotherdir'}, 'isdir', {1, 1, 1, 0, 1, 1, 1, 1});
            expected = {'mydir', 'anotherdir'};
            actual = vlt.file.dirlist_trimdots(dirlist);
            testCase.verifyEqual(sort(actual), sort(expected));
        end

        function test_struct_output(testCase)
            % Test with a struct from MATLAB's dir function and struct output
            dirlist = struct('name', {'.', '..', 'mydir', '.DS_Store', '.git', '.svn', '__pycache__', 'anotherdir'}, 'isdir', {1, 1, 1, 0, 1, 1, 1, 1});
            expected = struct('name', {'mydir', 'anotherdir'}, 'isdir', {1, 1});
            actual = vlt.file.dirlist_trimdots(dirlist, 1);
            [~, order] = sort({expected.name});
            expected = expected(order);
            [~, order] = sort({actual.name});
            actual = actual(order);
            testCase.verifyEqual(actual, expected);
        end

        function test_empty_input(testCase)
            % Test with an empty cell array
            dirlist = {};
            expected = {};
            actual = vlt.file.dirlist_trimdots(dirlist);
            testCase.verifyEqual(actual, expected);
        end

        function test_no_dots_input(testCase)
            % Test with a cell array containing no dots
            dirlist = {'mydir', 'anotherdir'};
            expected = {'mydir', 'anotherdir'};
            actual = vlt.file.dirlist_trimdots(dirlist);
            testCase.verifyEqual(sort(actual), sort(expected));
        end
    end
end
