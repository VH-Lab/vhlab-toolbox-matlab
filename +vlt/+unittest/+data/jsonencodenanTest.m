classdef jsonencodenanTest < matlab.unittest.TestCase
    methods (Test)
        function testEncodingNaNAndInf(testCase)
            my_struct.a = [1 2 NaN Inf -Inf];
            json_str = vlt.data.jsonencodenan(my_struct);

            testCase.verifyTrue(contains(json_str, '"a"'));
            testCase.verifyTrue(contains(json_str, 'NaN'));
            testCase.verifyTrue(contains(json_str, 'Infinity'));
            testCase.verifyTrue(contains(json_str, '-Infinity'));
        end
    end
end
