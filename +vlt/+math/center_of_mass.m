function pos = center_of_mass(points, weights)

% CENTER_OF_MASS Compute center of mass of points
%
%  POS = CENTER_OF_MASS(POINTS, [WEIGHTS])
%
%  Computes the center of mass of a group of points.  Each row should
%  contain a separate point in N-space.  If a weights vector is provided,
%  then each point is weighted by the corresponding weight.
%   

[m,n] = size(points);

if nargin>1,
	w = weights(:);
else,
	w = ones(m,1);
end;

W = repmat(w,1,n);

pos = sum(W.*points)/sum(w);

