function test_flattenstruct2table()
% TEST_FLATTENSTRUCT2TABLE - Test for vlt.data.flattenstruct2table
%
    % Test case 1: Simple structure
    S = struct('A', 1, 'B', 2);
    T = vlt.data.flattenstruct2table(S);
    assert(isequal(T.A, 1), 'T.A should be 1');
    assert(isequal(T.B, 2), 'T.B should be 2');

    % Test case 2: Nested structure
    S = struct('A', struct('X', 1, 'Y', 2), 'B', 3);
    T = vlt.data.flattenstruct2table(S);
    assert(isequal(T.('A.X'), 1), 'T.A_X should be 1');
    assert(isequal(T.('A.Y'), 2), 'T.A_Y should be 2');
    assert(isequal(T.B, 3), 'T.B should be 3');

    % Test case 3: Nested struct array
    Sub = struct('X', {10, 20}, 'Y', {'a', 'b'});
    S = struct('A', Sub, 'C', 3);
    T = vlt.data.flattenstruct2table(S);
    assert(iscell(T.('A.X')), 'T.A_X should be a cell');
    assert(isequal(T.('A.X'){1}, [10 20]), 'T.A_X{1} should be [10 20]');
    assert(iscell(T.('A.Y')), 'T.A_Y should be a cell');
    assert(isequal(T.('A.Y'){1}, {'a', 'b'}), 'T.A_Y{1} should be {''a'', ''b''}');
    assert(isequal(T.C, 3), 'T.C should be 3');

    % Test case 4: Abbreviations
    S = struct('long_name_A', 1, 'long_name_B', 2);
    abbrev = {{'long_name_', ''}};
    T = vlt.data.flattenstruct2table(S, abbrev);
    assert(isequal(T.A, 1), 'T.A should be 1');
    assert(isequal(T.B, 2), 'T.B should be 2');

    disp('All tests for vlt.data.flattenstruct2table passed.');
end
