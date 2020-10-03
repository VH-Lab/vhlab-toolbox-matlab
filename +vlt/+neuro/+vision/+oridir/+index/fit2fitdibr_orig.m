function di = fit2fitdibr(fitparams, blank)

angs = 0:359;

R=fitparams(1)+...
   fitparams(2)*exp(-vlt.math.angdiff(fitparams(3)-angs).^2/(2*fitparams(4)^2)) +...
   fitparams(5)*exp(-vlt.math.angdiff(fitparams(3)+180-angs).^2/(2*fitparams(4)^2));

OtPi = vlt.data.findclosest(0:359,fitparams(3));
OtNi = vlt.data.findclosest(0:359,mod(fitparams(3)+180,360));

di = (R(OtPi)-R(OtNi))/(R(OtPi)-min(R(OtNi),blank));
