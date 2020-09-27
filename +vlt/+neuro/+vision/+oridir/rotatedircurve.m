function [newcurve] = rotatedircurve(angles, responses, pref_angle_assignment, anchor_responses)
% ROTATEDIRCURVE - rotate a direction curve so that it's highest value is at a defined place
%
%  NEWCURVE = vlt.neuro.vision.oridir.rotatedircurve(ANGLES, RESPONSES, PREF_ANGLE_ASSIGNMENT)
%  
%  Rotates the direction tuning curve measured at angles ANGLES and 
%  with responses RESPONSES so that the maximum response is at PREF_ANGLE_ASSIGNMENT.
%
%  ANGLES are assumed to run from 0 .. 360.
%
%  NEWCURVE is the shifted response curve that can be plotted with the existing
%  ANGLES measurements.
%
%  The function also has a form:
%
%  NEWCURVE = vlt.neuro.vision.oridir.rotatedircurve(ANGLES, RESPONSES, PREF_ANGLE_ASSIGNMENT, ANCHOR_RESPONSES)
% 
%  That will shift the curve RESPONSES based on the responses of a different curve
%  ANCHOR_RESPONSES. This is useful, for example, for shifting the surround tuning
%  curve with respect to the responses of a center tuning curve, for example.
%
%

if nargin<4,
	anchor_responses = responses;
end;

[mx,mxloc]=max(anchor_responses);

ind = vlt.data.findclosest(angles,pref_angle_assignment);

shift = ind-mxloc;

newcurve = responses([1 + mod(-1+ [1:length(responses)] - shift, length(responses)) ]);
