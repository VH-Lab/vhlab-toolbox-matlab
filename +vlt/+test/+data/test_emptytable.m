function test_emptytable()
% TEST_EMPTYTABLE - Test for vlt.data.emptytable
%
    % Test case 1: Create an empty table
    t = vlt.data.emptytable("id","string","x","double","y","double");
    assert(istable(t), 't should be a table');
    assert(isempty(t), 't should be empty');
    assert(isequal(t.Properties.VariableNames, {'id', 'x', 'y'}), 'The variable names are not correct');
    assert(isequal(t.Properties.VariableTypes, {'string', 'double', 'double'}), 'The variable types are not correct');

    disp('All tests for vlt.data.emptytable passed.');
end
