classdef testjsonencodenan < matlab.unittest.TestCase
    % TESTJSONENCODENAN - test the jsonencodenan function

    properties
    end

    methods (Test)
        function testEncodeRegularStruct(testCase)
            % Test encoding of a regular struct
            s = struct('a', 1, 'b', 'hello');
            json_str = jsonencodenan(s);
            % Use jsondecode to ensure it's valid JSON and matches
            s_decoded = jsondecode(json_str);
            testCase.verifyEqual(s_decoded.a, s.a);
            testCase.verifyEqual(s_decoded.b, s.b);
        end

        function testEncodeNaN(testCase)
            % Test encoding of a struct with NaN
            s = struct('value', NaN);
            json_str = jsonencodenan(s);
            expected_str = '{"value":NaN}';

            % Remove whitespace for comparison as output may be pretty-printed
            json_str(isspace(json_str)) = '';
            expected_str(isspace(expected_str)) = '';
            testCase.verifyEqual(json_str, expected_str);
        end

        function testEncodeInf(testCase)
            % Test encoding of a struct with Inf
            s = struct('value', Inf);
            json_str = jsonencodenan(s);
            expected_str = '{"value":Infinity}';

            % Remove whitespace for comparison
            json_str(isspace(json_str)) = '';
            expected_str(isspace(expected_str)) = '';
            testCase.verifyEqual(json_str, expected_str);
        end

        function testEncodeNegInf(testCase)
            % Test encoding of a struct with -Inf
            s = struct('value', -Inf);
            json_str = jsonencodenan(s);
            expected_str = '{"value":-Infinity}';

            % Remove whitespace for comparison
            json_str(isspace(json_str)) = '';
            expected_str(isspace(expected_str)) = '';
            testCase.verifyEqual(json_str, expected_str);
        end

        function testEncodeMixed(testCase)
            % Test encoding of a struct with mixed values
            s = struct('a', 1, 'b', NaN, 'c', Inf, 'd', 'text');
            json_str = jsonencodenan(s);

            % Remove whitespace before checking content
            json_str_no_space = json_str;
            json_str_no_space(isspace(json_str_no_space)) = '';

            % The order of fields in the JSON output is not guaranteed.
            % So we verify that the JSON string contains the expected key-value pairs
            testCase.verifyTrue(contains(json_str_no_space, '"a":1'));
            testCase.verifyTrue(contains(json_str_no_space, '"b":NaN'));
            testCase.verifyTrue(contains(json_str_no_space, '"c":Infinity'));
            testCase.verifyTrue(contains(json_str_no_space, '"d":"text"'));
        end
    end
end
