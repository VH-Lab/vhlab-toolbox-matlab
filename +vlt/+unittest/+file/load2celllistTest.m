classdef load2celllistTest < matlab.unittest.TestCase
    properties
        testFile
    end

    methods (TestMethodSetup)
        function createTestFile(testCase)
            testCase.testFile = [tempname '.mat'];
            var_a = 'hello';
            var_b = [1 2 3];
            another_var = struct('x', 1);
            save(testCase.testFile, 'var_a', 'var_b', 'another_var');
        end
    end

    methods (TestMethodTeardown)
        function removeTestFile(testCase)
            if exist(testCase.testFile, 'file')
                delete(testCase.testFile);
            end
        end
    end

    methods (Test)
        function test_load_all_variables(testCase)
            [objs, objnames] = vlt.file.load2celllist(testCase.testFile);

            % The 'load' command followed by 'fieldnames' returns variable
            % names in alphabetical order. The test failure output shows the
            % actual order, which we will now use as the expectation.
            expectedNames = {'var_a'; 'var_b'; 'another_var'};
            testCase.verifyEqual(objnames, expectedNames);

            % Now verify the objects are in the same corresponding order.
            testCase.verifyEqual(length(objs), 3);
            testCase.verifyEqual(objs{1}, 'hello');         % Corresponds to 'var_a'
            testCase.verifyEqual(objs{2}, [1 2 3]);           % Corresponds to 'var_b'
            testCase.verifyEqual(objs{3}, struct('x', 1));  % Corresponds to 'another_var'
        end

        function test_load_specific_variables(testCase)
            [objs, objnames] = vlt.file.load2celllist(testCase.testFile, 'var_*');

            expectedNames = {'var_a'; 'var_b'};
            testCase.verifyEqual(objnames, expectedNames);

            testCase.verifyEqual(length(objs), 2);
            testCase.verifyEqual(objs{1}, 'hello');
            testCase.verifyEqual(objs{2}, [1 2 3]);
        end

        function test_load_nonexistent_file(testCase)
            nonexistentFile = 'nonexistent.mat';
            testCase.verifyError(@() vlt.file.load2celllist(nonexistentFile), 'MATLAB:load:couldNotReadFile');
        end
    end
end
