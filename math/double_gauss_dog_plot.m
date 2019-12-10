function h=double_gauss_dog_plot(R, theta, sf, varargin)
% DOUBLE_GAUSS_DOG_PLOT(R, THETA, SF)
%
% Plots a surface figure in the current axes in the current figure
% of R (response), theta (angle), sf (spatial frequency) 

error('update documentation');

surf(theta, sf, R);
