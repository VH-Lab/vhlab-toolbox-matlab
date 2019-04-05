function im = ROI_imageexample;
% ROI_imageexample - return an example image for experimenting with ROI functions
%
% IM = ROI_IMAGEEXAMPLE;
%
% Returns an image with 3 overlapping Gaussian balls for ROI functions
%
% Example:
%   im = ROI_imageexample;
%   imshow(im);
%
 
delta = 10;

centers = [ 128 128 ; 128-delta 128-delta ; 128+delta 128+delta];

centers = centers + randn(size(centers))*2;

A = [ 200 100 50 ];

sigma{1} = [ 8 0 ; 0 8] * 4;
sigma{2} = [ 8 0 ; 0 8] * 4;
sigma{3} = [ 8 0 ; 0 8] * 4;

[X,Y]=meshgrid(1:256,1:256);

im = zeros(256,256);

for i=1:numel(A),
	im = im + reshape(A(i)*mvnpdf([X(:) Y(:)], centers(i,:), sigma{i}), 256, 256);
end


