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
            % Expected output: '{"value":NaN}'
            testCase.verifyEqual(json_str, '{"value":NaN}');
        end

        function testEncodeInf(testCase)
            % Test encoding of a struct with Inf
            s = struct('value', Inf);
            json_str = jsonencodenan(s);
            % Expected output: '{"value":Inf}'
            testCase.verifyEqual(json_str, '{"value":Inf}');
        end

        function testEncodeNegInf(testCase)
            % Test encoding of a struct with -Inf
            s = struct('value', -Inf);
            json_str = jsonencodenan(s);
            % Expected output: '{"value":-Inf}'
            testCase.verifyEqual(json_str, '{"value":-Inf}');
        end

        function testEncodeMixed(testCase)
            % Test encoding of a struct with mixed values
            s = struct('a', 1, 'b', NaN, 'c', Inf, 'd', 'text');
            json_str = jsonencodenan(s);

            % The order of fields in the JSON output is not guaranteed.
            % So we verify that the JSON string contains the expected key-value pairs
            testCase.verifyTrue(contains(json_str, '"a":1'));
            testCase.verifyTrue(contains(json_str, '"b":NaN'));
            testCase.verifyTrue(contains(json_str, '"c":Inf'));
            testCase.verifyTrue(contains(json_str, '"d":"text"'));
        end
    end
end
