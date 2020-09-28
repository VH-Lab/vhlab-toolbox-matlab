function [di,pref,dv] = compute_dirvecconstrainedori(angles, rates)
% COMPUTE_DIRVECCONSTRAINEDORI - Computes direction vector constrained by orientation (DVCO)
%
%   [DI,PREF,DV] = COMPUTE_DIRVECCONSTRANEDORI(ANGLES, RATES)
%
%   ANGLES and RATES should be ROW vectors.


 % Step 1 - find unit orientation vector
ot_vec = rates*transpose(exp(sqrt(-1)*2*mod(vlt.math.deg2rad(angles),pi)));
ot_vec = exp(sqrt(-1)*angle(ot_vec)/2);
ot_angle = mod(vlt.math.rad2deg(angle(ot_vec)),360);

 % Step 2 - rotate direction so that the preferred orientation is 90 degrees; find the angles to include in each way
angles_rotated = mod(90+angles - ot_angle, 360);
angles_oneway =  angles_rotated < 180;
angles_otherway = angles_rotated>=180;

if 0~=(sum(angles_oneway) + sum(angles_otherway) - length(angles_rotated)),
	disp(['vlt.neuro.vision.oridir.index.compute_dirvecconstrainedori error: it happened; we did not divide direction space evenly.']);
	keyboard;
end;

 % Step 3 - calculate the direction index
R_oneway = sum(rates.*angles_oneway);
R_otherway = sum(rates.*angles_otherway);
R_total = sum(rates);

di = (max(R_oneway,R_otherway)-min(R_oneway,R_otherway)) / max(R_oneway,R_otherway);

if R_otherway>R_oneway,
	pref = mod(ot_angle+180,360);
else,
	pref = ot_angle;
end;

dv = di*exp(sqrt(-1)*vlt.math.deg2rad(pref));
