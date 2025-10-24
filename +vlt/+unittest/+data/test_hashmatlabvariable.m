classdef test_hashmatlabvariable < matlab.unittest.TestCase

    properties
    end

    methods (Test)
        function test_hash_consistency(testCase)
            % Test that hashing is consistent for the same data
            % and different for different data.

            % Create some sample data
            data1 = struct('a', randn(5,3), 'b', {{'string1', 'string2'}});
            data2 = struct('a', randn(5,3), 'b', {{'string1', 'string3'}}); % different data
            data3 = data1; % same data

            % Calculate hashes
            hash1 = vlt.data.hashmatlabvariable(data1);
            hash2 = vlt.data.hashmatlabvariable(data2);
            hash3 = vlt.data.hashmatlabvariable(data3);

            % Check types
            testCase.verifyClass(hash1, 'char');
            testCase.verifyTrue(isrow(hash1)); % should be a row vector of chars

            % Check consistency
            testCase.verifyEqual(hash1, hash3, 'Hashing the same variable should produce the same hash.');
            testCase.verifyNotEqual(hash1, hash2, 'Hashing different variables should produce different hashes.');
        end

        function test_different_data_types(testCase)
            % Test hashing various data types

            % Numeric
            numeric_data = [1 2 3; 4 5 6];
            hash_numeric = vlt.data.hashmatlabvariable(numeric_data);
            testCase.verifyClass(hash_numeric, 'char');
            testCase.verifyEqual(hash_numeric, vlt.data.hashmatlabvariable(numeric_data));

            % Cell array
            cell_data = {'hello', 5, [1; 2]};
            hash_cell = vlt.data.hashmatlabvariable(cell_data);
            testCase.verifyClass(hash_cell, 'char');
            testCase.verifyEqual(hash_cell, vlt.data.hashmatlabvariable(cell_data));

            % String
            string_data = "this is a string";
            hash_string = vlt.data.hashmatlabvariable(string_data);
            testCase.verifyClass(hash_string, 'char');
            testCase.verifyEqual(hash_string, vlt.data.hashmatlabvariable(string_data));

            % Char
            char_data = 'this is a char';
            hash_char = vlt.data.hashmatlabvariable(char_data);
            testCase.verifyClass(hash_char, 'char');
            testCase.verifyEqual(hash_char, vlt.data.hashmatlabvariable(char_data));

            % Check that different types give different hashes
            testCase.verifyNotEqual(hash_numeric, hash_cell);
            testCase.verifyNotEqual(hash_string, hash_char);
        end
    end
end
