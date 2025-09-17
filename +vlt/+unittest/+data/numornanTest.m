classdef numornanTest < matlab.unittest.TestCase
    methods (Test)
        function testNonEmpty(testCase)
            testCase.verifyEqual(vlt.data.numornan(5), 5);
        end

        function testEmpty(testCase)
            testCase.verifyTrue(isnan(vlt.data.numornan([])));
        end

        function testEmptyWithDims(testCase)
            n_out = vlt.data.numornan([], [2 2]);
            testCase.verifyEqual(size(n_out), [2 2]);
            testCase.verifyTrue(all(isnan(n_out(:))));
        end

        function testPadding(testCase)
            n_out = vlt.data.numornan([1 2], [1 4]);
            testCase.verifyEqual(n_out, [1 2 NaN NaN], 'AbsTol', 1e-9);
        end
    end
end
