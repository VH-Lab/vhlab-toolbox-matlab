classdef cacheTest < matlab.unittest.TestCase
    methods (Test)
        function testDefaultCreation(testCase)
            c = vlt.data.cache();
            testCase.verifyEqual(c.maxMemory, 100e6);
            testCase.verifyEqual(c.replacement_rule, 'fifo');
        end

        function testCustomCreation(testCase)
            c = vlt.data.cache('maxMemory', 200e6, 'replacement_rule', 'lifo');
            testCase.verifyEqual(c.maxMemory, 200e6);
            testCase.verifyEqual(c.replacement_rule, 'lifo');
        end

        function testAddAndLookup(testCase)
            c = vlt.data.cache();
            c.add('mykey', 'mytype', 'mydata');
            entry = c.lookup('mykey', 'mytype');
            testCase.verifyEqual(entry.data, 'mydata');
        end

        function testRemove(testCase)
            c = vlt.data.cache();
            c.add('mykey', 'mytype', 'mydata');
            c.remove('mykey', 'mytype');
            entry = c.lookup('mykey', 'mytype');
            testCase.verifyEmpty(entry);
        end

        function testClear(testCase)
            c = vlt.data.cache();
            c.add('mykey1', 'mytype1', 'mydata1');
            c.add('mykey2', 'mytype2', 'mydata2');
            c.clear();
            testCase.verifyEqual(c.bytes(), 0);
        end

        function testMaxMemoryError(testCase)
            c = vlt.data.cache('maxMemory', 10, 'replacement_rule', 'error');
            testCase.verifyError(@() c.add('mykey', 'mytype', 'mydata'), 'MATLAB:MException:Custom');
        end
    end
end
