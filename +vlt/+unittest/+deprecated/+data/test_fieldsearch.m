classdef test_fieldsearch < matlab.unittest.TestCase
    properties
        test_struct
    end

    methods (TestMethodSetup)
        function create_test_struct(testCase)
            testCase.test_struct = struct('a', 'string_test', 'b', [1 2 3], 'c', struct('d', 5));
            sub_struct1 = struct('myfield','value1');
            sub_struct2 = struct('myfield','value2');
            testCase.test_struct.sub = [sub_struct1 sub_struct2];
        end
    end

    methods (Test)
        function test_regexp(testCase)
            searchstruct = struct('field', 'a', 'operation', 'regexp', 'param1', 'string_.*', 'param2', '');
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyTrue(logical(result));

            searchstruct.param1 = 'no_match';
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyFalse(logical(result));
        end

        function test_exact_string(testCase)
            searchstruct = struct('field', 'a', 'operation', 'exact_string', 'param1', 'string_test', 'param2', '');
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyTrue(logical(result));

            searchstruct.param1 = 'string_test_wrong';
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyFalse(logical(result));
        end

        function test_contains_string(testCase)
            searchstruct = struct('field', 'a', 'operation', 'contains_string', 'param1', 'test', 'param2', '');
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyTrue(logical(result));

            searchstruct.param1 = 'nomatch';
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyFalse(logical(result));
        end

        function test_exact_number(testCase)
            searchstruct = struct('field', 'b', 'operation', 'exact_number', 'param1', [1 2 3], 'param2', '');
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyTrue(logical(result));

            searchstruct.param1 = [1 2 4];
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyFalse(logical(result));
        end

        function test_lessthan(testCase)
            searchstruct = struct('field', 'b', 'operation', 'lessthan', 'param1', [2 3 4], 'param2', '');
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyTrue(logical(result));

            searchstruct.param1 = [1 2 3];
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyFalse(logical(result));
        end

        function test_lessthaneq(testCase)
            searchstruct = struct('field', 'b', 'operation', 'lessthaneq', 'param1', [1 2 3], 'param2', '');
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyTrue(logical(result));

            searchstruct.param1 = [0 1 2];
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyFalse(logical(result));
        end

        function test_greaterthan(testCase)
            searchstruct = struct('field', 'b', 'operation', 'greaterthan', 'param1', [0 1 2], 'param2', '');
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyTrue(logical(result));

            searchstruct.param1 = [1 2 3];
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyFalse(logical(result));
        end

        function test_greaterthaneq(testCase)
            searchstruct = struct('field', 'b', 'operation', 'greaterthaneq', 'param1', [1 2 3], 'param2', '');
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyTrue(logical(result));

            searchstruct.param1 = [2 3 4];
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyFalse(logical(result));
        end

        function test_hasfield(testCase)
            searchstruct = struct('field', 'a', 'operation', 'hasfield', 'param1', '', 'param2', '');
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyTrue(logical(result));

            searchstruct.field = 'nonexistent';
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyFalse(logical(result));
        end

        function test_hasanysubfield_contains_string(testCase)
            searchstruct = struct('field', 'sub', 'operation', 'hasanysubfield_contains_string', 'param1', 'myfield', 'param2', 'value1');
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyTrue(logical(result));

            searchstruct.param2 = 'nomatch';
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyFalse(logical(result));
        end

        function test_hasanysubfield_exact_string(testCase)
            searchstruct = struct('field', 'sub', 'operation', 'hasanysubfield_exact_string', 'param1', 'myfield', 'param2', 'value2');
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyTrue(logical(result));

            searchstruct.param2 = 'value';
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyFalse(logical(result));
        end

        function test_or(testCase)
            search1 = struct('field', 'a', 'operation', 'exact_string', 'param1', 'string_test', 'param2', '');
            search2 = struct('field', 'b', 'operation', 'exact_number', 'param1', [0 0 0], 'param2', ''); % this is false
            searchstruct = struct('field', '', 'operation', 'or', 'param1', search1, 'param2', search2);
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyTrue(logical(result));

            search1.param1 = 'wrong';
            searchstruct = struct('field', '', 'operation', 'or', 'param1', search1, 'param2', search2);
            result = fieldsearch(testCase.test_struct, searchstruct);
            testCase.verifyFalse(logical(result));
        end

        function test_and_multiple_structs(testCase)
             search1 = struct('field', 'a', 'operation', 'exact_string', 'param1', 'string_test', 'param2', '');
             search2 = struct('field', 'b', 'operation', 'exact_number', 'param1', [1 2 3], 'param2', '');
             searchstruct = [search1 search2];
             result = fieldsearch(testCase.test_struct, searchstruct);
             testCase.verifyTrue(logical(result));

             search2.param1 = [0 0 0];
             searchstruct = [search1 search2];
             result = fieldsearch(testCase.test_struct, searchstruct);
             testCase.verifyFalse(logical(result));
        end
    end
end
