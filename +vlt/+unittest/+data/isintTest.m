classdef isintTest < matlab.unittest.TestCase
    methods (Test)
        function testIntegers(testCase)
            testCase.verifyTrue(vlt.data.isint([1 2 3]));
            testCase.verifyTrue(vlt.data.isint(0));
            testCase.verifyTrue(vlt.data.isint(-5));
        end

        function testNonIntegers(testCase)
            testCase.verifyFalse(vlt.data.isint([1 2.5 3]));
            testCase.verifyFalse(vlt.data.isint(pi));
        end

        function testComplex(testCase)
            testCase.verifyFalse(vlt.data.isint(1+1i));
        end

        function testNonNumeric(testCase)
            testCase.verifyFalse(vlt.data.isint('hello'));
        end
    end
end
