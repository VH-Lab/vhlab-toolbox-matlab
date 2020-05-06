function [slope, offset, threshold, exponent, curve, gof,fitinfo ] = linepowerthresholdfit(x,y,varargin)
% LINEPOWERTHRESHOLDFIT - Fit a linear function, raised to a power, with a threshold
%
%  [SLOPE, OFFSET, THRESHOLD, EXPONENT, CURVE, GOF, FITINFO] = 
%      LINEPOWERTHRESHOLDFIT(X, Y, ...)
%
%  Performs a nonlinear fit to find the best parameters for a function of the form
%  Y = OFFSET + SLOPE * RECTIFY(X - THRESHOLD).^EXPONENT
%
%  X and Y should be vectors with the same length. SLOPE, OFFSET, THRESHOLD, and
%  EXPONENT are the best fit values.  CURVE is the fit values of Y for the values of
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
% offset_start (from quickregression)    | Initial OFFSET starting point
% offset_range ([-Inf Inf])              | OFFSET parameter range
% exponent_start (1)                     | Initial EXPONENT start point
% exponent_range ([-Inf Inf])            | EXPONENT search space
% weights ([])                           | Weigh the error at each point by a value
% 
%
% Example:
%     x = sort(rand(20,1));
%     y = linepowerthreshold(x,3,0.3,0.5,1);
%        % limit search to exponents = 1
%     [slope,offset,t,exponent,thefit]=linepowerthresholdfit(x,y,'exponent_start',1,'exponent_range',[1 1]);
%     figure;
%     plot(x,y,'bo');
%     hold on;
%     plot(x,thefit,'rx');
%     box off;
%     
% See also: QUICKREGRESSION (simple linear fit), FIT, LINEPOWERTHRESHOLD
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
offset_range = [-Inf Inf];

exponent_start = 1;
exponent_range = [-Inf Inf];

weights = [];

  % assign user-altered values
assign(varargin{:});

s = fitoptions('Method','NonlinearLeastSquares',...
	'Lower',[ slope_range(1) offset_range(1) threshold_range(1) exponent_range(1)],...
	'Upper',[ slope_range(2) offset_range(2) threshold_range(2) exponent_range(2)],...
	'StartPoint', [slope_start offset_start threshold_start exponent_start],...
	'Weights',weights);

ft = fittype('linepowerthreshold(x,a,b,c,d)','options',s);
[cl,gof,fitinfo] = fit(x(:),y(:),ft);

slope = cl.a;
offset = cl.b;
threshold = cl.c;
exponent = cl.d;

curve = linepowerthreshold(x(:),slope,offset,threshold,exponent);
