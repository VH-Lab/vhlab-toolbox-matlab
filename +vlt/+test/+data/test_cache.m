function test_cache()
% TEST_CACHE - Test for vlt.data.cache class
%
    % Test case 1: Create a new cache object with default values
    c = vlt.data.cache();
    assert(c.maxMemory == 100e6, 'Default maxMemory should be 100e6');
    assert(strcmp(c.replacement_rule, 'fifo'), 'Default replacement_rule should be fifo');

    % Test case 2: Create a new cache object with custom values
    c = vlt.data.cache('maxMemory', 200e6, 'replacement_rule', 'lifo');
    assert(c.maxMemory == 200e6, 'Custom maxMemory should be 200e6');
    assert(strcmp(c.replacement_rule, 'lifo'), 'Custom replacement_rule should be lifo');

    % Test case 3: Add and lookup data
    c = vlt.data.cache();
    c.add('mykey', 'mytype', 'mydata');
    entry = c.lookup('mykey', 'mytype');
    assert(strcmp(entry.data, 'mydata'), 'Lookup should return the correct data');

    % Test case 4: Remove data
    c.remove('mykey', 'mytype');
    entry = c.lookup('mykey', 'mytype');
    assert(isempty(entry), 'Lookup should return empty after removing data');

    % Test case 5: Clear cache
    c.add('mykey1', 'mytype1', 'mydata1');
    c.add('mykey2', 'mytype2', 'mydata2');
    c.clear();
    assert(c.bytes() == 0, 'Cache should be empty after clearing');

    % Test case 6: maxMemory and replacement_rule 'error'
    c = vlt.data.cache('maxMemory', 10, 'replacement_rule', 'error');
    c.add('mykey', 'mytype', 'mydata'); % this is more than 10 bytes
    try
        c.add('mykey2', 'mytype2', 'mydata2');
        assert(false, 'Should have thrown an error');
    catch
        % expected
    end

    disp('All tests for vlt.data.cache passed.');
end
