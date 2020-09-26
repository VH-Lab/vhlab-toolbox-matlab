function system=curved_monitor_view(monitor_diag, aspectratio, radius, viewing_distance)
% CURVED_MONITOR_VIEW - Given the dimensions of a curved monitor, calculate the viewing angle of the animal
%
% SYSTEM = CURVED_MONITOR_VIEW(MONITOR_DIAG, ASPECTRATIO, RADIUS, VIEWING_DISTANCE)
%
% MONITOR_DIAG should be the diagonal monitor size (usually what is specified,
% multiply by 2.54 to get cm from inches).
% ASPECTRATIO should be aspect ratio of monitor (width in numerator)
% RADIUS should be the curvature of the monitor (e.g., 180 cm).
% VIEWING_DISTANCE should be the desired animal viewing distance.
%
% All angles are returned in degrees. 
% 
% SYSTEM is a structure with the following entries:
% Fieldname:           | Description:
% ------------------------------------------------------
% theta                | Viewing angle of hemifield
%                      |     (so 2*theta is whole view)
% monitor_diag         | Monitor diag (from input)
% monitor_height       | Monitor height
% monitor_width        | Monitor width (along curve)
% radius               | Radius of curvature from input
% viewing_distance     | Viewing distance from input
% alpha                | Angle from center of monitor to
% phi                  | Angle from center of monitor to line to edge of monitor
%                      |   monitor edge edge when monitor is
%                      |   viewed center-on at distance radius 
% C                    | Distance between straight view of animal 
%                      |   and edge of monitor
% P                    | Distance between monitor and location that
%                      |   makes a right angle with the edge of the monitor
% A                    | Distance between edge of monitor and point P

 % monitor dimensions

monitor_height = sqrt ( monitor_diag^2 / (1+aspectratio^2) );
monitor_width = sqrt(monitor_diag^2 - monitor_height^2);

 % alpha - 

alpha = rad2deg(2*pi*(monitor_width/2)/(2*pi*radius));



 % C - distance between straight view of animal and edge of monitor

C = 2*radius*sin(deg2rad(alpha/2));

phi = (180 - alpha)/2;

P = C*cos(deg2rad(phi));

A = sqrt(C^2-P^2);

if viewing_distance-P>0,
	theta = rad2deg(atan2(A,viewing_distance-P));
else,
	theta = rad2deg(atan2(A,viewing_distance-D));
end;

system = workspace2struct;
