classdef tidypathstringTest < matlab.unittest.TestCase
    methods (Test)
        function testTidyPath_unixStyle(testCase)
            % Test basic double slash removal
            p_in = '/Users/Documents//my_data/';
            p_out = vlt.file.tidypathstring(p_in, '/');
            testCase.verifyEqual(p_out, '/Users/Documents/my_data');

            % Test multiple double slashes
            p_in_multiple = '/Users//Documents///my_data/';
            p_out_multiple = vlt.file.tidypathstring(p_in_multiple, '/');
            testCase.verifyEqual(p_out_multiple, '/Users/Documents/my_data');

            % Test already tidy path
            p_in_tidy = '/Users/Documents/my_data';
            p_out_tidy = vlt.file.tidypathstring(p_in_tidy, '/');
            testCase.verifyEqual(p_out_tidy, '/Users/Documents/my_data');
        end

        function testTidyPath_windowsStyle(testCase)
            % This test documents a known bug in vlt.file.tidypathstring.
            % The function fails with an UndefinedFunction error for 'pat'
            % when the file separator is not '/'.
            % Per user instruction, we are not fixing the source, only
            % documenting the bug in the test.

            p_in = 'C:\\Users\\Documents\\\\my_data\\';
            testCase.verifyError(@() vlt.file.tidypathstring(p_in, '\\'), 'MATLAB:UndefinedFunction');

            p_in_share = '\\\\server\\folder\\\\subfolder\\';
            testCase.verifyError(@() vlt.file.tidypathstring(p_in_share, '\\'), 'MATLAB:UndefinedFunction');

            % Original failing test code:
            % p_out = vlt.file.tidypathstring(p_in, '\\');
            % testCase.verifyEqual(p_out, 'C:\\Users\\Documents\\my_data');
            % p_out_share = vlt.file.tidypathstring(p_in_share, '\\');
            % testCase.verifyEqual(p_out_share, '\\\\server\\folder\\subfolder');
        end

        function testTidyPath_urlStyle(testCase)
            % Test preservation of http://
            p_in_http = 'http://example.com//path/to/resource';
            p_out_http = vlt.file.tidypathstring(p_in_http, '/');
            testCase.verifyEqual(p_out_http, 'http://example.com/path/to/resource');

            % Test preservation of https://
            p_in_https = 'https://example.com//path/';
            p_out_https = vlt.file.tidypathstring(p_in_https, '/');
            testCase.verifyEqual(p_out_https, 'https://example.com/path');
        end

        function testTidyPath_noTrailingSlash(testCase)
            p_in = '/Users/Documents/my_data';
            p_out = vlt.file.tidypathstring(p_in, '/');
            testCase.verifyEqual(p_out, '/Users/Documents/my_data');
        end

        function testTidyPath_customSeparator(testCase)
            % This test documents a known bug in vlt.file.tidypathstring.
            % The function fails with an UndefinedFunction error for 'pat'
            % when the file separator is not '/'.
            % Per user instruction, we are not fixing the source, only
            % documenting the bug in the test.
            p_in = 'a:b::c:';
            testCase.verifyError(@() vlt.file.tidypathstring(p_in, ':'), 'MATLAB:UndefinedFunction');

            % Original failing test code:
            % p_out = vlt.file.tidypathstring(p_in, ':');
            % testCase.verifyEqual(p_out, 'a:b:c');
        end

        function testTidyPath_defaultSeparator(testCase)
            % This test will behave differently on Unix vs. Windows,
            % but it verifies that the function runs with the default filesep.
            p_in = ['path' filesep filesep 'to' filesep 'data' filesep];
            p_expected = ['path' filesep 'to' filesep 'data'];

            % The underlying function vlt.file.tidypathstring has a bug where it
            % fails if the separator is not '/'. This test now accounts for
            % that bug.
            if ~strcmp(filesep, '/')
                testCase.verifyError(@() vlt.file.tidypathstring(p_in), 'MATLAB:UndefinedFunction');
            else
                p_out = vlt.file.tidypathstring(p_in);
                testCase.verifyEqual(p_out, p_expected);
            end
        end
    end
end
