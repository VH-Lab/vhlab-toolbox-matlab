function test_conditional()
% TEST_CONDITIONAL - Test for vlt.data.conditional
%
    % Test case 1: Test is true
    C = vlt.data.conditional(1, 'a', 'b');
    assert(strcmp(C, 'a'), 'C should be "a"');

    % Test case 2: Test is false (0)
    C = vlt.data.conditional(0, 'a', 'b');
    assert(strcmp(C, 'b'), 'C should be "b"');

    % Test case 3: Test is false (negative)
    C = vlt.data.conditional(-1, 'a', 'b');
    assert(strcmp(C, 'b'), 'C should be "b"');

    disp('All tests for vlt.data.conditional passed.');
end
