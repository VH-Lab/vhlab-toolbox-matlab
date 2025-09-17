function test_catCellStr()
% TEST_CATCELLSTR - Test for vlt.data.catCellStr
%
    % Test case 1: Simple concatenation
    mycell = {'hello', 'world'};
    mystr = vlt.data.catCellStr(mycell);
    assert(strcmp(mystr, ' hello world'), 'The concatenated string should be " hello world"');

    % Test case 2: Empty cell array
    mycell = {};
    mystr = vlt.data.catCellStr(mycell);
    assert(strcmp(mystr, ''), 'The concatenated string should be empty');

    % Test case 3: Cell array with one element
    mycell = {'test'};
    mystr = vlt.data.catCellStr(mycell);
    assert(strcmp(mystr, ' test'), 'The concatenated string should be " test"');

    disp('All tests for vlt.data.catCellStr passed.');
end
