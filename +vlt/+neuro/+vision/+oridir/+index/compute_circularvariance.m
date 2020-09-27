function cv = compute_circularvariance( angles, rates )

% vlt.neuroscience.vision.oridir.indexes.compute_circularvariance
%     CV = vlt.neuroscience.vision.oridir.indexes.compute_circularvariance( ANGLES, RATES )
%
%     Takes ANGLES in degrees.  ANGLES and RATES should be
%     row vectors.
%
% CV = 1 - |R|
% R = (RATES * EXP(2I*ANGLES)') / SUM(RATES)
%
% See Ringach et al. J.Neurosci. 2002 22:5639-5651

angles = angles/360*2*pi;
r = (rates * exp(2i*angles)') / sum(abs(rates));
cv = 1-abs(r);
cv=round(100*cv)/100;