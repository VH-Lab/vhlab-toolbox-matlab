function im_out=padimage(im_in, N, pad)
% PADIMAGE - Add a border to an image
%
%  IM_OUT = PADIMAGE(IM_IN, N, PAD)
%
%  Adds a border to an image IM_IN. The border
%  pixels have value PAD.
%
%  IM_IN can be either a 2-D set of points or can be
%  a 3-D set of points, in which case it is assumed that
%  IM_IN is an RGB or CMYK image. PAD should have dimension 1 in the
%  case of a 2D image, or 3 or 4 dimensions in case of a 3-dimensional image.
%
%  N can be a single integer if the number of pixels to add to all borders is
%  the same in X and Y. Or, N can be a vector [Nx1 Nx2 Ny1 Ny2] that indicates
%  that Nx1 points of value PAD should be added before the first dimension
%  of IM_IN, and that Nx2 points of value PAD should be added after the first
%  dimension, etc.
%
%  The result is returned in IM_OUT.

if length(N)==1,
	N = [N N N N];
end;

sz = size(im_in);

switch length(sz),
	case 1,
		error(['IM_IN must be at least 2-D.']);
	case 2,
		pad = reshape(pad,1,1);
	case 3,
		pad = reshape(pad,1,1,numel(pad));
	otherwise,
		error(['Do not know how to handle dimension of IM_IN.']); 
end;

im_in = cat(2,repmat(pad,sz(1),N(1)),...
	im_in,...
	repmat(pad,sz(1),N(2)));
im_out = cat(1,repmat(pad,N(3),sz(2)+N(1)+N(2)), ...
	im_in,...
	repmat(pad,N(4),sz(2)+N(1)+N(2)));


