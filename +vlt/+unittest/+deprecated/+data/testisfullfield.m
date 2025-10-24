classdef testisfullfield < matlab.unittest.TestCase
    % testisfullfield - tests for isfullfield (deprecated)
    %
    %

    properties
        test_struct
    end

    methods (TestMethodSetup)
        function create_test_struct(testCase)
            testCase.test_struct = struct('a',struct('sub1',1,'sub2',2),'b',5);
        end
    end

    methods (Test)

        function test_isfullfield_toplevel_exists(testCase)
            [b, value] = isfullfield(testCase.test_struct, 'b');
            testCase.verifyTrue(logical(b));
            testCase.verifyEqual(value, 5);
        end

        function test_isfullfield_nested_exists(testCase)
            [b, value] = isfullfield(testCase.test_struct, 'a.sub1');
            testCase.verifyTrue(logical(b));
            testCase.verifyEqual(value, 1);
        end

        function test_isfullfield_does_not_exist(testCase)
            [b, value] = isfullfield(testCase.test_struct, 'a.sub3');
            testCase.verifyFalse(logical(b));
            testCase.verifyEmpty(value);
        end

        function test_isfullfield_not_a_struct(testCase)
            [b, value] = isfullfield(5, 'a.sub3');
            testCase.verifyFalse(logical(b));
            testCase.verifyEmpty(value);
        end

    end
end
