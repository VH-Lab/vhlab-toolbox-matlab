classdef test_emptystruct < matlab.unittest.TestCase

    methods (Test)

        function test_emptystruct_string_args(testCase)
            s = vlt.data.emptystruct('a','b','c');
            testCase.verifyTrue(isstruct(s));
            testCase.verifyTrue(isempty(s));
            fields = fieldnames(s);
            testCase.verifyEqual(fields, {'a';'b';'c'});
        end

        function test_emptystruct_cell_arg(testCase)
            s = vlt.data.emptystruct({'a','b','c'});
            testCase.verifyTrue(isstruct(s));
            testCase.verifyTrue(isempty(s));
            fields = fieldnames(s);
            testCase.verifyEqual(fields, {'a';'b';'c'});
        end

    end

end
