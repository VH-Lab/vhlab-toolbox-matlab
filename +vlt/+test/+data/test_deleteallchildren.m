function test_deleteallchildren()
% TEST_DELETEALLCHILDREN - Test for vlt.data.deleteallchildren
%
    % Test case 1: Delete children of an axes
    f = figure;
    plot(1:10);
    hold on;
    plot(10:-1:1);
    vlt.data.deleteallchildren(gca);
    assert(isempty(get(gca, 'Children')), 'The axes should be empty');
    close(f);

    disp('All tests for vlt.data.deleteallchildren passed.');
end
