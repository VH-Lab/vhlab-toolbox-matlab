classdef test_dropzero < matlab.unittest.TestCase

	methods(Test)

		function test_dropzero_vector(testCase)
			a = [ 1 2 0 3 0 4 5 0];
			b = vlt.data.dropzero(a);
			testCase.verifyEqual([1 2 3 4 5], b);
		end

		function test_dropzero_matrix(testCase)
			a = [ 1 2 ; 3 4];
			testCase.verifyError(@() vlt.data.dropzero(a), '');
		end
	end
end
