function test_ind2subD()
% TEST_IND2SUBD - Test for vlt.data.ind2subD
%
    matrix_size = [4 5 6];
    linear_index = 50;

    % Compare with built-in ind2sub
    [r, c, p] = ind2sub(matrix_size, linear_index);

    % Test dimension 1
    sub_index_dim1 = vlt.data.ind2subD(matrix_size, linear_index, 1);
    assert(sub_index_dim1 == r, 'Sub-index for dimension 1 is incorrect');

    % Test dimension 2
    sub_index_dim2 = vlt.data.ind2subD(matrix_size, linear_index, 2);
    assert(sub_index_dim2 == c, 'Sub-index for dimension 2 is incorrect');

    % Test dimension 3
    sub_index_dim3 = vlt.data.ind2subD(matrix_size, linear_index, 3);
    assert(sub_index_dim3 == p, 'Sub-index for dimension 3 is incorrect');

    disp('All tests for vlt.data.ind2subD passed.');
end
