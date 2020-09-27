function modelel = modelel_reset(modelel)
% MODELEL_RESET - Reset a modelel to time 0
%
%   MODELEL = vlt.neuroscience.models.modelel.modelel.modelel_reset(MODELEL)
%
%  Reset a modelel model so that all T fields
%  are starting at 0.

for i=1:length(modelel),
	modelel(i).T = 0;
end;
