classdef isurlTest < matlab.unittest.TestCase
    methods (Test)
        function testIsUrl(testCase)
            % Test cases that should return true
            testCase.verifyTrue(logical(vlt.file.isurl('http://www.example.com')), 'Standard HTTP URL');
            testCase.verifyTrue(logical(vlt.file.isurl('https://www.example.com')), 'Secure HTTPS URL');
            testCase.verifyTrue(logical(vlt.file.isurl('ftp://ftp.example.com')), 'FTP URL');
            testCase.verifyTrue(logical(vlt.file.isurl('file:///path/to/file')), 'Local file URL');
            testCase.verifyTrue(logical(vlt.file.isurl('custom-protocol://resource')), 'Custom protocol URL');

            % Test cases that should return false
            testCase.verifyFalse(logical(vlt.file.isurl('www.example.com')), 'Missing protocol');
            testCase.verifyFalse(logical(vlt.file.isurl('example.com')), 'Domain name only');
            testCase.verifyFalse(logical(vlt.file.isurl('http:/www.example.com')), 'Single slash in protocol');
            testCase.verifyFalse(logical(vlt.file.isurl('http//www.example.com')), 'Missing colon in protocol');
            testCase.verifyFalse(logical(vlt.file.isurl('C:\path\to\file')), 'Windows file path');
            testCase.verifyFalse(logical(vlt.file.isurl('/path/to/file')), 'Unix file path');
            testCase.verifyFalse(logical(vlt.file.isurl('')), 'Empty string');
        end
    end
end
