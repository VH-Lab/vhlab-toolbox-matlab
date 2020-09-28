function [curve] = linepowerthreshold(x,slope,offset,threshold,exponent)
% LINEPOWERTHRESHOLD - compute linepowerthreshold function for values of x
%
%  [CURVE] = LINEPOWERTHRESHOLD(X, SLOPE, OFFSET, THRESHOLD, EXPONENT)
%
%  Calculates
%
%  CURVE = OFFSET + SLOPE * RECTIFY(X - THRESHOLD).^EXPONENT
%
% See also: QUICKREGRESSION (simple linear fit), LINEPOWERTHRESHOLDFIT
%
% Jason Osik and Steve Van Hooser
% 

curve = offset + slope * vlt.math.rectify(x(:)-threshold).^exponent;

