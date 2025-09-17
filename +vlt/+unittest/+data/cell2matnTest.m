classdef cell2matnTest < matlab.unittest.TestCase
    methods (Test)
        function testSimple(testCase)
            a{1,1} = 1; a{1,2} = 2; a{2,1} = 3;
            m = vlt.data.cell2matn(a);
            testCase.verifyEqual(m, [1 2; 3 NaN], 'AbsTol', 1e-9);
        end

        function testAllEmpty(testCase)
            a = cell(2,2);
            m = vlt.data.cell2matn(a);
            testCase.verifyEqual(m, [NaN NaN; NaN NaN], 'AbsTol', 1e-9);
        end

        function testNonNumeric(testCase)
            a{1,1} = 'hello';
            testCase.verifyError(@() vlt.data.cell2matn(a), ?MException);
        end

        function testNonScalar(testCase)
            a{1,1} = [1 2];
            testCase.verifyError(@() vlt.data.cell2matn(a), ?MException);
        end
    end
end
