classdef prettyjsonTest < matlab.unittest.TestCase
    methods (Test)
        function testPretty(testCase)
            try
                import org.json.JSONObject;
            catch
                testCase.assumeFail('org.json.JSONObject not found, skipping test.');
            end

            mystruct = struct('a', 5, 'b', 3, 'c', 1);
            j = vlt.data.jsonencodenan(mystruct);
            j_pretty = vlt.data.prettyjson(j);

            testCase.verifyTrue(contains(char(j_pretty), sprintf('\n')));
            testCase.verifyTrue(contains(char(j_pretty), '"a"'));
            testCase.verifyTrue(contains(char(j_pretty), '"b"'));
            testCase.verifyTrue(contains(char(j_pretty), '"c"'));
        end
    end
end
