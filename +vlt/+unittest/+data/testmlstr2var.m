classdef testmlstr2var < matlab.unittest.TestCase
    % TESTMLSTR2VAR - test the vlt.data.mlstr2var function

    properties
    end

    methods (Test)
        function testSimpleCases(testCase)
            % Test empty string
            testCase.verifyEqual(vlt.data.mlstr2var(''), []);

            % Test simple numeric value
            testCase.verifyEqual(vlt.data.mlstr2var('123'), 123);

            % Test numeric matrix
            testCase.verifyEqual(vlt.data.mlstr2var('[1 2; 3 4]'), [1 2; 3 4]);

            % Test char string
            testCase.verifyEqual(vlt.data.mlstr2var('''hello world'''), 'hello world');
        end

        function testCellArray(testCase)
            % Use cell2mlstr to generate a valid string
            c_original = {1, 'two', [3 3]};
            ml_str = vlt.data.cell2mlstr(c_original);

            c_reconstructed = vlt.data.mlstr2var(ml_str);

            testCase.verifyEqual(c_reconstructed, c_original);
        end

        function testStruct(testCase)
            % Use struct2mlstr to generate a valid string
            s_original = struct('a', 1, 'b', 'hello', 'c', [1; 2]);
            ml_str = vlt.data.struct2mlstr(s_original);

            s_reconstructed = vlt.data.mlstr2var(ml_str);

            testCase.verifyEqual(s_reconstructed, s_original);
        end

        function testStructArray(testCase)
            % Test an array of structs
            s_original(1).a = 1;
            s_original(1).b = 'one';
            s_original(2).a = 2;
            s_original(2).b = 'two';

            ml_str = vlt.data.struct2mlstr(s_original);
            s_reconstructed = vlt.data.mlstr2var(ml_str);

            testCase.verifyEqual(s_reconstructed, s_original);
        end

        function testNestedData(testCase)
            % Test a nested structure (struct containing a cell)
            s_original = struct('name', 'test', 'data', {{1, 'nested'}});
            ml_str = vlt.data.struct2mlstr(s_original);

            % This function is known to produce a warning about colon operands
            % As per user instructions, we are not fixing the source code, but
            % we will verify that the warning is thrown.
            testCase.verifyWarning(@() vlt.data.mlstr2var(ml_str), 'MATLAB:colon:nonscalar');

            % Now, call the function again to get the output for verification
            s_reconstructed = vlt.data.mlstr2var(ml_str);
            testCase.verifyEqual(s_reconstructed, s_original);
        end

        function testReshaping(testCase)
            % Test reshaping of a cell array
            c_original = {1, 2; 3, 4};
            ml_str = vlt.data.cell2mlstr(c_original);
            c_reconstructed = vlt.data.mlstr2var(ml_str);

            testCase.verifyEqual(c_reconstructed, c_original);
            testCase.verifyEqual(size(c_reconstructed), [2 2]);
        end
    end
end
