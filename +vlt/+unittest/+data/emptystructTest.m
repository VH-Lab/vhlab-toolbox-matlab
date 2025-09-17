classdef emptystructTest < matlab.unittest.TestCase
    methods (Test)
        function testEmptyStructFromArgs(testCase)
            s = vlt.data.emptystruct('field1', 'field2');
            testCase.verifyTrue(isstruct(s));
            testCase.verifyEmpty(s);
            testCase.verifyEqual(fieldnames(s), {'field1'; 'field2'});
        end

        function testEmptyStructFromCell(testCase)
            s = vlt.data.emptystruct({'field1', 'field2'});
            testCase.verifyTrue(isstruct(s));
            testCase.verifyEmpty(s);
            testCase.verifyEqual(fieldnames(s), {'field1'; 'field2'});
        end
    end
end
