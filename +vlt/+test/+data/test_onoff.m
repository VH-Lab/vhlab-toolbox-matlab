function test_onoff()
% TEST_ONOFF - Test for vlt.data.onoff
%
    % Test case 1: Positive input
    assert(strcmp(vlt.data.onoff(1), 'on'), 'Should return "on" for 1');
    assert(strcmp(vlt.data.onoff(5), 'on'), 'Should return "on" for 5');

    % Test case 2: Zero input
    assert(strcmp(vlt.data.onoff(0), 'off'), 'Should return "off" for 0');

    % Test case 3: Negative input
    assert(strcmp(vlt.data.onoff(-1), 'off'), 'Should return "off" for -1');
    assert(strcmp(vlt.data.onoff(-5), 'off'), 'Should return "off" for -5');

    disp('All tests for vlt.data.onoff passed.');
end
