classdef test_string2cell < matlab.unittest.TestCase
    methods (Test)
        function test_string2cell_comma_separated(testCase)
            s = 'a,b,c';
            c = {'a','b','c'};
            testCase.verifyEqual(vlt.data.string2cell(s, ','), c);
        end

        function test_string2cell_space_separated(testCase)
            s = 'a b c';
            c = {'a','b','c'};
            testCase.verifyEqual(vlt.data.string2cell(s, ' '), c);
        end

        function test_string2cell_with_whitespace(testCase)
            s = 'a , b,c ';
            c = {'a','b','c'};
            testCase.verifyEqual(vlt.data.string2cell(s, ','), c);
        end

        function test_string2cell_no_trim_whitespace(testCase)
            s = 'a , b,c ';
            c = {'a ',' b','c '};
            testCase.verifyEqual(vlt.data.string2cell(s, ',', 'TRIMWS', 0), c);
        end

        function test_string2cell_empty_string(testCase)
            s = '';
            c = {''};
            testCase.verifyEqual(vlt.data.string2cell(s, ','), c);
        end

        function test_string2cell_trailing_separator(testCase)
            s = 'a,b,';
            c = {'a','b',''};
            testCase.verifyEqual(vlt.data.string2cell(s, ','), c);
        end
    end
end
