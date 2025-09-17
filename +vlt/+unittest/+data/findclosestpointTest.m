classdef findclosestpointTest < matlab.unittest.TestCase
    methods (Test)
        function testSimple(testCase)
            pointlist = [1 1; 5 5; 10 10];
            point = [6 6];
            [i, pointc] = vlt.data.findclosestpoint(pointlist, point);
            testCase.verifyEqual(i, 2);
            testCase.verifyEqual(pointc, [5 5]);
        end

        function testExactMatch(testCase)
            pointlist = [1 1; 5 5; 10 10];
            point = [10 10];
            [i, pointc] = vlt.data.findclosestpoint(pointlist, point);
            testCase.verifyEqual(i, 3);
            testCase.verifyEqual(pointc, [10 10]);
        end

        function test3D(testCase)
            pointlist = [1 1 1; 5 5 5; 10 10 10];
            point = [6 6 6];
            [i, pointc] = vlt.data.findclosestpoint(pointlist, point);
            testCase.verifyEqual(i, 2);
            testCase.verifyEqual(pointc, [5 5 5]);
        end
    end
end
