function test_listofvars()
% TEST_LISTOFVARS - Test for vlt.data.listofvars
%
    % We need to create some variables in the base workspace to test this function
    assignin('base', 'test_var_a', 5);
    assignin('base', 'test_var_b', 'hello');
    assignin('base', 'test_var_c', [1 2 3]);

    % Test for 'double' class
    double_vars = vlt.data.listofvars('double');
    assert(any(strcmp(double_vars, 'test_var_a')), 'test_var_a should be in the list');
    assert(any(strcmp(double_vars, 'test_var_c')), 'test_var_c should be in the list');
    assert(~any(strcmp(double_vars, 'test_var_b')), 'test_var_b should not be in the list');

    % Test for 'char' class
    char_vars = vlt.data.listofvars('char');
    assert(any(strcmp(char_vars, 'test_var_b')), 'test_var_b should be in the list');
    assert(~any(strcmp(char_vars, 'test_var_a')), 'test_var_a should not be in the list');

    % Clean up the base workspace
    evalin('base', 'clear test_var_a test_var_b test_var_c');

    disp('All tests for vlt.data.listofvars passed.');
end
