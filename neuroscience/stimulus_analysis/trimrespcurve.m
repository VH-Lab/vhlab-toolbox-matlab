function curve = trimrespcurve(mycurve)
% TRIMRESPCURVE - Trim a 4xN response curve to remove NaN stimulus values
%
%    CURVE = TRIMRESPCURVE(MYCURVE)
%
%  Assumes MYCURVE is a 4xN response curve where the first row MYCURVE(1,:)
%  has the stimulus values.  If any of these entries are NaN, then those column
%  is removed from MYCURVE. The result is returned in CURVE.
%  
%  One can use this function to remove the response of the blank stimulus from a
%  response curve.

z = find(~isnan(mycurve(1,:)));
curve = mycurve(:,z);
