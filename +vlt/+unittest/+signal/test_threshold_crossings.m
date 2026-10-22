classdef test_threshold_crossings < matlab.unittest.TestCase
% TEST_THRESHOLD_CROSSINGS - tests for vlt.signal.threshold_crossings

	methods (Test)

		function test_basic_crossings(testCase)
			idx = vlt.signal.threshold_crossings([0 1 2 0 3], 1);
			testCase.verifyEqual(idx, [2 5]);
		end

		function test_equal_to_threshold_counts(testCase)
			idx = vlt.signal.threshold_crossings([0 0.5 0], 0.5);
			testCase.verifyEqual(idx, 2);
		end

		function test_starting_above_is_not_crossing(testCase)
			idx = vlt.signal.threshold_crossings([5 5 5], 1);
			testCase.verifyTrue(isempty(idx));
		end

		function test_downward_is_not_crossing(testCase)
			idx = vlt.signal.threshold_crossings([5 0 0], 1);
			testCase.verifyTrue(isempty(idx));
		end

		function test_sine_wave(testCase)
			t = 0:0.01:2;
			x = sin(2*pi*t - pi/2); % starts at -1, crosses 0 upward at t=0.25 and t=1.25
			idx = vlt.signal.threshold_crossings(x, 0);
			testCase.verifyEqual(numel(idx), 2);
			testCase.verifyTrue(all(x(idx) >= 0));
			testCase.verifyTrue(all(x(idx-1) < 0));
		end

		function test_column_input(testCase)
			idx = vlt.signal.threshold_crossings([0;2;0;2], 1);
			testCase.verifyEqual(idx(:), [2;4]);
		end

	end
end
