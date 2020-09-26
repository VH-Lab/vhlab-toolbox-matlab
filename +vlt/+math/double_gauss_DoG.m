function z=double_gauss_DoG(theta, sf, offset, double_gauss_params, dog_params)
% DOUBLE_GAUSS_DOG - computes a double-gaussian function that is modulated
% by a difference of gaussians
%
% Z = DOUBLE_GAUSS_DOG(THETA, SF, DOUBLE_GAUSS_PARAMS, DOG_PARAMS)
% 
% THETA corresponds to angle
% SF corresponds to spatial frequency
% DOUBLE_GAUSS_PARAMS = [a b c d e]
% DOG_PARAMS = [0 a2 b2 c2 d2]
%
% See also: DOUBLE_GAUSS_180, DOG

z = offset + double_gauss_180(theta, double_gauss_params) .* dog(dog_params, sf);
