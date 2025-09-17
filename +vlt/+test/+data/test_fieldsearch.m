function test_fieldsearch()
% TEST_FIELDSEARCH - Test for vlt.data.fieldsearch
%
    A = struct('a', 'string_test', 'b', [1 2 3], 'c', struct('d', 5));

    % Test 'contains_string'
    search = struct('field','a','operation','contains_string','param1','test','param2','');
    assert(vlt.data.fieldsearch(A, search), 'Test contains_string failed');

    % Test 'greaterthaneq'
    search = struct('field','b','operation','greaterthaneq','param1',1,'param2','');
    assert(vlt.data.fieldsearch(A, search), 'Test greaterthaneq failed');

    % Test 'hasfield'
    search = struct('field','b','operation','hasfield','param1','','param2','');
    assert(vlt.data.fieldsearch(A, search), 'Test hasfield failed');

    % Test 'hasanysubfield_exact_string' - this is complex, needs more work
    % For now, just test a simple case
    B = struct('values',A);
    search = struct('field','values','operation','hasanysubfield_exact_string','param1','a','param2','string_test');
    assert(vlt.data.fieldsearch(B, search), 'Test hasanysubfield_exact_string failed');

    % Test 'or'
    search = struct('field','','operation','or', ...
        'param1', struct('field','b','operation','hasfield','param1','','param2',''), ...
        'param2', struct('field','c','operation','hasfield','param1','','param2','') );
    assert(vlt.data.fieldsearch(A, search), 'Test or failed');

    % Test negation
    search = struct('field','a','operation','~contains_string','param1','not_present','param2','');
    assert(vlt.data.fieldsearch(A, search), 'Test negation failed');

    disp('All tests for vlt.data.fieldsearch passed.');
end
