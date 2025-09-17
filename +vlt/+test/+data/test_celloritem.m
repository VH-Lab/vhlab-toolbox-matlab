function test_celloritem()
% TEST_CELLORITEM - Test for vlt.data.celloritem
%
    % Test case 1: VAR is a cell, no index
    mycell = {'a', 'b', 'c'};
    item = vlt.data.celloritem(mycell);
    assert(strcmp(item, 'a'), 'Should return the first item');

    % Test case 2: VAR is a cell, with index
    item = vlt.data.celloritem(mycell, 2);
    assert(strcmp(item, 'b'), 'Should return the second item');

    % Test case 3: VAR is not a cell, no index
    myvar = 'default';
    item = vlt.data.celloritem(myvar);
    assert(strcmp(item, 'default'), 'Should return the variable itself');

    % Test case 4: VAR is not a cell, with index, useindexforvar=0
    item = vlt.data.celloritem(myvar, 2);
    assert(strcmp(item, 'default'), 'Should return the variable itself');

    % Test case 5: VAR is not a cell, with index, useindexforvar=1
    myarray = [10 20 30];
    item = vlt.data.celloritem(myarray, 2, 1);
    assert(item == 20, 'Should return the indexed element');

    disp('All tests for vlt.data.celloritem passed.');
end
