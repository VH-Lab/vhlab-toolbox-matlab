classdef test_viewpoint3dto2d < matlab.unittest.TestCase
    methods(Test)
        function test_viewpoint3dto2d_projection(testCase)
            % Test that viewpoint3dto2d correctly projects a 3d point

            pts3d = [1; 2; 3]; % A single 3D point

            % A simple camera matrix that just drops the Z coordinate
            cameramatrix = [1 0 0 0; 0 1 0 0; 0 0 0 1; 0 0 1 0];

            expected_pts2d = [1; 2];

            actual_pts2d = viewpoint3dto2d(pts3d, cameramatrix);

            testCase.verifyEqual(actual_pts2d, expected_pts2d, 'AbsTol', 1e-9);
        end
    end
end
