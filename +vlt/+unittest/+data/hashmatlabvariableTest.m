classdef hashmatlabvariableTest < matlab.unittest.TestCase
    methods (Test)
        function testMD5(testCase)
            A = randn(5,3,2);
            h1 = vlt.data.hashmatlabvariable(A);
            h2 = vlt.data.hashmatlabvariable(A);
            testCase.verifyEqual(h1, h2);

            B = randn(5,3,2);
            h3 = vlt.data.hashmatlabvariable(B);
            testCase.verifyNotEqual(h1, h3);
        end

        function testCRC(testCase)
            if exist('pm_hash') ~= 2,
                testCase.assumeFail('pm_hash not found, skipping CRC hash test.');
            end
            A = randn(5,3,2);
            h1_crc = vlt.data.hashmatlabvariable(A, 'algorithm', 'pm_hash/crc');
            h2_crc = vlt.data.hashmatlabvariable(A, 'algorithm', 'pm_hash/crc');
            testCase.verifyEqual(h1_crc, h2_crc);

            B = randn(5,3,2);
            h3_crc = vlt.data.hashmatlabvariable(B, 'algorithm', 'pm_hash/crc');
            testCase.verifyNotEqual(h1_crc, h3_crc);
        end
    end
end
