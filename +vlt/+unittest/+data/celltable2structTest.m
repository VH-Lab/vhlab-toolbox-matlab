classdef celltable2structTest < matlab.unittest.TestCase
    methods (Test)
        function testSimple(testCase)
            C = { {'header1', 'header2'}, {'data1', 10}, {'data2', 20} };
            S = vlt.data.celltable2struct(C);
            testCase.verifyEqual(length(S), 2);
            testCase.verifyEqual(S(1).header1, 'data1');
            testCase.verifyEqual(S(1).header2, 10);
            testCase.verifyEqual(S(2).header1, 'data2');
            testCase.verifyEqual(S(2).header2, 20);
        end

        function testTruncated(testCase)
            C = { {'h1', 'h2', 'h3'}, {'d1', 1}, {'d2'} };
            S = vlt.data.celltable2struct(C);
            testCase.verifyEqual(length(S), 2);
            testCase.verifyEqual(S(1).h1, 'd1');
            testCase.verifyEqual(S(1).h2, 1);
            testCase.verifyEmpty(S(1).h3);
            testCase.verifyEqual(S(2).h1, 'd2');
            testCase.verifyEmpty(S(2).h2);
            testCase.verifyEmpty(S(2).h3);
        end
    end
end
