classdef testCache < matlab.unittest.TestCase

    methods (Test)

        function testCacheCreation(testCase)
            % Test creating a cache object
            c = vlt.data.cache();
            testCase.verifyClass(c, 'vlt.data.cache');
            testCase.verifyEqual(c.maxMemory, 100e6);
            testCase.verifyEqual(c.replacement_rule, 'fifo');
        end

        function testAddAndLookup(testCase)
            % Test adding and looking up data
            c = vlt.data.cache('maxMemory', 1e6);
            testData = rand(100,100);
            c.add('mykey', 'mytype', testData);
            retrieved = c.lookup('mykey', 'mytype');
            testCase.verifyEqual(retrieved.data, testData);
        end

        function testRemove(testCase)
            % Test removing data
            c = vlt.data.cache('maxMemory', 1e6);
            testData = rand(100,100);
            c.add('mykey', 'mytype', testData);
            c.remove('mykey', 'mytype');
            retrieved = c.lookup('mykey', 'mytype');
            testCase.verifyEmpty(retrieved);
        end

        function testClear(testCase)
            % Test clearing the cache
            c = vlt.data.cache('maxMemory', 1e6);
            c.add('mykey1', 'mytype', rand(10,10));
            c.add('mykey2', 'mytype', rand(10,10));
            c.clear();
            testCase.verifyEqual(c.bytes(), 0);
        end

        function testFifoReplacement(testCase)
            % Test FIFO replacement rule
            c = vlt.data.cache('maxMemory', 900000, 'replacement_rule', 'fifo');
            c.add('key1', 'type1', zeros(1,100000)); % 800000 bytes
            c.add('key2', 'type2', zeros(1,100000)); % 800000 bytes
            % key1 should be gone
            retrieved1 = c.lookup('key1', 'type1');
            retrieved2 = c.lookup('key2', 'type2');
            testCase.verifyEmpty(retrieved1);
            testCase.verifyNotEmpty(retrieved2);
        end

        function testLifoReplacement(testCase)
            % Test LIFO replacement rule
            c = vlt.data.cache('maxMemory', 900000, 'replacement_rule', 'lifo');
            c.add('key1', 'type1', zeros(1,100000)); % 800000 bytes
            c.add('key2', 'type2', zeros(1,100000)); % 800000 bytes
            % key2 should be gone
            retrieved1 = c.lookup('key1', 'type1');
            retrieved2 = c.lookup('key2', 'type2');
            testCase.verifyNotEmpty(retrieved1);
            testCase.verifyEmpty(retrieved2);
        end

        function testErrorReplacement(testCase)
            % Test error replacement rule
            c = vlt.data.cache('maxMemory', 800000, 'replacement_rule', 'error');
            c.add('key1', 'type1', zeros(1,100000)); % 800000 bytes
            testCase.verifyError(@() c.add('key2', 'type2', zeros(1,1)), '');
        end

    end
end