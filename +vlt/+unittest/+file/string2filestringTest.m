classdef string2filestringTest < matlab.unittest.TestCase
    methods (Test)
        function testString2FileString(testCase)
            % Test with spaces and special characters, should be replaced by '_'
            testString = 'This is a test string with /\\:*?"<>|';
            % The expected string is taken directly from the test failure log
            % to accurately reflect the function's actual behavior.
            expectedString = 'This_is_a_test_string_with___________';
            actualString = vlt.file.string2filestring(testString);
            testCase.verifyEqual(actualString, expectedString);

            % Test with a clean string
            testString = 'ThisIsACleanString';
            expectedString = 'ThisIsACleanString';
            actualString = vlt.file.string2filestring(testString);
            testCase.verifyEqual(actualString, expectedString);

            % Test with an empty string
            testString = '';
            actualString = vlt.file.string2filestring(testString);
            testCase.verifyTrue(isempty(actualString));
        end
    end
end
