function [d,cpt] = ptontovector(offset, vector_dir, pt, varargin)
% PTONTOVECTOR - Find distance between point and a vector
%
% [D, CPT] = vlt.math.ptontovector(OFFSET, VECTOR_DIR, PT)
%
% Calculates the Euclidean distance D between a vector that is specified
% by the line
%
% X = OFFSET + VECTOR_DIR * t for all t
%
% and the given PT. The closest point on the line X, CPT, is returned.
%
% This function accepts additional arguments in the form of name/value pairs.
% Parameter (default)      | Description
% ----------------------------------------------------------------------
% Segment (0)              | Only calculate distance to points within the
%                          |   segment from offset to offset + vector_dir
%  


  % work in columns
offset = offset(:);
vector_dir = vector_dir(:);
pt = pt(:);

segment = 0;
vlt.data.assign(varargin{:});

if norm(vector_dir)==0,
	error(['Directional vector VECTOR_DIR must have some length.']);
end

Y = offset - pt;

unit_vector_dir = vector_dir/norm(vector_dir);

d = norm((Y-dot(Y,unit_vector_dir)*unit_vector_dir));
cpt = offset - dot(Y,unit_vector_dir)*unit_vector_dir;

if segment,
	t = nanmedian((cpt - offset)./vector_dir);
	if t>1, % beyond end of vector_dir
		cpt = offset + vector_dir;
	elseif t<0,
		cpt = offset;
	end
	d = norm(cpt-pt);
end



