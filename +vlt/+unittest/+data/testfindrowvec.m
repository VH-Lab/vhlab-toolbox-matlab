classdef testfindrowvec < matlab.unittest.TestCase

    methods (Test)

        function test_findrowvec_simple(testCase)
            % test a simple case
            a = [1 2; 3 4; 5 6; 1 2];
            b = [1 2];
            i = vlt.data.findrowvec(a,b);
            testCase.verifyEqual(i, [1; 4]);
        end

        function test_findrowvec_no_match(testCase)
            % test a case with no matches
            a = [1 2; 3 4; 5 6];
            b = [7 8];
            i = vlt.data.findrowvec(a,b);
            testCase.verifyTrue(isempty(i));
        end

        function test_findrowvec_b_not_row_vector(testCase)
            % test case where b is not a row vector
            a = [1 2; 3 4];
            b = [1; 2];
            testCase.verifyError(@() vlt.data.findrowvec(a,b), '');
        end

        function test_findrowvec_dims_mismatch(testCase)
            % test case where a and b have different numbers of columns
            a = [1 2; 3 4];
            b = [1 2 3];
            testCase.verifyError(@() vlt.data.findrowvec(a,b), '');
        end

        function test_findrowvec_empty_a(testCase)
            % test case with empty a
            a = [];
            b = [1 2];
            i = vlt.data.findrowvec(a,b);
            testCase.verifyTrue(isempty(i));
        end

        function test_findrowvec_empty_b_error(testCase)
            % test case with empty b, should error
            a = [1 2; 3 4];
            b = [];
            testCase.verifyError(@() vlt.data.findrowvec(a,b), '');
        end

        function test_findrowvec_booleans(testCase)
            % test handling of logicals
            a = [true false; false true; true false];
            b = [true false];
            i = vlt.data.findrowvec(a,b);
            testCase.verifyEqual(i,[1;3]);
        end
    end
end
