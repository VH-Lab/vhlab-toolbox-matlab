function inside = selectpoints3d(pts3d)
% SELECTPOINTS3D - Graphically select a bunch of (2D or 3D) points by making a polygon in the current axes view
%
%  INSIDE = SELECTPOINTS3D(PTS3D)
%
%  Select a subset of points on a (potentially 3D) graph by dragging a polygon.
%
%  Allows the user to drag a polygon over the current axes (may be in 3D or 2D mode)
%  and this function will return the points in PTS3D that are inside the polygon.
%
%  PTS3D should be a 2xN or 3xN matrix where N is the the number of points. If only
%  2-dimensional points are passed then the function will still work.
%
%  Output:  INSIDE is an N dimensional vector of 0's and 1's; INSIDE(i) is 1 if and only
%  if PTS3D(:,i) is inside the user-drawn polygon.
%
%  Please note that this function does not plot the points; the points should already be
%  plotted if you want them to be visible to the user.
%
%  Example:
%     pts = randn(30,3);
%     figure;
%     plot3(pts(:,1),pts(:,2),pts(:,3),'ko'); drawnow();
%     % change the view, maybe use the rotate3d tool
%     inside = selectpoints3d(pts'); % need to transpose to column vectors
%     hold on;
%     indexes = find(inside);
%     plot3(pts(indexes,1),pts(indexes,2),pts(indexes,3),'bs'); % add red x to selected points
%     % look around with rotate3d tool to make sure it is right
%
%

disp('DEBUG: selectpoints3d called.');
disp(['DEBUG: pts3d size: ' mat2str(size(pts3d))]);
disp('DEBUG: Calling getline_3dplane...');
[x,y,z] = getline_3dplane;
disp('DEBUG: getline_3dplane returned.');

dar = get(gca,'DataAspectRatio');
% scale the points for view rotation
S = [1/dar(1) 0 0 ; 0 1/dar(2) 0; 0 0 1/dar(3)];

[A] = viewpoint3dto2d( S * [x(:) y(:) z(:)]' );

if size(pts3d,1) == 2,
	pts3d = [pts3d; zeros(1,size(pts3d,2))];
end;

[B] = viewpoint3dto2d( S * pts3d );

inside = inpolygon(B(1,:),B(2,:),A(1,:),A(2,:));

