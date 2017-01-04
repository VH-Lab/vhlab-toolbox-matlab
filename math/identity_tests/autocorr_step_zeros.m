function [v, zi]=autocorr_step_zeros(z,N,alpha)
% AUTOCORR_STEP_ZEROS - Evaluate z-transform of autocorrelation using zeros
%
%  [V, ZI] = AUTOCORR_STEP_ZEROS(z,N,alpha)
%
%  Evalutes the z-transform of the autocorrelation using the functions zeros
%  (This is for test purposes only)
%

zi = zeros(1,N-1);

zi = zi + (mod(1:N-1,2)) .* (-1) .* (-1).^( (1:N-1)/N );  % odd powers
zi = zi + (mod(1+(1:N-1),2)) .* (-1).^( (1:N-1)/N );  % even powers

zi = [zi zi];

v = (alpha/N) * prod([1-zi/z ]);
