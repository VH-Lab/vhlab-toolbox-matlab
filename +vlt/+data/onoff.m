function str = onoff(b)

% vlt.data.onoff  - Returns 'on' or 'off'
%
% STR = vlt.data.onoff(B)
%
% If B<=0, STR = 'off', else, STR = 'on'
%

if b<=0, str = 'off'; else, str = 'on'; end;
