classdef isbooleanTest < matlab.unittest.TestCase
    methods (Test)
        function testOnlyZerosAndOnes(testCase)
            testCase.verifyTrue(logical(vlt.data.isboolean([0 1 0 1])));
            testCase.verifyTrue(logical(vlt.data.isboolean([1 1 1])));
            testCase.verifyTrue(logical(vlt.data.isboolean(0)));
        end

        function testOtherNumbers(testCase)
            testCase.verifyFalse(logical(vlt.data.isboolean([0 1 2])));
            testCase.verifyFalse(logical(vlt.data.isboolean(-1)));
        end

        function testNonNumeric(testCase)
            testCase.verifyFalse(logical(vlt.data.isboolean('hello')));
            testCase.verifyFalse(logical(vlt.data.isboolean({0, 1})));
        end
    end
end
