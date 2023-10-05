function oiindfit = fit2fitoi(R, blank)
% FIT2FITOI - Calculate orientation index from a double gaussian fit of direction tuning curve
%
%  OIIND = FIT2FITOI(R)
%
%    Calculates the orientation selectivity index (OSI) from a double gaussian fit
%    of a direction tuning curve.
%    The OSI is defined as OSI = (Rpref - Rorth) / Rpref
%    where Rpref is the average response to the preferred direction and the opposite
%    direction (that is, the preferred orientations), and Rorth is the average
%    response to the 2 directions orthogonal to the preferred direction (that is, the
%    orthogonal orientation..
%
%    R is a 2-row vector. The first row is the directions that were evaluated by the
%    fit (e.g., [0:359] is the most common for 1 degree steps between 0 and 359), and
%    the second row is the response of the fit for each angle.
%
%    See also: OTFIT_CARANDINI, FIT2FITOI, FIT2FITDIBR  


  % the second input argument, 'blank', is left in place purely for backwards compatibility with other code

[mx,Ot] = max(R(2,:));
directions = R(1,:);

OtPi = Ot;
OtNi = findclosest(directions,mod(directions(Ot)+180,360));
OtO1i = findclosest(directions,mod(directions(Ot)+90,360));
OtO2i = findclosest(directions,mod(directions(Ot)-90,360));
R = R(2,:);
%[R(OtPi) R(OtNi) R(OtO1i) R(OtO2i)] for debugging

oiindfit = (R(OtPi)+R(OtNi)-R(OtO1i)-R(OtO2i))/(R(OtPi)+R(OtNi));
