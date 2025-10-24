classdef test_text2struct < matlab.unittest.TestCase
    % TEST_TEXT2STRUCT - test the text2struct function

    methods(Test)

        function test_simple_struct_conversion(testCase)
            % Test conversion of a simple multi-line string to a struct
            eol = sprintf('\n');
            str = ['name: MyStruct' eol ...
                   'value1: 10' eol ...
                   'value2: another string'];

            s = text2struct(str);

            expected_struct = struct('name', 'MyStruct', 'value1', 10, 'value2', 'another string');

            testCase.verifyEqual(s, expected_struct);
        end % test_simple_struct_conversion

        function test_nested_struct(testCase)
            % Test conversion of a string with a nested struct
            eol = sprintf('\n');
            str = ['type: main_struct' eol ...
                   'data: <' eol ...
                   '  val: 5.5' eol ...
                   '  name: sub' eol ...
                   '>'];

            s = text2struct(str);

            expected_sub_struct = struct('val', 5.5, 'name', 'sub');
            expected_struct = struct('type', 'main_struct', 'data', expected_sub_struct);

            testCase.verifyEqual(s, expected_struct);
        end % test_nested_struct

        function test_multiple_structs(testCase)
            % Test conversion of a string with multiple structs separated by a blank line
            eol = sprintf('\n');
            str = ['name: struct1' eol ...
                   'val: 1' eol ...
                   eol ...
                   'name: struct2' eol ...
                   'val: 2'];

            s = text2struct(str);

            expected_struct1 = struct('name', 'struct1', 'val', 1);
            expected_struct2 = struct('name', 'struct2', 'val', 2);
            expected_cell = {expected_struct1, expected_struct2};

            testCase.verifyEqual(s, expected_cell);
        end % test_multiple_structs

        function test_bad_field_name(testCase)
            % Test that an invalid field name is ignored by default
            eol = sprintf('\n');
            str = ['valid_name: a' eol ...
                   '1invalid: b'];

            s = text2struct(str);

            expected_struct = struct('valid_name', 'a');

            testCase.verifyEqual(s, expected_struct);
        end % test_bad_field_name

    end % methods(Test)

end % classdef
