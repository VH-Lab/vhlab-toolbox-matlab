classdef string2filestringTest < matlab.unittest.TestCase
    methods (Test)
        function testString2FileString(testCase)
            % Test with spaces and special characters
            testString = 'This is a test string with /\\:*?"<>|';
            expectedString = 'Thisisateststringwith';
            actualString = vlt.file.string2filestring(testString);
            testCase.verifyEqual(actualString, expectedString);

            % Test with a clean string
            testString = 'ThisIsACleanString';
            expectedString = 'ThisIsACleanString';
            actualString = vlt.file.string2filestring(testString);
            testCase.verifyEqual(actualString, expectedString);

            % Test with an empty string
            testString = '';
            expectedString = '';
            actualString = vlt.file.string2filestring(testString);
            testCase.verifyEqual(actualString, expectedString);
        end
    end
end
