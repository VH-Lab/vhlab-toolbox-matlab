classdef ind2subDTest < matlab.unittest.TestCase
    properties
        matrix_size = [4 5 6];
        linear_index = 50;
    end

    methods (Test)
        function testDim1(testCase)
            [r, ~, ~] = ind2sub(testCase.matrix_size, testCase.linear_index);
            sub_index_dim1 = vlt.data.ind2subD(testCase.matrix_size, testCase.linear_index, 1);
            testCase.verifyEqual(sub_index_dim1, uint64(r));
        end

        function testDim2(testCase)
            [~, c, ~] = ind2sub(testCase.matrix_size, testCase.linear_index);
            sub_index_dim2 = vlt.data.ind2subD(testCase.matrix_size, testCase.linear_index, 2);
            testCase.verifyEqual(sub_index_dim2, uint64(c));
        end

        function testDim3(testCase)
            [~, ~, p] = ind2sub(testCase.matrix_size, testCase.linear_index);
            sub_index_dim3 = vlt.data.ind2subD(testCase.matrix_size, testCase.linear_index, 3);
            testCase.verifyEqual(sub_index_dim3, uint64(p));
        end
    end
end
