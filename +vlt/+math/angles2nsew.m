function d = angles2nsew(angles)
% ANGLES2NSEW - how many angles are pointing north, south, east, west (bins)?
%
% D = vlt.math.angles2nsew(ANGLES)
%
% Given ANGLES in degrees in compass coordinates (0..360), assign each angle a
% character 'n', 's', 'e', or 'w' depending upon the angle:
%
%   'n': angles in [0..45) and [315...360]
%   'e': angles in [45...135) 
%   's': angles in [135..225)
%   'w': angles in [225..315)
%
% If any ANGLES are less than 0 or greater than 360, the modulus is taken
% around 360 before calculating the major direction.
%
% See also: vlt.math.cartesian2compass, vlt.math.rad2deg
%
% Example:
%   angles = [ 0 90 180 270 ];
%   d = vlt.math.angles2nsew(angles) % 'nesw'
%

angles = mod(angles,360);

d = repmat(' ',size(angles));

indexes = find ( (angles<45) | (angles>=315) );
d(indexes) = 'n';

indexes = find ( (angles>=45) & (angles<135) );
d(indexes) = 'e';

indexes = find ( (angles>=135) & (angles<225) );
d(indexes) = 's';

indexes = find ( (angles>=225) & (angles<315) );
d(indexes) = 'w';


