function [v, pis]=autocorr_step_white_poles(z,M,alpha,o)
% AUTOCORR_STEP_ZEROS - Evaluate z-transform of autocorrelation using zeros
%
%  [V, PIS] = AUTOCORR_STEP_WHITE_POLES(z,M,alpha,o)
%
%  Evalutes the z-transform of the autocorrelation using the functions zeros
%  (This is for test purposes only)
%

pis = zeros(1,M);

pis = pis + (mod(0:M-1,2)) .* (-1).^( (0:M-1)/M );  % odd powers
pis = pis + (mod(1+(0:M-1),2)) .* (-1) .* (-1).^( (0:M-1)/M );  % even powers

v = [];

for n=0:o, 

	v(n+1) = 0;

	v(n+1) = v(n+1) + (sqrt(2)/sqrt(M*alpha)) * sum( (pis.^(n-(M-1))));

end;
