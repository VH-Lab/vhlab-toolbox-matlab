function [i,pointc] = findclosestpoint(pointlist,point)
% FINDCLOSESTPOINT - Find the closest corresponding point in a list
%
% [I,POINTC] = FINDCLOSESTPOINT(POINTLIST,POINT)
%
% Finds the index and value to the closest member of POINTLIST to POINT
% in Euclidean distance. POINTLIST should be a list of points, with 1 
% row per point. It returns the index in I and the value
% in POINTC.  If ARRAY is empointy, so are I and POINTC.
%
% If there are multiple occurances of POINT within POINTLIST,
% only the first is returned in I.
%
% See also: FIND, FINDCLOSEST

[NumPoints,Dim] = size(pointlist);

euclidean_distance =sqrt( sum((repmat(point, NumPoints, 1) - pointlist).^2,2)  );

[i,v] = vlt.data.findclosest(euclidean_distance, 0);
pointc = pointlist(i,:);
