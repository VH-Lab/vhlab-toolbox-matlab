function dg = double_gauss_180(x, parameters)
% DOUBLE_GAUSS - Double gaussian function
% Computes a double gaussian function 
%
% DG = DOUBLE_GAUSS(X, PARAMETERS)
%
% DG=Rsp+Rp*EXP(-(X-Op)^2)/(2*sig^2))+Rn*EXP(-(X-Op+180)^2/(2*sig^2))
%
% PARAMETERS = [Rsp Rp Op sig Rn]
% 
% parameters correspond to Carrandini fit parameters where
% Rsp=offset,Rp=peak parameter of first gaussian, 0p=location of first
% peak, sig=width parameter, Rn=peak parameter of second gaussian
% and takes the angle difference between the first peak and second peak

Rsp = parameters(1);
Rp = parameters(2);
Op = parameters(3);
sig = parameters(4);
Rn = parameters(5);

dg = Rsp+Rp*exp(-angdiff(Op-x).^2/(2*sig^2))+Rn*exp(-angdiff(180+Op-x).^2/(2*sig^2));
dg = reshape(dg, size(x));
