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
            % Test basic double backslash removal
            p_in = 'C:\\Users\\Documents\\\\my_data\\';
            p_out = vlt.file.tidypathstring(p_in, '\\');
            testCase.verifyEqual(p_out, 'C:\\Users\\Documents\\my_data');

            % Test preservation of leading double backslash for network paths
            p_in_share = '\\\\server\\folder\\\\subfolder\\';
            p_out_share = vlt.file.tidypathstring(p_in_share, '\\');
            testCase.verifyEqual(p_out_share, '\\\\server\\folder\\subfolder');
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
            p_in = 'a:b::c:';
            p_out = vlt.file.tidypathstring(p_in, ':');
            testCase.verifyEqual(p_out, 'a:b:c');
        end

        function testTidyPath_defaultSeparator(testCase)
            % This test will behave differently on Unix vs. Windows,
            % but it verifies that the function runs with the default filesep.
            p_in = ['path' filesep filesep 'to' filesep 'data' filesep];
            p_expected = ['path' filesep 'to' filesep 'data'];
            p_out = vlt.file.tidypathstring(p_in);
            testCase.verifyEqual(p_out, p_expected);
        end
    end
end
