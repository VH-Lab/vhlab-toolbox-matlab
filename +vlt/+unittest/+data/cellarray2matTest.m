classdef cellarray2matTest < matlab.unittest.TestCase
    methods (Test)
        function testSimple(testCase)
            c{1} = [1 2 3];
            c{2} = [4 5];
            m = vlt.data.cellarray2mat(c);
            testCase.verifyEqual(m, [1 4; 2 5; 3 NaN], 'AbsTol', 1e-9);
        end

        function testEmptyCellArray(testCase)
            c = {};
            testCase.verifyError(@() vlt.data.cellarray2mat(c), 'MATLAB:MException:Custom');
        end

        function testEmptyEntries(testCase)
            c{1} = [1 2 3];
            c{2} = [];
            c{3} = [4 5];
            m = vlt.data.cellarray2mat(c);
            testCase.verifyEqual(m, [1 NaN 4; 2 NaN 5; 3 NaN NaN], 'AbsTol', 1e-9);
        end

        function testNonVector(testCase)
            c{1} = [1 2; 3 4];
            testCase.verifyError(@() vlt.data.cellarray2mat(c), ?MException);
        end
    end
end
