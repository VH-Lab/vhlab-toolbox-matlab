function [im_out,stack_coords_in_tile] = stack2tile(im_in, m, n)
% vlt.image.stack2tile - write a 3D stack of images to a 2D tiled image set
%
% [IM_OUT, STACK_COORDS_IN_TILE] = STACK2TILE(IM_IN, M, N)
%
% Takes a stack of images of size XxYxZ and creates a set of tiled images.
% The Z planes are distributed from left to right in the tiled image and then
% top to bottom, in an M rows x N columns arrangement. If there are more Z planes than
% M * N, then additional tiles are made. The tiles are returned as a cell
% array of 2D matrixes in IM_OUT.
%
% Note that the tle arrangement order is the same as the Matlab SUBPLOT command.
%
% If the stack does not exactly cover the last M x N tiled image, then
% that part of the image is filled with zeros.
%
% STACK_COORDS_IN_TILE is a matrix of row vectors. Each row j contains the
% TILE_NUMBER, X_TOP, X_BOTTOM, Y_LEFT, Y_RIGHT coordinates of the stack in
% the tile.
%
%
% Example:
%   IM_IN = zeros(3,4);
%   IM_IN(:,:,2) = 64*ones(3,4);
%   IM_IN(:,:,3) = 128*ones(3,4);
%   IM_IN(:,:,4) = 255 * ones(3,4);
%   IM_OUT = vlt.image.stack2tile(IM_IN,1,4);  % compare with 2,2
%     % creates a 1x4 tile of the images       % compare with 2,2
%   figure;
%   image(IM_OUT{1});
%   colormap(gray(256));
%   

im_out = {};

stack_coords_in_tile = [];

z_count = 0;
row_count = 0;
col_count = 0;
image_count = 1;

[x,y,z] = size(im_in);

while z_count < z,
	im_out_ = zeros(m*x, n*y);
	for r=1:m,
		for c=1:n,
			if z_count < z,
				z_count = z_count + 1;
				im_out_( (1+(r-1)*x):(r*x), (1+(c-1)*y):(c*y) ) = im_in(:,:,z_count);
				stack_coords_in_tile(end+1,[1:5]) = [image_count 1+(r-1)*x r*x 1+(c-1)*y c*y];
			end;
		end;
	end;
	im_out{end+1} = im_out_;
	image_count = image_count + 1;
end;


