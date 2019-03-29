function [ fit_curve, params, gof, fitinfo ] = tanhfitoffset( x_,y_ , varargin)
% TANHFIT - Fit a curve with a hyperbolic tangent tanh
% 
% [FIT_CURVE, PARAMS, GOF, FITINFO] = TANHFITOFFSET(X, Y, ...)
%
% Finds a, b, c, d such that the error in the equation 
%
%      Y = (a + b) + b * TANH( (X-c) / d)
%
% is minimized in the least-squares sense.
%
% In this equation, a is the offset of the equation from 0 at 
% X = -Inf.
%
% FIT_CURVE is a fit curve that is 100x2 (by default, see below)
% where FIT_CURVE(:,1) is 100 equally spaced points between min(X)
% and max(X), and FIT_CURVE(:,2) is the result of the fit.]
% PARAMS is the parameters returned from Matlab's FIT function.
%
%  
%
% This function also takes additional parameters in the form of name/value
% pairs.
% Parameter (default)     | Description
% ---------------------------------------------------------------
% NPTS_CURVE (100)        | Number of points to produce in the fit
% a_range [-Inf Inf]      | Search range for fit parameter a
% b_range [0 Inf]         | Search range for fit parameter b
% c_range [-100 100]      | Search range for fit parameter c
% d_range [1e-12 Inf]     | Search range for fit parameter d
% startPoint [0 1 0 1]    | Starting point for the search
%
% Jason Osik 2016-2017, modified by SDV 2019
%
% See also: FIT, FITTYPE, TANHFIT
%

NPTS_CURVE = 100;
a_range = [-Inf Inf];
b_range = [0 Inf];
c_range = [-100 100];
d_range = [1e-12 Inf];
startPoint = [0 1 0 1];

assign(varargin{:});

x_ = reshape(x_,length(x_),1); % make a column vector
y_ = reshape(y_,length(y_),1); % make a column vector

s = fitoptions('Method','NonlinearLeastSquares',...
    'Lower',[a_range(1),b_range(1),c_range(1),d_range(1)],...
    'Upper',[a_range(2),b_range(2),c_range(2),d_range(2)],...
    'Startpoint',startPoint);

ft = fittype('a + b + b*tanh((x - c)./d)','options',s);

[params,gof,fitinfo] = fit(x_,y_,ft);

fit_curve(:,1) = linspace(min(x_), max(x_), NPTS_CURVE)';
fit_curve(:,2) = params.a + params.b + params.b.*tanh((fit_curve(:,1) - params.c)./params.d);

