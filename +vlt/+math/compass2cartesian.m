function r = compass2cartesian(c, useradians)

% vlt.math.compass2cartesian - Convert angles from compass to cartesian
%
%  R = vlt.math.compass2cartesian(C, USERADIANS)
%  
%  Converts angles from compass format to cartesian.
%  In compass, 0 degrees is up, and angles rotate clockwise.
%  In cartesian, 0 degrees is rightward, and angles rotate
%  counterclockwise.
%
%  If USERADIANS is 1, radians are used; otherwise, 
%  degrees are used.
%  

if useradians, shift = -pi/2; else, shift = -90; end;

r = -(c + shift);
