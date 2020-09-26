function diindfit = fit2fitdi(R, blank)
% FIT2FITDI - direction selectivity index (DSI) from double gaussian fit of direction tuning curve
%
%  DIIND = FIT2FITDI(R)
%
%    Calculates the direction selectivity index (DSI) from a double gaussian fit
%    of a direction tuning curve.
%    The DSI is defined as DSI = (Rpref - Rnull) / Rpref
%    where Rpref is the response to the preferred direction and Rnull is the response
%    to the direction opposite to the preferred direction (that is, the null direction).
%
%    R is a 2-row vector. The first row is the directions that were evaluated by the
%    fit (e.g., [0:359] is the most common for 1 degree steps between 0 and 359), and
%    the second row is the response of the fit for each angle.
%  
%    See also: OTFIT_CARANDINI, FIT2FITOI, FIT2FITDIBR


  % the second input argument, 'blank', is left in place purely for backwards compatibility with other code

[mx,Ot] = max(R(2,:));
directions = R(1,:);

OtPi = findclosest(directions,Ot);
OtNi = findclosest(directions,mod(Ot+180,360));

R = R(2,:);
diindfit = (R(OtPi)-R(OtNi))/(R(OtPi));
