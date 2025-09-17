function [i,pointc] = findclosestpoint(pointlist,point)
% FINDCLOSESTPOINT - Find the closest corresponding point in a list
%
% [I,POINTC] = vlt.data.findclosestpoint(POINTLIST,POINT)
%
%   Finds the index and value of the closest point in POINTLIST to POINT,
%   based on Euclidean distance.
%
%   Inputs:
%   'POINTLIST' is a matrix where each row represents a point.
%   'POINT' is a single point (a row vector).
%
%   Outputs:
%   'I' is the index of the closest point in POINTLIST.
%   'POINTC' is the value of the closest point.
%
%   If there are multiple points with the same minimum distance, the index
%   of the first one is returned.
%
%   Example:
%       pointlist = [1 1; 5 5; 10 10];
%       point = [6 6];
%       [i, pointc] = vlt.data.findclosestpoint(pointlist, point);
%       % i will be 2, pointc will be [5 5]
%
%   See also: FIND, vlt.data.findclosest
%

[NumPoints,Dim] = size(pointlist);

euclidean_distance =sqrt( sum((repmat(point, NumPoints, 1) - pointlist).^2,2)  );

[i,v] = vlt.data.findclosest(euclidean_distance, 0);
pointc = pointlist(i,:);
