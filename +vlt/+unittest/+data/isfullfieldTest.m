classdef isfullfieldTest < matlab.unittest.TestCase
    properties
        A = struct('a', struct('sub1', 1, 'sub2', 2), 'b', 5);
    end

    methods (Test)
        function testExistingField(testCase)
            [b, value] = vlt.data.isfullfield(testCase.A, 'b');
            testCase.verifyTrue(b);
            testCase.verifyEqual(value, 5);
        end

        function testExistingSubfield(testCase)
            [b, value] = vlt.data.isfullfield(testCase.A, 'a.sub1');
            testCase.verifyTrue(b);
            testCase.verifyEqual(value, 1);
        end

        function testNonExistingField(testCase)
            [b, value] = vlt.data.isfullfield(testCase.A, 'c');
            testCase.verifyFalse(b);
            testCase.verifyEmpty(value);
        end

        function testNonExistingSubfield(testCase)
            [b, value] = vlt.data.isfullfield(testCase.A, 'a.sub3');
            testCase.verifyFalse(b);
            testCase.verifyEmpty(value);
        end
    end
end
