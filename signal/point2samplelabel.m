function s = point2samplelabel(ti, dt)
% POINT2SAMPLE - Convert a continuous point to a sample number for regularly sampled data
%
%  S = POINT2SAMPLELABEL(TI, DT)
%
%  Given an array of time values TI, returns the closest sample
%  for a signal that is regularly sampled at interval DT.
%  The closest sample number is determined by rounding.
%  Samples are assumed to be numbered as S = N*DT (Notice that
%  these sample labels can be negative or 0).
%
%  Example:
%    dt = 0.001;
%    T = 0:dt:40;
%    S = point2samplelabel(T(20),dt)   % returns 20
%    

s = round(ti/dt);
