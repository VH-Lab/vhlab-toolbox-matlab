function [meanangle, dispersion] = rotated_oripref_stats(ori_pref, reference_angle)
% ROTATED_ORIPREF_STATS - compute mean and dispersion of a set of orientation angle preferences with respect to a reference angle
%
% [MEANANGLE,DISPERSION] = vlt.neuro.vision.oridir.rotated_oripref_stats(ORI_PREF, REFERENCE_ANGLE)
%
% Given a vector of ORI_PREF values (can be in 0..360 but will be converted to 0..180 with MOD)
% and a REFERENCE_ANGLE that defines '0' (can be in 0..360 but will be converted to 0..180 with MOD)
% returns the mean angle MEANANGLE and the DISPERSION, calculated as the circular variance (CIRC_VAR).
%
% 

ori_pref = mod(ori_pref,180); % go to 0..180 to get out of direction space
ref_angle = mod(reference_angle,180); % make sure in orientation space

ori_pref_rotated = vlt.math.angdiffwrapsign(ori_pref - ref_angle, 180);

ori_pref2 = 2*ori_pref_rotated; % now stretch ori space to 0..360, doubled orientation space

mu = circ_mean(vlt.math.deg2rad(ori_pref_rotated(:)));  % in 0..360, doubled orientation space

meanangle = vlt.math.rad2deg(mu); % wrap back to 0..180

dispersion = vlt.math.rad2deg(max(circ_std(vlt.math.deg2rad(ori_pref2(:))),0));  % deal with round-off

