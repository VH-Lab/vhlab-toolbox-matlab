function [angles_ori, responses_ori] = dirspace2orispace(angles, responses)
% DIRSPACE2ORISPACE - Converts direction responses to orientation responses
%
%  [ANGLES_ORI,RESPONSES_ORI] = vlt.neuro.vision.oridir.dirspace2orispace(ANGLES, RESPONSES)
%
%  Converts direction responses and angles of stimulation into orientation space.
%
%  Each angle in ANGLES that goes around the clock in direction space (ranging
%  from 0 to 360 degrees) is converted to an orientation ranging from 0 to 180
%  degrees and returned in ANGLES_ORI.  The new ANGLES_ORI is a column vector
%  (regardless of the form of the input ANGLES).
%
%  RESPONSES_ORI(A,R) is a matrix of all RESPONSES R that map to the orientation 
%  A.  In the event that there are not an equal number of responses to each
%  orientation, extra entries in the matrix will be NaN.
%

angles_ori = unique(mod(angles(:),180));

responses_ori_cell = {};
for i=1:length(angles_ori), responses_ori_cell{i} = []; end;

maxentries = -Inf;

for i=1:length(responses),
	corresponding_angle_index = find(angles_ori==mod(angles(i),180));
	responses_ori_cell{corresponding_angle_index}(end+1) = responses(i);
	maxentries = max([maxentries length(responses_ori_cell{corresponding_angle_index})]);
end;

responses_ori = NaN(length(angles_ori),maxentries);
for i=1:length(angles_ori),
	responses_ori(i,1:length(responses_ori_cell{i})) = responses_ori_cell{i};
end;

