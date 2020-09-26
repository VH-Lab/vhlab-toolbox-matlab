function demo_illustrate_facespace_build(dirname)
% DEMO_ILLUSTRATE_FACESPACE_BUILD - illustrate the construction of face space from Cheng and Tsao 2017
%
% Illustrates the construction of facespace from Cheng and Tsao 2017 Cell
%
% DIRNAME should be the name of the FEI face database files, frontal views
%   http://fei.edu.br/~cet/facedatabase.html
%
% Reads only the neutral expression faces (number 'a.jpg')


  % 
d = dir([dirname filesep '*a.jpg']);

im_vector = [];

progressbar('Working through faces...')

for i=1:numel(d),
	progressbar(i/numel(d));
	im = imread([dirname filesep d(i).name]);
	im = mean(im,3); % make grayscale
	im_vectorhere = reshape(im,1,prod(size(im)));
	[p,name,ext]=fileparts(d(i).name);
	imwrite(im_vectorhere, gray(256), [dirname filesep name '-vectorized.tif']);
	im_vector = [ im_vector; reshape(im,1,prod(size(im))) ];
end;

progressbar(1) % close it

im_vector_mn = mean(im_vector,1);
 
imwrite(im_vector, gray(256), ['vectorized_faces.tif']);

mypath = matlabpath;
addpath([matlabroot filesep 'toolbox' filesep 'stats' filesep 'stats'],'-begin'); % make sure we get right 'pca'
clear pca

eval(['[coeff,score,latent] = pca(im_vector);']);

matlabpath(mypath); % set it back to what it was

imwrite( rescale(score(:,1:25), max(abs(colvec(score(:,1:25))))*[-1 1], [0 255]), ...
	gray(256), [dirname filesep 'pca_projected.tif'] );

imwrite( (reshape(im_vector_mn,360,260)')', gray(256), [dirname filesep 'mean_face.tif'] );

for i=1:25,
	imwrite( rescale( (reshape(coeff(:,i),360,260)')', [min(coeff(:,2)) max(coeff(:,2))], [0 255]), ...
		gray(256), [dirname filesep 'pca-' sprintf('%03d',i) '.tif']);
end

