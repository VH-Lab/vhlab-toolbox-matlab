function test_jsonencodenan()
% TEST_JSONENCODENAN - Test for vlt.data.jsonencodenan
%
    my_struct.a = [1 2 NaN Inf -Inf];
    json_str = vlt.data.jsonencodenan(my_struct);

    % The exact string representation can vary, so we check for the
    % presence of the key components.
    assert(contains(json_str, '"a"'), 'The JSON string should contain the key "a"');
    assert(contains(json_str, 'NaN'), 'The JSON string should contain NaN');
    assert(contains(json_str, 'Infinity'), 'The JSON string should contain Infinity');
    assert(contains(json_str, '-Infinity'), 'The JSON string should contain -Infinity');

    disp('All tests for vlt.data.jsonencodenan passed.');
end
