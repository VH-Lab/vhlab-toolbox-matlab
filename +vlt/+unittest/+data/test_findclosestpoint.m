classdef test_findclosestpoint < matlab.unittest.TestCase
    % TEST_FINDCLOSESTPOINT - test the vlt.data.findclosestpoint function

    methods(Test)
        function test_simple_2d(testCase)
            pointlist = [1 1; 2 2; 3 3; 4 4; 5 5];
            point = [3.1 3.1];
            [i, pointc] = vlt.data.findclosestpoint(pointlist, point);
            testCase.verifyEqual(i, 3);
            testCase.verifyEqual(pointc, [3 3]);
        end

        function test_simple_3d(testCase)
            pointlist = [1 1 1; 2 2 2; 3 3 3];
            point = [1.1 1.1 1.1];
            [i, pointc] = vlt.data.findclosestpoint(pointlist, point);
            testCase.verifyEqual(i, 1);
            testCase.verifyEqual(pointc, [1 1 1]);
        end

        function test_empty_pointlist_0x0(testCase)
            pointlist = []; % 0x0
            point = [1 1];
            % This will error because repmat(point, 0, 1) is 0x2, but pointlist is 0x0.
            % Matrix dimensions must agree.
            testCase.verifyError(@() vlt.data.findclosestpoint(pointlist, point), 'MATLAB:dimagree');
        end

        function test_empty_pointlist_0xN(testCase)
            pointlist = zeros(0,2); % 0x2
            point = [1 1];
            [i, pointc] = vlt.data.findclosestpoint(pointlist, point);
            testCase.verifyEmpty(i);
            testCase.verifyEmpty(pointc);
            testCase.verifyEqual(size(pointc), [0 2]);
        end

        function test_exact_match(testCase)
            pointlist = [1 1; 5 5; 10 10];
            point = [5 5];
            [i, pointc] = vlt.data.findclosestpoint(pointlist, point);
            testCase.verifyEqual(i, 2);
            testCase.verifyEqual(pointc, [5 5]);
        end

        function test_equidistant(testCase)
            % Should return the first match
            pointlist = [1 1; 5 5];
            point = [3 3];
            [i, pointc] = vlt.data.findclosestpoint(pointlist, point);
            testCase.verifyEqual(i, 1);
            testCase.verifyEqual(pointc, [1 1]);
        end
    end
end
