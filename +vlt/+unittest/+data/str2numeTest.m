classdef str2numeTest < matlab.unittest.TestCase
    methods (Test)
        function testValidNumberString(testCase)
            testCase.verifyEqual(vlt.data.str2nume('123'), 123);
        end

        function testEmptyString(testCase)
            testCase.verifyEmpty(vlt.data.str2nume(''));
        end

        function testNonNumericString(testCase)
            testCase.verifyEmpty(vlt.data.str2nume('abc'));
        end
    end
end
