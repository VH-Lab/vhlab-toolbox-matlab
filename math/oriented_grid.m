function ori = oriented_grid(Xsize, Ysize, phase, orientation, spatialFreq)

% ORIENTED_GRID Create an oriented sinwave on a grid
%
%  ORI = ORIENTED_GRID(XSIZE, YSIZE, SPATIALPHASE, ORIENTATION, SPATIALFREQ)
%
%  This will create an oriented sinwave grating pattern on
%  a grid of size XSIZE x YSIZE with the given spatial phase
%  SPATIALPHASE and orientation ORIENTATION (in degrees) with
%  spatial frequency SPATIALFREQ.

angle = orientation * pi/180; % convert to radians

[X,Y] = meshgrid(1:Xsize,1:Ysize);

a=cos(angle)*spatialFreq;
b=sin(angle)*spatialFreq;

ori = sin(a*X+b*Y+phase);

