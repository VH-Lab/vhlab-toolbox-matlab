function [p,gof,fitcurve] = gausslogfit(x, y, varargin)
% GAUSSLOGFIT - gaussian log fit with constraints
%
% [P,GOF,FITCURVE] = GAUSSLOGFIT(X, Y, ...)
%
% Fits the data Y at positions X to:
%
% Y = a+b*exp(-((log10(x)-log10(c)).^2/(2*d^2)))
%
% a is an offset parameter; b is a height parameter above the offset; 
% c is the peak location; d is the width; e is the degree of skewness (0 is none)
%
% The outputs are the parameters P = [a b c d] and the goodness-of-fit values
% GOF. FITCURVE is the fit value for all values of x; the first row is all x values, the
% second row is the fit function values.
%
% See also: vlt.math.gausslog
%
% The user can pass initial guesses and constraints as name/value pairs:
% Parameter (default)              | Description
% ----------------------------------------------------------------------
% a_hint (0)                           | Offset initial guess
% a_range ([min(y) max(y)])            | Offset allowed range
% b_hint (max(y))                      | Height inital guess
% b_range [0 2*max(y)]                 | Height range
% c_hint (vlt.math.center_of_mass(x,y) | Initial guess for peak location
% c_range ([min(x) max(x)])            | Peak location range
% d_hint (0.1*(max(x)-min(x)))         | Initial guess of width
% d_range [0.01*(max(x)-min(x)) ...    | Width range
%         [1*(max(x)-min(x))]          | 
%

a_hint = 0;
a_range = [min(y) max(y)];
b_hint = max(y);
b_range = [0 2*max(y)];
c_hint = vlt.math.center_of_mass(x,y);
c_range = [min(x) max(x)];
total_w = max(x) - min(x);
d_hint = 0.1*total_w;
%trying to force better fit
%d_range = [0.01 1] * total_w;
d_range = [.01 1];

vlt.data.assign(varargin{:});

if size(x,2)~=1,
	error(['X must be column data.']);
end;

if size(y,2)~=1,
	error(['Y must be column data.']);
end;

gauss = fittype('a+b*exp(-((log10(x)-log10(c)).^2)/((2*d^2)))');
fo = fitoptions(gauss);

fo.StartPoint = [a_hint b_hint c_hint d_hint ];

fo.Lower = [a_range(1) b_range(1) c_range(1) d_range(1) ];
fo.Upper = [a_range(2) b_range(2) c_range(2) d_range(2) ];

gauss = setoptions(gauss,fo); % install the options in the fittype

[c,gof]=fit(x,y,gauss);

fitcurve = c(x);

p = [c.a c.b c.c c.d];

