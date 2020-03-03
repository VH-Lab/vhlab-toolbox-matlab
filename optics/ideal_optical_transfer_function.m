function [otf_value] = ideal_optical_transfer_function(v)
% IDEAL_OPTICAL_TRANSFER_FUNCTION - ideal optical transfer function as a function of spatial frequency
%  
% OTF_VALUE = IDEAL_OPTICAL_TRANSFER_FUNCTION(V)
%
% Computes the optical transfer function of an ideal diffraction-limited imaging system:
%   OTF_VALUE = 2/pi * (acos(abs(v)) - abs(v).*sqrt(1-v.*v))
%
% V is the spatial frequency, relative to the high spatial frequency cut off V_cutoff (V_cutoff := 1).
%   
% From Wikipedia:
%
% Example:
%    v = 0:0.001:1;
%    otf = ideal_optical_transfer_function(v);
%    figure;
%    plot(v,otf);
%    xlabel('Spatial frequency (relative to max cut-off)');
%    ylabel('Contrast');
% 

otf_value = 2/pi * (acos(abs(v)) - abs(v).*sqrt(1-v.*v));


