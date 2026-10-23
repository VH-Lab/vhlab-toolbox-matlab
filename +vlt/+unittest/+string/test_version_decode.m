classdef test_version_decode < matlab.unittest.TestCase
% TEST_VERSION_DECODE - tests for vlt.string.version_decode

	methods (Test)

		function test_documented_example(testCase)
			testCase.verifyEqual(vlt.string.version_decode('5.0.32.100'), [5 0 32 100]);
		end

		function test_single_number(testCase)
			testCase.verifyEqual(vlt.string.version_decode('3'), 3);
		end

		function test_three_parts(testCase)
			testCase.verifyEqual(vlt.string.version_decode('1.2.3'), [1 2 3]);
		end

		function test_multidigit(testCase)
			testCase.verifyEqual(vlt.string.version_decode('10.20'), [10 20]);
		end

	end
end
