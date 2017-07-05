function s = point2samplelabel(ti, dt, t0)
% POINT2SAMPLE - Convert a continuous point to a sample number for regularly sampled data
%
%  S = POINT2SAMPLELABEL(TI, DT, [T0])
%
%  Given an array of time values TI, returns the closest sample
%  for a signal that is regularly sampled at interval DT.
%  The closest sample number is determined by rounding.
%  Samples are assumed to be numbered as S = T0+N*DT (Notice that
%  these sample labels can be negative or 0).
%
%  T0 is the time of the first sample of the signal. If T0 is not
%  provided, it is assumed to be 0.
%
%  Example:
%    dt = 0.001;
%    T = 0:dt:40;
%    S = point2samplelabel(T(20),dt)   % returns 20
%    

if nargin<3, t0 = 0; end;

s = 1+round((ti-t0)/dt);
