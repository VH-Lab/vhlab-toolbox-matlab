function cv = compute_dircircularvariance( angles, rates )

% vlt.neuro.vision.oridir.index.compute_dircircularvariance
%     CV = vlt.neuro.vision.oridir.index.compute_dircircularvariance( ANGLES, RATES )
%
%     Takes ANGLES in degrees. ANGLES and RATES should be
%     row vectors.
%
% CV = 1 - |R|
% R = (RATES * EXP(I*ANGLES)') / SUM(RATES)
%
% See Ringach et al. J.Neurosci. 2002 22:5639-5651

angles = angles/360*2*pi;
r = (rates * exp(i*angles)') / sum(abs(rates));
cv = 1-abs(r);
cv=round(100*cv)/100;
