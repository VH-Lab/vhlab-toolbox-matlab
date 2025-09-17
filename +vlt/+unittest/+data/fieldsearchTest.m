classdef fieldsearchTest < matlab.unittest.TestCase
    properties
        A = struct('a', 'string_test', 'b', [1 2 3], 'c', struct('d', 5));
    end

    methods (Test)
        function testContainsString(testCase)
            search = struct('field','a','operation','contains_string','param1','test','param2','');
            testCase.verifyTrue(vlt.data.fieldsearch(testCase.A, search));
        end

        function testGreaterThanOrEqual(testCase)
            search = struct('field','b','operation','greaterthaneq','param1',1,'param2','');
            testCase.verifyTrue(vlt.data.fieldsearch(testCase.A, search));
        end

        function testHasField(testCase)
            search = struct('field','b','operation','hasfield','param1','','param2','');
            testCase.verifyTrue(vlt.data.fieldsearch(testCase.A, search));
        end

        function testHasAnySubfieldExactString(testCase)
            B = struct('values',testCase.A);
            search = struct('field','values','operation','hasanysubfield_exact_string','param1','a','param2','string_test');
            testCase.verifyTrue(vlt.data.fieldsearch(B, search));
        end

        function testOr(testCase)
            search = struct('field','','operation','or', ...
                'param1', struct('field','b','operation','hasfield','param1','','param2',''), ...
                'param2', struct('field','c','operation','hasfield','param1','','param2','') );
            testCase.verifyTrue(vlt.data.fieldsearch(testCase.A, search));
        end

        function testNegation(testCase)
            search = struct('field','a','operation','~contains_string','param1','not_present','param2','');
            testCase.verifyTrue(vlt.data.fieldsearch(testCase.A, search));
        end
    end
end
