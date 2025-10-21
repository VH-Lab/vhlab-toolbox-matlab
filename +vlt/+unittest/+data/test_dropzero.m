classdef test_dropzero < matlab.unittest.TestCase

	methods(Test)

		function test_mixed_vector(testCase)
			% Test a vector with a mix of zero and non-zero elements
			a = [ 1 2 0 3 0 4 5 0];
			b = vlt.data.dropzero(a);
			testCase.verifyEqual(b, [1 2 3 4 5]);
		end

		function test_matrix_input(testCase)
			% Test that a matrix input throws an error
			a = [ 1 2 ; 3 4];
			% The custom validator should throw an error with its specific ID
			testCase.verifyError(@() vlt.data.dropzero(a), 'vlt:validators:mustBeVectorOrEmpty');
		end

		function test_empty_vector(testCase)
			% Test that an empty vector returns an empty vector
			a = [];
			b = vlt.data.dropzero(a);
			testCase.verifyTrue(isempty(b));
        end

		function test_no_zeros_vector(testCase)
			% Test a vector with no zero elements
			a = [1 2 3 4 5];
			b = vlt.data.dropzero(a);
			testCase.verifyEqual(b, a);
		end

		function test_all_zeros_vector(testCase)
			% Test a vector with only zero elements
			a = [0 0 0 0];
			b = vlt.data.dropzero(a);
			testCase.verifyTrue(isempty(b));
		end
	end
end
