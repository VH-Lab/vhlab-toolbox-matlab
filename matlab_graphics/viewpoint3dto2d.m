function pts2d = viewpoint3dto2d(pts3d, cameramatrix)
% VIEWPOINT3DTO2D Project a 3D point onto 2D with a given camera matrix
%
%  PTS2D = VIEWPOINT3DTO2D(PTS3D, CAMERAMATRIX)
%
%  Converts a list of 3D points PTS3D into their corresponding
%  2D projection for the camera matrix CAMERAMATRIX.  The matrix PTS3D should be
%  a list of column vectors (3xN, where N is the number of points). CAMERAMATRIX
%  is a standard camera matrix (see Wikipedia for "camera matrix").
%
%  Output: PTS2D is a list of column vectors (2xN) that correspond to the 
%  2D projection.  There is an arbitrary scale factor that depends upon how
%  you want to display the points; you can scale these points with a multiplicative
%  factor and the relative relationships will still be preserved.
%  
%  One can also call:
%
%  PTS2D = VIEWPOINT3DTO2D(PTS3D)
%
%  which takes the CAMERAMATRIX to be the current VIEW in the current axes.
%
%
%  See also: VIEW

if nargin<2,
	cameramatrix = view;
end;

pts2d = cameramatrix * [ pts3d ; ones(1,size(pts3d,2)) ];

pts2d = pts2d(1:2,:);  % convert from homogenous coordinates 


