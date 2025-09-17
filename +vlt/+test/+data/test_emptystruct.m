function test_emptystruct()
% TEST_EMPTYSTRUCT - Test for vlt.data.emptystruct
%
    % Test case 1: Create an empty struct with specified field names
    s = vlt.data.emptystruct('field1', 'field2');
    assert(isstruct(s), 's should be a struct');
    assert(isempty(s), 's should be empty');
    assert(isequal(fieldnames(s), {'field1'; 'field2'}), 'The field names are not correct');

    % Test case 2: Create an empty struct from a cell array of field names
    s = vlt.data.emptystruct({'field1', 'field2'});
    assert(isstruct(s), 's should be a struct');
    assert(isempty(s), 's should be empty');
    assert(isequal(fieldnames(s), {'field1'; 'field2'}), 'The field names are not correct');

    disp('All tests for vlt.data.emptystruct passed.');
end
