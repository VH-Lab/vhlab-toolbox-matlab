classdef test_syncTriggers < matlab.unittest.TestCase
    methods (Test)
        function testExactMapping(testCase)
            T1 = [0 1 2 3];
            shift = 5;
            scale = 2;
            T2 = shift + scale * T1;

            mapping = vlt.time.syncTriggers(T1, T2);

            testCase.verifyEqual(mapping, [shift scale], 'AbsTol', 1e-6);
        end

        function testNoShift(testCase)
            T1 = [0 10 20];
            T2 = T1 * 0.5;

            mapping = vlt.time.syncTriggers(T1, T2);

            testCase.verifyEqual(mapping, [0 0.5], 'AbsTol', 1e-6);
        end

        function testErrorOnSizeMismatch(testCase)
            T1 = [1 2 3];
            T2 = [1 2];

            testCase.verifyError(@() vlt.time.syncTriggers(T1, T2), ...
                'vlt:time:syncTriggers:SizeMismatch');
        end

        function testArgumentsValidation(testCase)
            % Test with a cell array to ensure type mismatch
             testCase.verifyError(@() vlt.time.syncTriggers({1}, {2}), ...
                'MATLAB:validation:UnableToConvert');
        end

        function testInvalidMatrixInput(testCase)
            % Test with 2D matrix
            T1 = [1 2; 3 4];
            T2 = [1 2; 3 4];
            testCase.verifyError(@() vlt.time.syncTriggers(T1, T2), ...
                'vlt:time:syncTriggers:InvalidInput');
        end

        function testEmpty(testCase)
            T1 = [];
            T2 = [];
            mapping = vlt.time.syncTriggers(T1, T2);
            testCase.verifyEqual(mapping, [NaN NaN]);
        end

        function testRowVsColumn(testCase)
            T1 = [0 1 2]; % Row
            T2 = [10; 12; 14]; % Column
            % shift=10, scale=2
            mapping = vlt.time.syncTriggers(T1, T2);
            testCase.verifyEqual(mapping, [10 2], 'AbsTol', 1e-6);
        end

        function testLargeInput(testCase)
            % Test with N >= 100000 to trigger matrix division path
            N = 100005;
            T1 = linspace(0, 100, N);
            shift = -5.5;
            scale = 3.14;
            T2 = shift + scale * T1;

            mapping = vlt.time.syncTriggers(T1, T2);

            testCase.verifyEqual(mapping, [shift scale], 'AbsTol', 1e-5, 'Large input regression failed');
        end

        function testConstantInput(testCase)
            % Test when T1 is constant (infinite slope)
            T1 = [1 1 1 1];
            T2 = [1 2 3 4];
            mapping = vlt.time.syncTriggers(T1, T2);
            testCase.verifyTrue(all(isnan(mapping)), 'Constant input should result in NaNs');
        end
    end
end
