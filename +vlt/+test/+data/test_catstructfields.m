function test_catstructfields()
% TEST_CATSTRUCTFIELDS - Test for vlt.data.catstructfields
%
    % Test case 1: Simple concatenation
    a.field1 = [1 2 3];
    a.field2 = [1 2 3];
    b.field1 = [4 5 6];
    b.field2 = [4 5 6];
    c = vlt.data.catstructfields(a, b);
    assert(isequal(c.field1, [1 2 3 4 5 6]), 'field1 should be concatenated');
    assert(isequal(c.field2, [1 2 3 4 5 6]), 'field2 should be concatenated');

    % Test case 2: Concatenation along a specified dimension
    a.field1 = [1; 2; 3];
    a.field2 = [1; 2; 3];
    b.field1 = [4; 5; 6];
    b.field2 = [4; 5; 6];
    c = vlt.data.catstructfields(a, b, 1);
    assert(isequal(c.field1, [1; 2; 3; 4; 5; 6]), 'field1 should be concatenated along dimension 1');
    assert(isequal(c.field2, [1; 2; 3; 4; 5; 6]), 'field2 should be concatenated along dimension 1');

    % Test case 3: Mismatched field names
    a.field1 = 1;
    b.field2 = 2;
    try
        vlt.data.catstructfields(a, b);
        assert(false, 'Should have thrown an error for mismatched field names');
    catch
        % expected
    end

    disp('All tests for vlt.data.catstructfields passed.');
end
