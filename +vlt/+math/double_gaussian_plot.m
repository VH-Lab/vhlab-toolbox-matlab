function Z = double_gaussian_plot(P, xi, wrap)
% DOUBLE_GAUSSIAN_PLOT - calculate a double gaussian
%
% Computes responses to a double gaussian curve
%
% Z = vlt.math.double_gaussian_plot(P, XI, WRAP), where
%
% P = parameters = [offset Rp Op Sigm Rn angle_offset]
% XI are the angles to be evaluated
% and WRAP is the wrap to be performed by vlt.math.angdiffwrap (usually 360)
% 
% The curve is
%   Z = offset + Rp*exp(-(vlt.math.angdiffwrap(xi-Op,wrap).^2)/(2*Sigm*Sigm))+...
%        Rn*exp(-(vlt.math.angdiffwrap(xi-(Op+angle_offset),wrap)/(2*Sigm*Sigm)))
%

Z = P(1) + P(2)*exp(-(vlt.math.angdiffwrap(xi-P(3),wrap).^2)/(2*P(4)*P(4)))+...
	P(5)*exp(-(vlt.math.angdiffwrap(xi-(P(3)+P(6)),wrap).^2)/(2*P(4)*P(4)));
