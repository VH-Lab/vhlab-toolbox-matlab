function tr=round2sample(ti,dt)
% ROUND2SAMPLE - Round a continuous point to the nearest sampled value for a regularly sampled signal
% 
%   TR = ROUND2SAMPLE(TI,DT)
%
%   Given a signal sampled at regular intervals DT, and given a set of time points TI,
%   calculates the closest samples TR that are multiples of DT.
%
%   Example:
%       DT = 0.001;
%       TI = 0.00100000001;
%       TR = ROUND2SAMPLE(TI, DT)   % returns 0.001

tr = point2samplelabel(ti,dt) * dt;
