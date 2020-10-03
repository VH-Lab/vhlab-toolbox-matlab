function [theta, sf, R, offset, double_gauss_params, dog_params] = example_double_gauss_dog_data;
% EXAMPLE_DOUBLE_GAUSS_DOG_DATA - generate a random set of data + parameters
%
%
% 
% STARTING VALUES THAT MAKE FOR GOOD FIT
% dog_params = [ 0 1 0.5 0.4 1];
% double_gauss_params = [ 1 10 45 25 4];
% theta_range = [ 0:22.5:360-22.5 ];
% sf_range = [ 0.01 0.02 0.05 0.08 0.1 0.2 0.5 1.2 1.5 1.8];
% [theta, sf] = meshgrid(theta_range, sf_range);
% R = vlt.math.double_gauss_DoG(theta, sf, double_gauss_params, dog_params);

error('check for completion.');

dog_params = [0.1 1 0.5 0.4 1];
double_gauss_params = [0 10 45 25 2];
offset = 5;

theta_range = [ 0:22.5:360-22.5 ];
sf_range = [ 0.01 0.02 0.05 0.08 0.1 0.2 0.5 1.2 1.5 1.8];

[theta, sf] = meshgrid(theta_range, sf_range);

R = vlt.math.double_gauss_DoG(theta, sf, offset, double_gauss_params, dog_params);

