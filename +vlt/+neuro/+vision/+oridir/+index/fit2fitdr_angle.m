function tdr = fit2fitdr_angle(fitparams, blank, theangle)

% vlt.neuro.vision.oridir.index.fit2fitdr_angle - Direction ratio (fraction of response in certain direction) from double gaussian fit
%
%  TDR = vlt.neuro.vision.oridir.index.fit2fitdr_angle(FITPARAMS, BLANKRESP, THEANGLE)
%
%  Computes the "direction ratio", or the fraction of the total response
%  that is in the given angle compared to the opposite angle.
%
%  FITPARAMS is a 5-value vector describing a double gaussian fit to a
%  direction tuning curve (FITPARAMS(1) is offset, FITPARAMS(2) is weight
%  of first gaussian peak, FITPARAMS(3) is the peak tuning position, 
%  FITPARAMS(4) is the variance around the peak, FITPARAMS(%) is the
%  weight of the 'null' direction peak):
%  Resp = -BLANK + fitparams(1)+...
%    fitparams(2)*exp(-vlt.math.angdiff(fitparams(3)-angs).^2/(2*fitparams(4)^2)) +...
%    fitparams(5)*exp(-vlt.math.angdiff(fitparams(3)+180-angs).^2/(2*fitparams(4)^2));
% 
%  The formula is TDR = Resp(THEANGLE)/ 
%                        (Resp(THEANGLE)+Resp(THEANGLE+180))
%
%  See also: vlt.fit.otfit_carandini, vlt.neuro.vision.oridir.index.fit2fitoi, vlt.neuro.vision.oridir.index.fit2fitdibr


angs = 0:359;

R=fitparams(1)+...
   fitparams(2)*exp(-vlt.math.angdiff(fitparams(3)-angs).^2/(2*fitparams(4)^2)) +...
   fitparams(5)*exp(-vlt.math.angdiff(fitparams(3)+180-angs).^2/(2*fitparams(4)^2));

OtPi = vlt.data.findclosest(0:359,theangle);
OtNi = vlt.data.findclosest(0:359,mod(theangle+180,360));

Rang = max(R(OtPi)-blank,0);
Ropp = max(R(OtNi)-blank,0);

tdr = Rang/(Rang+Ropp);

