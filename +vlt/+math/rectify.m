function r = rectify(x, rectvalue)

% vlt.math.rectify - Rectify around 0
%
%  R = vlt.math.rectify(X)
%
%  Returns X except where X is less than 0,
%  in which case 0 is returned.
%
%  One can also use the form:
%
%  R = vlt.math.rectify(X, RECTVALUE)
%
%  where points below 0 are given the value RECTVALUE.
%

if nargin<2, rectvalue = 0; end;

r = x; r(find(r<0)) = rectvalue; 

