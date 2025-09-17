classdef hasAllFieldsTest < matlab.unittest.TestCase
    properties
        r = struct('test1', 5, 'test2', [6 1]);
    end

    methods (Test)
        function testAllMatch(testCase)
            [g, e] = vlt.data.hasAllFields(testCase.r, {'test1', 'test2'}, {[1 1], [1 2]});
            testCase.verifyTrue(g);
            testCase.verifyEmpty(e);
        end

        function testMissingField(testCase)
            [g, e] = vlt.data.hasAllFields(testCase.r, {'test1', 'test3'}, {[1 1], [1 2]});
            testCase.verifyFalse(g);
            testCase.verifyEqual(e, '''test3'' not present.');
        end

        function testIncorrectSize(testCase)
            [g, e] = vlt.data.hasAllFields(testCase.r, {'test1', 'test2'}, {[1 1], [2 2]});
            testCase.verifyFalse(g);
            testCase.verifyTrue(contains(e, 'not of expected size'));
        end

        function testWildcardSize(testCase)
            [g, e] = vlt.data.hasAllFields(testCase.r, {'test1', 'test2'}, {[-1 -1], [-1 -1]});
            testCase.verifyTrue(g);
            testCase.verifyEmpty(e);
        end
    end
end
