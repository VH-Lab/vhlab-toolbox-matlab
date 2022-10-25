function [p,sse] = dogfit(x, y, varargin)
% DOGFIT - fit a difference of Gaussians to data
% 
% [P,SSE] = vlt.fit.dogfit(X,Y, ...)
%
% Fits the following function to the column vector data in X, Y:
%  y(x) = a + b*exp(-((x-c).^2)/d^2) - e*exp(-((x-f).^2)/g^2)
%  
% P is the parameters [a b c d e f g] and SSE is the summed 
% squared error between the fit and the data (y).
% 
% This function accepts name/value pairs that alter its default
% behavior:
% --------------------------------------------------------------
% | Parameter (default)     |                                  |
% |-------------------------|----------------------------------|
% | random_starts (10)      | Number of random search starts   |
% | a_low (0)               | Low search limit for a           |
% | a_high (0)              | High search limit for a          |
% | a_initial (NaN)         | a initial guess (NaN means choose|
% |                         |   randomly between limits)       |
% | b_low (0)               | Low search limit for b           |
% | b_high (2*max(Y))       | High search limit for b          |
% | b_initial (NaN)         | b initial guess (NaN means choose|
% |                         |   randomly between limits)       |
% | c_low (0)               | Low search limit for c           |
% | c_high (0)              | High search limit for c          |
% | c_initial (NaN)         | c initial guess (NaN means choose|
% |                         |   randomly between limits)       |
% | d_low (2*min(diff(X)))  | Low search limit for d           |
% | d_high (2*max(X))       | High search limit for d          |
% | d_initial (NaN)         | d initial guess (NaN means choose|
% |                         |   randomly between limits)       |
% | e_low (0)               | Low search limit for e           |
% | e_high (2*max(Y))       | High search limit for e          |
% | e_initial (NaN)         | e initial guess (NaN means choose|
% |                         |   randomly between limits)       |
% | f_low (0)               | Low search limit for f           |
% | f_high (0)              | High search limit for f          |
% | f_initial (NaN)         | f initial guess (NaN means choose|
% |                         |   randomly between limits)       |
% | g_low (2*min(diff(X)))  | Low search limit for g           |
% | g_high (2*max(X))       | High search limit for g          |
% | g_initial (NaN)         | g initial guess (NaN means choose|
% |-------------------------|----------------------------------|
%
%  Example:
%     P = [ 0 10 0 3 2 0 1 ];
%     x = logspace(-3,1,100);
%     y = vlt.math.dogfull(x,P);
%     figure;
%     plot(x,y); 
%     ylabel('y');
%     xlabel('x');
%     [P_fit,err] = vlt.fit.dogfit(x,y);
%     y_fit = vlt.math.dogfull(x,P_fit);
%     hold on;
%     plot(x,y_fit,'g-');
%     legend('original','fit');

random_starts = 10;

x = x(:);
y = y(:);

a_low = 0;
a_high = 0;
a_initial = NaN;

b_low = 0;
b_high = 2*max(y);
b_initial = NaN;

c_low = 0;
c_high = 0;
c_initial = NaN;

d_low = 2*min(diff(x));
d_high = 2*max(x);
d_initial = NaN;

e_low = 0;
e_high = 2*max(y);
e_initial = NaN;

f_low = 0;
f_high = 0;
f_initial = NaN;

g_low = 2*min(diff(x));
g_high = 2*max(x);
g_initial = NaN;

x = vlt.data.colvec(x);
y = vlt.data.colvec(y);

vlt.data.assign(varargin{:});

names = {'a','b','c','d','e','f','g'};

best_SSE = Inf;

best_P = [NaN*ones(1,7)];

s = fitoptions('Method','NonlinearLeastSquares',... % use squared error
      'Lower',[a_low b_low c_low d_low e_low f_low g_low],...   % lower bounds 
      'Upper',[a_high b_high c_high d_high e_high f_high g_high]);,... % upper bounds


fit_ = fittype('vlt.math.dogfull(x,[a; b; c; d; e; f; g])',...
	'independent',{'x'},'coefficients',{'a','b','c','d','e','f','g'});

for i=1:random_starts,

	a_start = a_initial;
	if isnan(a_initial),
		a_start = a_low + rand*(a_high-a_low);
	end;

	b_start = b_initial;
	if isnan(b_initial),
		b_start = b_low + rand*(b_high-b_low);
	end;

	c_start = c_initial;
	if isnan(c_initial),
		c_start = c_low + rand*(c_high-c_low);
	end;

	d_start = d_initial;
	if isnan(d_initial),
		d_start = d_low + rand*(d_high-d_low);
	end;

	e_start = e_initial;
	if isnan(e_initial),
		e_start = e_low + rand*(e_high-e_low);
	end;

	f_start = f_initial;
	if isnan(f_initial),
		f_start = f_low + rand*(f_high-f_low);
	end;

	g_start = g_initial;
	if isnan(g_initial),
		g_start = g_low + rand*(g_high-g_low);
	end;

	s.StartPoint = [a_start b_start c_start d_start e_start f_start g_start];

	fit_ = setoptions(fit_,s);

	[curvefit,gof] = fit(x,y,fit_);

	if gof.sse < best_SSE,
		best_P = [curvefit.a curvefit.b curvefit.c curvefit.d curvefit.e curvefit.f curvefit.g];
		best_SSE = gof.sse; 
	end;
end;

p = best_P;
sse = best_SSE;


