classdef test_pcolordummyrowcolumn < matlab.unittest.TestCase
    methods(Test)
        function test_pcolordummyrowcolumn_adds_row_and_col(testCase)
            % Test that pcolordummyrowcolumn adds a dummy row and column

            C_in = [1 2; 3 4];

            % Expected output: The input matrix with a row and column of zeros appended
            C_expected = [1 2 0; 3 4 0; 0 0 0];

            C_out = vlt.matlab.graphics.pcolordummyrowcolumn(C_in);

            testCase.verifyEqual(C_out, C_expected);
        end
    end
end
