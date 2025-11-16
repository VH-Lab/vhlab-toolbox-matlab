classdef string2filestringTest < matlab.unittest.TestCase
    methods (Test)
        function testString2FileString(testCase)
            % Test with spaces and special characters, should be replaced by '_'
            testString = 'This is a test string with /\\:*?"<>|';
            expectedString = 'This_is_a_test_string_with_________';
            actualString = string2filestring(testString);
            testCase.verifyEqual(actualString, expectedString);

            % Test with a clean string
            testString = 'ThisIsACleanString';
            expectedString = 'ThisIsACleanString';
            actualString = string2filestring(testString);
            testCase.verifyEqual(actualString, expectedString);

            % Test with an empty string
            testString = '';
            actualString = string2filestring(testString);
            testCase.verifyTrue(isempty(actualString));
        end
    end
end
