classdef flattenstructTest < matlab.unittest.TestCase
    methods (Test)
        function testSimpleStruct(testCase)
            A = struct('AA', struct('AAA', 5, 'AAB', 7), 'AB', 2);
            SF = vlt.data.flattenstruct(A, 'A__');
            testCase.verifyTrue(isfield(SF, 'A__AA__AAA'));
            testCase.verifyTrue(isfield(SF, 'A__AA__AAB'));
            testCase.verifyTrue(isfield(SF, 'A__AB'));
            testCase.verifyEqual(SF.A__AA__AAA, 5);
            testCase.verifyEqual(SF.A__AA__AAB, 7);
            testCase.verifyEqual(SF.A__AB, 2);
        end

        function testStructArray(testCase)
            A(1).a = 1;
            A(1).b = struct('c',2);
            A(2).a = 3;
            A(2).b = struct('c',4);
            SF = vlt.data.flattenstruct(A);
            testCase.verifyTrue(isfield(SF, 'a'));
            testCase.verifyTrue(isfield(SF, 'b__c'));
            testCase.verifyEqual([SF.a], [1 3]);
            testCase.verifyEqual([SF.b__c], [2 4]);
        end
    end
end
