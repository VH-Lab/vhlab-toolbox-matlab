classdef test_cell2matn < matlab.unittest.TestCase
    methods(Test)
        function test_standard_case(testCase)
            a{1,1} = 1; a{1,2} = 2; a{2,1} = 3;
            m = vlt.data.cell2matn(a);
            expected = [ 1 2 ; 3 NaN];
            testCase.verifyEqual(m, expected, 'AbsTol', 1e-9);
        end

        function test_all_numeric(testCase)
            a = {1, 2; 3, 4};
            m = vlt.data.cell2matn(a);
            expected = [1 2; 3 4];
            testCase.verifyEqual(m, expected, 'AbsTol', 1e-9);
        end

        function test_all_empty(testCase)
            a = cell(2,2);
            m = vlt.data.cell2matn(a);
            expected = [NaN NaN; NaN NaN];
            testCase.verifyEqual(m, expected, 'AbsTol', 1e-9);
        end

        function test_non_numeric_error(testCase)
            a = {1, 'hello'; 3, 4};
            testCase.verifyError(@() vlt.data.cell2matn(a), 'VLT:data:cell2matn:nonNumericEntry');
        end

        function test_non_scalar_error(testCase)
            a = {[1 2], 3; 4, 5};
            testCase.verifyError(@() vlt.data.cell2matn(a), 'VLT:data:cell2matn:nonScalarEntry');
        end
    end
end