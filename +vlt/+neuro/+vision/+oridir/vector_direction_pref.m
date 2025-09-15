function [pref_resp, null_resp, dir_pref, ori_pref] = vector_direction_pref(angles, responses, theblankresp)
% VECTOR_DIRECTION_PREF - Determine dir preference/response w/ vector methods
%
%  [PREF_RESP, NULL_RESP, DIR_PREF, ORI_PREF] = ...
%       vlt.neuro.vision.oridir.vector_direction_pref(ANGLES, RESPONSES, [BLANK])
%
%  Calculates the preferred response PREF_RESP and the null response
%  NULL_RESP with vector methods.
%
%  First, the orientation preference is calculated using vector methods.
%  Then, the preferred and null responses are computed at the 2 directions
%  that correspond to the orientation angle indicated by the vector method.
%  The responses are computed by interpolation.
%  

if nargin>2, blank = theblankresp; else, blank = 0; end

responses_real = responses - blank;
% 
% vecresp = (responses_real*transpose(exp(sqrt(-1)*2*mod(angles*pi/180,pi))));
% vecotpref = mod(180/pi*angle(mean(vecresp)),180);
% vecotmag = abs(mean(vecresp));

angles_rad = angles * pi / 180;

% Vector average to find orientation preference
vecresp = responses_real .* exp(sqrt(-1) * 2 * angles_rad);
vecsum = sum(vecresp);
ori_pref = mod(angle(vecsum) / 2, pi); % Orientation preference in radians
ori_pref_deg = ori_pref * 180 / pi; % Convert into degrees

% Determine the two direction angles (pref and null)
dir1 = mod(ori_pref_deg, 360);
dir2 = mod(dir1 + 180, 360);  
angles_wrapped = mod(angles, 360); % Wrap angles to [0, 360) for interpolation

pref_resp = interp1(angles_wrapped, responses, dir1, 'linear', 'extrap'); % preferred
null_resp = interp1(angles_wrapped, responses, dir2, 'linear', 'extrap'); % null

if pref_resp >= null_resp
    dir_pref = dir1;
else
    % swap if null_resp is higher
    tmp = pref_resp;
    pref_resp = null_resp;
    null_resp = tmp;
    dir_pref = dir2;
end

% Orientation preference in degrees
ori_pref = ori_pref_deg;

end