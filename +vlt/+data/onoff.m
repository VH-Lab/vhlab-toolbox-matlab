function str = onoff(b)

% VLT.DATA.ONOFF - Convert a boolean or numeric value to 'on' or 'off' string
%
%   STR = vlt.data.onoff(B)
%
%   Converts a boolean or numeric value B into a string.
%   If B is greater than 0, it returns 'on'.
%   If B is less than or equal to 0, it returns 'off'.
%
%   This is useful for setting properties of graphics objects in Matlab.
%
%   Example:
%       vlt.data.onoff(1)     % returns 'on'
%       vlt.data.onoff(0)     % returns 'off'
%       vlt.data.onoff(-5)    % returns 'off'
%
%   See also: LOGICAL
%

if b<=0, str = 'off'; else, str = 'on'; end;
