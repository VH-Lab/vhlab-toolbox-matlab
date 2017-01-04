function wiener_demo(varargin)
% WIENER_DEMO - Demonstration of filter reconstruction using Wiener filtering
%
%  Given a signal x[n] that is filtered by some unknown process, derive the least
%  square best filter such that y[n] * myfilter +noise = x[n]
%  
%  modified from: Digital Signal Processing Using MATLAB for Students and Researchers
%  John W. Leis (Wiley, 2011)
%
%  The following parameters of the example can be modified by passing name/value pairs:
%  Parameter (default)              | Description
%  ----------------------------------------------------------------------------
%  N (10000)                        | Number of points
%  b ([1 0.8 -0.4 0.1])             | Filter parameters (computed using filter)
%  L (4)                            | Coefficient length of divided signal
%  NewNoise (0)                     | Should we filter the original noise or new noise?
%  

N = 10000;
b = [ 1 0.8 -0.4 0.1];
L = 4;
NewNoise = 0;

assign(varargin{:});

N = 10000; % number of points
x = randn(1,N);
n = 0:N-1;

yc = 2 * sin(2*pi*n/(N-1)*5);

v = filter(b,1,x);  % filtered noise
y = yc + v;          % clean signal

 % calculate covariance on reshaped data

xm = reshape(x,L,N/L);
ym = reshape(y,L,N/L);
xv = xm(1,:);  % y vector at intervals corresponding to the start of each xm snippet above

R = (xm * xm')/(N/L);
r = (ym * xv')/(N/L);

wopt = inv(R) * r;

if NewNoise,
	x_ = randn(1,N);
else,
	x_ = x;
end;

vest = filter(wopt,1,x_);

e = y - vest;


figure;

subplot(3,1,1);
plot(yc);
title('Clean signal');
box off;
axis([1 N -4 4]);

subplot(3,1,2);
plot(y);
title('Noisy signal');
box off;
axis([1 N -4 4]);

subplot(3,1,3);
plot(y-vest);
title('Filtered signal');
box off;
axis([1 N -4 4]);

