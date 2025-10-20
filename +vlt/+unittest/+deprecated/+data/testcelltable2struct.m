classdef testcelltable2struct < matlab.unittest.TestCase
    methods (Test)
        function test_simple_conversion(testCase)
            c = { {'col1', 'col2', 'col3'}, ...
                  {1, 'a', true}, ...
                  {2, 'b', false} };
            s = celltable2struct(c);
            expected = struct('col1', {1; 2}, 'col2', {'a'; 'b'}, 'col3', {true; false});
            testCase.verifyEqual(s, expected);
        end

        function test_invalid_field_names(testCase)
            c = { {'1col', 'col 2', 'col-3'}, ...
                  {1, 'a', true} };
            s = celltable2struct(c);
            expected = struct('x1col', {1}, 'col_2', {'a'}, 'col_3', {true});
            testCase.verifyEqual(s, expected);
        end

        function test_truncated_rows(testCase)
            c = { {'col1', 'col2', 'col3'}, ...
                  {1, 'a'}, ...
                  {2} };
            s = celltable2struct(c);
            expected = struct('col1', {1; 2}, 'col2', {'a'; []}, 'col3', {[]; []});
            testCase.verifyEqual(s, expected);
        end
    end
end
