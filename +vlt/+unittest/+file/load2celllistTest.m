classdef load2celllistTest < matlab.unittest.TestCase
    properties
        TestFile
        Var1_struct = struct('a', 1);
        Var2_string = 'hello';
        Var3_vector = [1 2 3];
    end

    methods (TestMethodSetup)
        function createTestFile(testCase)
            % Create a temporary .mat file for testing
            testCase.TestFile = [tempname '.mat'];

            % Save variables with distinct names to the file
            a_struct = testCase.Var1_struct;
            b_string = testCase.Var2_string;
            c_vector = testCase.Var3_vector;

            save(testCase.TestFile, 'a_struct', 'b_string', 'c_vector', '-v7.3');
        end
    end

    methods (TestMethodTeardown)
        function deleteTestFile(testCase)
            % Delete the temporary file
            if exist(testCase.TestFile, 'file')
                delete(testCase.TestFile);
            end
        end
    end

    methods (Test)
        function test_load_all_variables(testCase)
            [output, names] = vlt.file.load2celllist(testCase.TestFile);

            % The function returns a row vector, so we reshape it to a column
            % vector for the test, as per convention.
            output_col = output(:);
            names_col = names(:);

            % Expected output order is alphabetical by variable name
            expected_objs = {testCase.Var1_struct; testCase.Var2_string; testCase.Var3_vector};
            expected_names = {'a_struct'; 'b_string'; 'c_vector'};

            testCase.verifyEqual(names_col, expected_names);
            testCase.verifyEqual(output_col, expected_objs);
        end

        function test_load_specific_variables(testCase)
            [output, names] = vlt.file.load2celllist(testCase.TestFile, 'b_*', 'c_*');

            % The function returns a row vector, so we reshape it to a column
            % vector for the test.
            output_col = output(:);
            names_col = names(:);

            % Expected output order is alphabetical by variable name
            expected_objs = {testCase.Var2_string; testCase.Var3_vector};
            expected_names = {'b_string'; 'c_vector'};

            testCase.verifyEqual(names_col, expected_names);
            testCase.verifyEqual(output_col, expected_objs);
        end
    end
end
