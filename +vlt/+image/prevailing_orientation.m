function [theta,im_out] = prevailing_orientation(im)
% PREVAILING_ORIENTATION - determine the prevailing orientation (strongest oriented sinwave signal) of an image
%
% [THETA,IM_OUT] = PREVAILING_ORIENTATION(IM)
%
% Performs a 2D fourier transform on the image IM and identifies the prevailing image
% orientation by finding the peak non-DC sinusoidal component. 
%
% THETA is the orientation in radians.
%
% This function will likely work poorly on data that is not a simple sinusoid or that lacks
% a dominant sinusoid.
%
% If 2 output arguments are specified, a rotated version of the image is returned
% using IMROTATE and bilinear interpolation.
%
% Developer's note: this function takes the peak in the 2-d fourier space as evidence of
% the phase. This results in a small error for some low spatial frequencies. The function
% could be improved.
%
% See also: FFT2, IMROTATE 
%
% Example:
%   [x,y] = meshgrid([-100:100],[-100:100]);
%   im = sin(0.3*x+0.1*y);
%   [theta,im_out] = vlt.image.prevailing_orientation(im);
%   figure;
%   subplot(2,2,1);
%   imagesc(im);
%   subplot(2,2,2);
%   imagesc(im_out);
% 

Y = fft2(im);
[m,n] = size(im);

Y(1,1) = 0; % disallow 0 point

bigmax = max(abs(Y(:)));
[I,J] = find(abs(Y)==bigmax);

  % fft2 is:
  % Y(p+1,q+1) = sum{j=0}{m-1}sum{k=0}{n-1}(exp(-2*pi*i*j*p/m)*exp(-2*pi*i*k*q/n)*im(j+1,k+1)
  % 
  % So the biggest value of Y(p+1,q+1) is when IM is multiplied with the wave:
  %     (exp(-2*pi*i*j*p/m)*exp(-2*pi*i*k*q/n)*im(j+1,k+1)
  % Let's say x=j and y=k
  %     (exp(-2*pi*i*p*x/m)*exp(-2*pi*i*q*y/n)*im(j+1,k+1)
  %
  % Then 1 phase is when x is m/p and y is n/q
  % Change in X is m/p and change in y is n/q.
  % Tan(theta) = delta_y / delta_x
  %  

 % select only a single point
I = I(1);
J = J(1); 

p = I(1)-1;
q = J(1)-1;

theta = atan2(n/q,m/p);

theta_degrees = vlt.math.rad2deg(theta);

im_out = imrotate(im,theta_degrees,'bilinear','crop');

