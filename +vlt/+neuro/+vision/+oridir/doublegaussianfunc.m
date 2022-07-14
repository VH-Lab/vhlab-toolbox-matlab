function r = doublegaussianfunc(angles, parameters)
% vlt.neuro.vision.oridir.doublegaussianfunc - compute responses for double gaussian fit
%
% R = DOUBLEGAUSIANFUNC(ANGLES, PARAMETERS)
%
% Given ANGLES in degrees, and PARAMETERS = [Rsp Rp Rn Op sig]
%
% compute R = Rsp+Rp*exp(-vlt.math.angdiff(Op-angles).^2/(2*sig^2))+Rn*exp(-vlt.math.angdiff(180+Op-angles).^2/(2*sig^2));
%

Rsp = parameters(1);
Rp = parameters(2);
Rn = parameters(3);
Op = parameters(4);
sig = parameters(5);

r = Rsp+Rp*exp(-vlt.math.angdiff(Op-angles).^2/(2*sig^2))+Rn*exp(-vlt.math.angdiff(180+Op-angles).^2/(2*sig^2));

% 
