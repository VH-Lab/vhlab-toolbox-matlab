function c = cartesian2compass(r, useradians)
% CARTESIAN2COMPASS - Convert angles from cartiesian to compass
%
%  C = CARTESIAN2COMPASS(R, USERADIANS)
%  
%  Converts angles from cartesian format to compass.
%  In compass, 0 degrees is up, and angles rotate clockwise.
%  In cartesian, 0 degrees is rightward, and angles rotate
%  counterclockwise.
%
%  If USERADIANS is 1, radians are used; otherwise, 
%  degrees are used.
%

if useradians, shift = -pi/2; else, shift = -90; end;

c = -(r + shift);
