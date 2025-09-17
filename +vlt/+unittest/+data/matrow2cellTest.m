classdef matrow2cellTest < matlab.unittest.TestCase
    methods (Test)
        function testSimpleMatrix(testCase)
            A = [1 2; 3 4];
            B = vlt.data.matrow2cell(A);
            testCase.verifyTrue(iscell(B));
            testCase.verifyEqual(B{1}, [1 2]);
            testCase.verifyEqual(B{2}, [3 4]);
        end

        function testCellInput(testCase)
            A = {[1 2], [3 4]};
            B = vlt.data.matrow2cell(A);
            testCase.verifyEqual(A, B);
        end
    end
end
