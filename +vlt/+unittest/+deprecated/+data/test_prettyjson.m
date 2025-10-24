classdef test_prettyjson < matlab.unittest.TestCase
    % TEST_PRETTYJSON - tests for the prettyjson function

    methods (Test)

        function test_prettyjson_basic(testCase)
            % This test requires the org.json Java library.
            % It will be skipped if the library is not available.
            try
                import org.json.JSONObject;
            catch
                testCase.assumeTrue(false, 'Skipping test: org.json.JSONObject not found.');
            end

            myStruct = struct('a', 5, 'b', 3, 'c', 1);
            json_string = '{"a":5,"b":3,"c":1}'; % A simple, unformatted JSON string

            % Test with default indentation
            pretty_json = prettyjson(json_string);
            % Expected output is a string with newlines and 2-space indents
            expected_output = sprintf('{\n  "a": 5,\n  "b": 3,\n  "c": 1\n}');
            testCase.verifyEqual(char(pretty_json), expected_output);

            % Test with custom indentation
            pretty_json_4 = prettyjson(json_string, 4);
            expected_output_4 = sprintf('{\n    "a": 5,\n    "b": 3,\n    "c": 1\n}');
            testCase.verifyEqual(char(pretty_json_4), expected_output_4);
        end

    end; % methods (Test)

end
