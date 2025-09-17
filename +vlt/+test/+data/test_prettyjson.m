function test_prettyjson()
% TEST_PRETTYJSON - Test for vlt.data.prettyjson
%
    % This function requires a Java library. If it's not available,
    % we can't run the test.
    try
        import org.json.JSONObject;
    catch
        warning('org.json.JSONObject not found, skipping test_prettyjson.');
        return;
    end

    mystruct = struct('a', 5, 'b', 3, 'c', 1);
    j = vlt.data.jsonencodenan(mystruct);
    j_pretty = vlt.data.prettyjson(j);

    % The exact output can vary, but it should contain newlines and the
    % field names.
    assert(contains(j_pretty, '\n'), 'The pretty JSON should contain newlines');
    assert(contains(j_pretty, '"a"'), 'The pretty JSON should contain the key "a"');
    assert(contains(j_pretty, '"b"'), 'The pretty JSON should contain the key "b"');
    assert(contains(j_pretty, '"c"'), 'The pretty JSON should contain the key "c"');

    disp('All tests for vlt.data.prettyjson passed.');
end
