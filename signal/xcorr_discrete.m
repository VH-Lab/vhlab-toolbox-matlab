function xc = xcorr_discrete(signal1, signal2, N, normstring)
% XCORR_DISCRETE - Calculate the cross-correlation between two signals without FFT
%
%  XC = XCORR_DISCRETE(SIGNAL1, SIGNAL2, N, NORMSTRING)
%
%  Computes the cross-correlation between SIGNAL1 and SIGNAL2 for lags up to N.
%
%  If NORMSTRING is left off, then the correlation is not normalized.
%  Otherwise it is normalized according to the following values of NORMSTRING:
%    'none' : no normalization
%   'biased': divides by length of SIGNAL1
% 'unbiased': divides by the absolute value of length of SIGNAL - LAG
%  

if nargin<3,
	N = length(signal1)-1;
end;

if nargin<4,
	normstring = 'none';
end;

xc = zeros(N,1);

lags = -N:N;
inc = 1;

for l = lags,
	if l>0,
		xc(inc) = sum( signal2(1:end-l) .* signal1(l+1:end) );
	elseif l<0,
		xc(inc) = sum(signal2(1-l:end) .* signal1(1:end-(-l)) );
	else,
		xc(inc) = sum(signal2.*signal1);
	end;
	inc = inc + 1;
end;

switch lower(normstring),
	case 'none',

	case 'biased',
		xc = xc / length(signal1);
	case 'unbiased',
		xc = xc ./ (length(signal1) - abs(lags(:))); 
	otherwise,
		error([Unknown NORMSTRING value ' normstring '.']);
end;

