function test_str2nume()
% TEST_STR2NUME - Test for vlt.data.str2nume
%
    % Test case 1: Valid number string
    assert(vlt.data.str2nume('123') == 123, 'Should convert "123" to 123');

    % Test case 2: Empty string
    assert(isempty(vlt.data.str2nume('')), 'Should return empty for an empty string');

    % Test case 3: String with non-numeric characters
    assert(isempty(vlt.data.str2nume('abc')), 'Should return empty for a non-numeric string');

    disp('All tests for vlt.data.str2nume passed.');
end
