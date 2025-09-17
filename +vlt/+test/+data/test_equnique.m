function test_equnique()
% TEST_EQUNIQUE - Test for vlt.data.equnique
%
    % Test case 1: Numeric vector
    A = [1 2 2 3 1 4];
    B = vlt.data.equnique(A);
    assert(isequal(sort(B), [1; 2; 3; 4]), 'The unique elements are not correct');

    % Test case 2: Struct array
    S.a = 1; S.b = 2;
    A = [S S S];
    B = vlt.data.equnique(A);
    assert(length(B) == 1, 'There should be only one unique struct');
    assert(isequal(B, S), 'The unique struct is not correct');

    % Test case 3: Cell array of strings
    A = {'a', 'b', 'a', 'c'};
    B = vlt.data.equnique(A);
    assert(isequal(sort(B), {'a'; 'b'; 'c'}), 'The unique strings are not correct');

    disp('All tests for vlt.data.equnique passed.');
end
