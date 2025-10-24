classdef test_tabstr2struct < matlab.unittest.TestCase
    % TEST_TABSTR2STRUCT - test the vlt.data.tabstr2struct function

    methods(Test)

        function test_basic_conversion(testCase)
            % Test basic conversion of a tab-separated string to a struct
            s = ['5' char(9) 'my string data'];
            fn = {'fielda', 'fieldb'};
            a = tabstr2struct(s, fn);

            expected_struct = struct('fielda', 5, 'fieldb', 'my string data');

            testCase.verifyEqual(a, expected_struct);
        end % test_basic_conversion

        function test_date_string(testCase)
            % Test that date-like strings are correctly handled as strings
            s = ['2023/10/26' char(9) '2023-10-26'];
            fn = {'date1', 'date2'};
            a = tabstr2struct(s, fn);

            expected_struct = struct('date1', '2023/10/26', 'date2', '2023-10-26');

            testCase.verifyEqual(a, expected_struct);
        end % test_date_string

        function test_non_numeric_object_string(testCase)
            % Test that strings corresponding to non-numeric objects are handled as strings
            s = ['struct' char(9) 'classdef'];
            fn = {'matlab_type1', 'matlab_type2'};
            a = tabstr2struct(s, fn);

            expected_struct = struct('matlab_type1', 'struct', 'matlab_type2', 'classdef');

            testCase.verifyEqual(a, expected_struct);
        end % test_non_numeric_object_string

        function test_empty_string(testCase)
            % Test handling of empty strings
            s = ['', char(9), ''];
            fn = {'empty1', 'empty2'};
            a = tabstr2struct(s, fn);

            testCase.verifyTrue(isempty(a.empty1));
            testCase.verifyTrue(isempty(a.empty2));
        end % test_empty_string

    end % methods(Test)

end % classdef
