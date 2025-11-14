classdef filesepconversionTest < matlab.unittest.TestCase

    methods(Test)

        function test_forward_to_backward(testCase)
            in_str = 'path/to/my/file.txt';
            orig_sep = '/';
            new_sep = '\';
            expected_str = 'path\to\my\file.txt';

            out_str = filesepconversion(in_str, orig_sep, new_sep);

            testCase.verifyEqual(out_str, expected_str);
        end

        function test_backward_to_forward(testCase)
            in_str = 'path\to\my\file.txt';
            orig_sep = '\';
            new_sep = '/';
            expected_str = 'path/to/my/file.txt';

            out_str = filesepconversion(in_str, orig_sep, new_sep);

            testCase.verifyEqual(out_str, expected_str);
        end

        function test_no_conversion(testCase)
            in_str = 'path/to/my/file.txt';
            orig_sep = '\';
            new_sep = '/';

            out_str = filesepconversion(in_str, orig_sep, new_sep);

            testCase.verifyEqual(out_str, in_str);
        end

        function test_empty_string(testCase)
            in_str = '';
            orig_sep = '/';
            new_sep = '\';

            out_str = filesepconversion(in_str, orig_sep, new_sep);

            testCase.verifyEqual(out_str, '');
        end

        function test_sep_at_ends(testCase)
            in_str = '/path/to/file/';
            orig_sep = '/';
            new_sep = '\';
            expected_str = '\path\to\file\';

            out_str = filesepconversion(in_str, orig_sep, new_sep);

            testCase.verifyEqual(out_str, expected_str);
        end

    end
end
