function test_mlstr2var()
% TEST_MLSTR2VAR - Test for vlt.data.mlstr2var
%
    % Test case 1: Cell array
    C = {'test', 5, [3 4 5]};
    str = vlt.data.cell2mlstr(C);
    C_reconstructed = vlt.data.mlstr2var(str);
    assert(isequal(C, C_reconstructed), 'Reconstructed cell array does not match the original');

    % Test case 2: Struct
    S.a = 1;
    S.b = 'hello';
    str = vlt.data.struct2mlstr(S);
    S_reconstructed = vlt.data.mlstr2var(str);
    assert(isequal(S, S_reconstructed), 'Reconstructed struct does not match the original');

    % Test case 3: Nested structure
    S2.c = {1, 2};
    S.c = S2;
    str = vlt.data.struct2mlstr(S);
    S_reconstructed = vlt.data.mlstr2var(str);
    assert(isequal(S, S_reconstructed), 'Reconstructed nested struct does not match the original');

    disp('All tests for vlt.data.mlstr2var passed.');
end
