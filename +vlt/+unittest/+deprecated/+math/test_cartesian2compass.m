classdef test_cartesian2compass < matlab.unittest.TestCase
% TEST_CARTESIAN2COMPASS - tests for the deprecated function cartesian2compass (vlt/math/cartesian2compass.m)

	methods (Test)

		function test_degrees(testCase)
			% cartesian 0 (right) is compass 90; cartesian 90 (up) is compass 0
			c = cartesian2compass([0 90 45], 0);
			testCase.verifyEqual(c, [90 0 45], 'AbsTol', 1e-12);
		end

		function test_degrees_not_wrapped(testCase)
			% the function does not wrap results into 0..360
			c = cartesian2compass(180, 0);
			testCase.verifyEqual(c, -90, 'AbsTol', 1e-12);
		end

		function test_radians(testCase)
			c = cartesian2compass([0 pi/2], 1);
			testCase.verifyEqual(c, [pi/2 0], 'AbsTol', 1e-12);
		end

		function test_round_trip(testCase)
			% the conversion is its own inverse
			r = [10 100 200 -30];
			c = cartesian2compass(r, 0);
			testCase.verifyEqual(cartesian2compass(c, 0), r, 'AbsTol', 1e-12);
		end

	end
end
