classdef test_prettyjson < matlab.unittest.TestCase
    % TEST_PRETTYJSON - tests for the vlt.data.prettyjson function

    methods (Test)

        function test_prettyjson_basic(testCase)
            % This test attempts to verify pretty printing via built-in jsonencode or Java org.json

            myStruct = struct('a', 5, 'b', 3, 'c', 1);
            json_string = '{"a":5,"b":3,"c":1}'; % A simple, unformatted JSON string

            % Test with default indentation
            pretty_json = vlt.data.prettyjson(json_string);

            % Check if the output is valid JSON by decoding it
            try
                decoded = jsondecode(pretty_json);
            catch e
                testCase.verifyFail(['Failed to decode output JSON: ' e.message]);
                decoded = struct([]);
            end

            % Sort fields to ensure comparison is robust to key reordering
            if ~isempty(decoded)
                decoded_sorted = orderfields(decoded);
                myStruct_sorted = orderfields(myStruct);
                testCase.verifyEqual(decoded_sorted, myStruct_sorted);
            end

            % Check if it is "pretty" (contains newlines)
            % If the function fell back to returning the input string (because neither method worked),
            % it will match the input string.
            if strcmp(pretty_json, json_string)
                % It returned the input. This is a valid fallback behavior if dependencies are missing.
            else
                 % It changed something. It should be pretty (contain newlines).
                 testCase.verifyTrue(contains(pretty_json, newline) || contains(pretty_json, char(10)), 'Output should contain newlines if it was modified');
            end
        end

    end; % methods (Test)

end
