function modelel = modelel_reset(modelel)
% MODELEL_RESET - Reset a modelel to time 0
%
%   MODELEL = MODELEL_RESET(MODELEL)
%
%  Reset a modelel model so that all T fields
%  are starting at 0.

for i=1:length(modelel),
	modelel(i).T = 0;
end;
