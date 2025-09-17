function test_celltable2struct()
% TEST_CELLTABLE2STRUCT - Test for vlt.data.celltable2struct
%
    % Test case 1: Simple case
    C = { {'header1', 'header2'}, {'data1', 10}, {'data2', 20} };
    S = vlt.data.celltable2struct(C);
    assert(length(S) == 2, 'The structure should have 2 elements');
    assert(strcmp(S(1).header1, 'data1'), 'S(1).header1 should be "data1"');
    assert(S(1).header2 == 10, 'S(1).header2 should be 10');
    assert(strcmp(S(2).header1, 'data2'), 'S(2).header1 should be "data2"');
    assert(S(2).header2 == 20, 'S(2).header2 should be 20');

    % Test case 2: Truncated entries
    C = { {'h1', 'h2', 'h3'}, {'d1', 1}, {'d2'} };
    S = vlt.data.celltable2struct(C);
    assert(length(S) == 2, 'The structure should have 2 elements');
    assert(strcmp(S(1).h1, 'd1'), 'S(1).h1 should be "d1"');
    assert(S(1).h2 == 1, 'S(1).h2 should be 1');
    assert(isempty(S(1).h3), 'S(1).h3 should be empty');
    assert(strcmp(S(2).h1, 'd2'), 'S(2).h1 should be "d2"');
    assert(isempty(S(2).h2), 'S(2).h2 should be empty');
    assert(isempty(S(2).h3), 'S(2).h3 should be empty');

    disp('All tests for vlt.data.celltable2struct passed.');
end
