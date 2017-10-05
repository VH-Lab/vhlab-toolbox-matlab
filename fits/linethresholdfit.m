function [slope, threshold, curve, gof,fitinfo ] = linethresholdfit(x,y,varargin)
% LINETHRESHOLDFIT - Fit a linear function, raised to a power, with a threshold
%
%  [SLOPE, THRESHOLD, CURVE, GOF, FITINFO] = 
%      LINETHRESHOLDFIT(X, Y, ...)
%
%  Performs a nonlinear fit to find the best parameters for a function of the form
%  Y = SLOPE * RECTIFY(X - THRESHOLD)
%
%  X and Y should be vectors with the same length. SLOPE and THRESHOLD are the
%  best fit values.  CURVE is the fit values of Y for the values of
%  X used to generate the fit. GOF and FITINFO are the Matlab goodness-of-fit
%  and fitinfo structures that are returned by the Matlab function FIT.
%
%  Initial parameters and ranges can be modified by passing name/value pairs.
%
% This function can also take name/value pairs that modify default behaviors:
% Parameter (default)               | Description
% ---------------------------------------------------------------------------
% threshold_start (min(x))               | Iniitial starting point for THRESHOLD fit
% thresholdrange [(min(x)-1) max(x)+1)]  | THRESHOLD fit range
% slope_start (from quickregression)     | Initial starting point for SLOPE fit
% slope_range [-Inf Inf]                 | SLOPE fit range
% 
%
% Example:
%     x = sort(rand(20,1));
%     y = linepowerthreshold(x,3,0,0.5,1);
%        % limit search to exponents = 1
%     [slope,t,thefit]=linethresholdfit(x,y);
%     figure;
%     plot(x,y,'bo');
%     hold on;
%     plot(x,thefit,'rx-');
%     box off;
%     
% See also: QUICKREGRESSION (simple linear fit), FIT, LINEPOWERTHRESHOLD, LINEPOWERTHRESHOLDFIT
%
% Jason Osik and Steve Van Hooser
% 

  % default initial guesses

threshold_start = min(x);
threshold_range = [ min(x)-1 max(x)+1 ];

warnstate = warning('query');
warning off
  % turn off usual REGRESS warnings
  [slope_start,offset_start]=quickregression(x(:),y(:),0.05); % ALPHA doesn't matter here
  % restore warning state
warning(warnstate);

slope_range = [-Inf Inf];

  % assign user-altered values
assign(varargin{:});

s = fitoptions('Method','NonlinearLeastSquares',...
	'Lower',[ slope_range(1) threshold_range(1)],...
	'Upper',[ slope_range(2) threshold_range(2)],...
	'StartPoint', [slope_start threshold_start]);

ft = fittype('linepowerthreshold(x,a,0,b,1)','options',s);
[cl,gof,fitinfo] = fit(x(:),y(:),ft);

slope = cl.a;
threshold = cl.b;

curve = linepowerthreshold(x(:),slope,0,threshold,1);
