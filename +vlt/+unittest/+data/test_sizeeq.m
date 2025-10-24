classdef test_sizeeq < matlab.unittest.TestCase
    methods (Test)
        function test_sizeeq_equal_matrices(testCase)
            A = rand(2,3);
            B = zeros(2,3);
            testCase.verifyTrue(logical(vlt.data.sizeeq(A,B)));
        end

        function test_sizeeq_unequal_dimensions(testCase)
            A = rand(2,3);
            B = rand(2,3,4);
            testCase.verifyFalse(logical(vlt.data.sizeeq(A,B)));
        end

        function test_sizeeq_unequal_sizes(testCase)
            A = rand(2,3);
            B = rand(3,2);
            testCase.verifyFalse(logical(vlt.data.sizeeq(A,B)));
        end

        function test_sizeeq_row_vs_col_vector(testCase)
            A = rand(1,5);
            B = rand(5,1);
            testCase.verifyFalse(logical(vlt.data.sizeeq(A,B)));
        end

        function test_sizeeq_both_empty(testCase)
            A = [];
            B = [];
            testCase.verifyTrue(logical(vlt.data.sizeeq(A,B)));
        end

        function test_sizeeq_one_empty(testCase)
            A = [];
            B = rand(1,1);
            testCase.verifyFalse(logical(vlt.data.sizeeq(A,B)));
        end

        function test_sizeeq_scalars(testCase)
            A = 5;
            B = 10;
            testCase.verifyTrue(logical(vlt.data.sizeeq(A,B)));
        end
    end
end
