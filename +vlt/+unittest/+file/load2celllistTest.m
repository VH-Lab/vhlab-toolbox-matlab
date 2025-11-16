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

            expectedNames = {'another_var'; 'var_a'; 'var_b'};
            expectedObjs = {struct('x', 1); 'hello'; [1 2 3]};

            % Sort both actual and expected names to make test order-independent
            [sorted_objnames, p_actual] = sort(objnames);
            [sorted_expectedNames, p_expected] = sort(expectedNames);

            % Reorder the corresponding object cells based on the sort permutation
            sorted_objs = objs(p_actual);
            sorted_expectedObjs = expectedObjs(p_expected);

            % Use (:) to make the comparison insensitive to row vs column vector orientation
            testCase.verifyEqual(sorted_objnames(:), sorted_expectedNames(:));
            testCase.verifyEqual(sorted_objs(:), sorted_expectedObjs(:));
        end

        function test_load_specific_variables(testCase)
            [objs, objnames] = vlt.file.load2celllist(testCase.testFile, 'var_*');

            expectedNames = {'var_a'; 'var_b'};
            expectedObjs = {'hello'; [1 2 3]};

            % Sort both actual and expected names to make test order-independent
            [sorted_objnames, p_actual] = sort(objnames);
            [sorted_expectedNames, p_expected] = sort(expectedNames);

            % Reorder the corresponding object cells
            sorted_objs = objs(p_actual);
            sorted_expectedObjs = expectedObjs(p_expected);

            % Use (:) to make the comparison insensitive to row vs column vector orientation
            testCase.verifyEqual(sorted_objnames(:), sorted_expectedNames(:));
            testCase.verifyEqual(sorted_objs(:), sorted_expectedObjs(:));
        end

        function test_load_nonexistent_file(testCase)
            nonexistentFile = 'nonexistent.mat';
            testCase.verifyError(@() vlt.file.load2celllist(nonexistentFile), 'MATLAB:load:couldNotReadFile');
        end
    end
end
