classdef test_numornan < matlab.unittest.TestCase
    % TEST_NUMORNAN - tests for the vlt.data.numornan function

    methods (Test)

        function test_numornan_basic(testCase)
            % Test case 1: Non-empty input
            testCase.verifyEqual(vlt.data.numornan(5), 5);
            testCase.verifyEqual(vlt.data.numornan([1 2]), [1 2]);

            % Test case 2: Empty input
            testCase.verifyTrue(isnan(vlt.data.numornan([])));
        end

        function test_numornan_with_dims(testCase)
            % Test case 1: Empty input with specified dimensions
            testCase.verifyEqual(size(vlt.data.numornan([], [2 3])), [2 3]);
            testCase.verifyTrue(all(isnan(vlt.data.numornan([], [2 3])),'all'));

            % Test case 2: Non-empty input, smaller than dims
            input = [1 2; 3 4];
            output = vlt.data.numornan(input, [3 3]);
            expected = [1 2 NaN; 3 4 NaN; NaN NaN NaN];
            % Use isequaln to handle NaNs
            testCase.verifyTrue(isequaln(output, expected));

            % Test case 3: Non-empty input, larger than dims (should error)
            testCase.verifyError(@() vlt.data.numornan([1 2; 3 4], [1 1]), '');
        end

    end; % methods (Test)

end
