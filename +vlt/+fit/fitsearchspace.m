function x0_vectors = fitsearchspace(lower_bounds, upper_bounds, nspace)
% FITSEARCHSPACE - return a set of vectors that span a range
% 
% X0_VECTORS = vlt.fit.fitearchspace(LOWER_BOUNDS, UPPER_BOUNDS, NSPACE)
%
% Given a set of LOWER_BOUNDS = [ m1 m2 ... ] and UPPER_BOUNDS = [n1 n2 ...],
% this function computes a set of vectors that tile this space in NSPACE
% steps (using LINSPACE).
%
% The columns of X0_VECTORS are vector values (NPOINTS x dimension of bounds).
%
% See also: LINSPACE, MESHGRID, NDGRID
%
% Example:
%    X0_vectors = vlt.fit.fitearchspace([0 0],[1 1],5)
%

dim = numel(lower_bounds); % should match upper bounds
if numel(upper_bounds)~=dim,
	error(['lower_bounds, upper_bounds must have same number of elements.']);
end;

  % Step 1, create the spaced steps in each dimension
g = {};
for i=1:dim,
	g{i} = linspace(lower_bounds(i),upper_bounds(i),nspace);
end;

  % Step 2, make the ngrid and spread the outputs into a cell

X = cell(1,dim);
[X{:}] = ndgrid(g{:});

  % Step 3, re-arrange the points into columns of size dim

x0s = cat(dim+1,X{:});

npoints = nspace^dim;

x0_vectors = reshape(x0s,npoints,dim)';

