classdef isbooleanTest < matlab.unittest.TestCase
    methods (Test)
        function testOnlyZerosAndOnes(testCase)
            testCase.verifyTrue(vlt.data.isboolean([0 1 0 1]));
            testCase.verifyTrue(vlt.data.isboolean([1 1 1]));
            testCase.verifyTrue(vlt.data.isboolean(0));
        end

        function testOtherNumbers(testCase)
            testCase.verifyFalse(vlt.data.isboolean([0 1 2]));
            testCase.verifyFalse(vlt.data.isboolean(-1));
        end

        function testNonNumeric(testCase)
            testCase.verifyFalse(vlt.data.isboolean('hello'));
            testCase.verifyFalse(vlt.data.isboolean({0, 1}));
        end
    end
end
