function [v,tz]=fulltimestamp2datevec(fulltimestamp_str)
% FULLTIMESTAMP2DATEVEC - Convert full time stamp yyyy-mm-ddTHH:MM:SS-TIMEZONE, to a date vector
%
% [V,TZ] = FULLTIMESTAMP2DATEVEC(FULLTIMESTAMP_STR)
%
% Converts a full time stamp in the format
%   yyyy-mm-ddTHH:MM:SSTIMEZONE
%
%  The date vector V has the same format as the Matlab
%  DATEVEC routine: V= [ year month day hour minute seconds]
%
%  TZ is the time zone offset from GMT (e.g., EST is GMT -5), in 
%  vector format [hour minute].
%
%  Example: 
%    fulltimestamp_str = '2013-11-27T10:35:35.0695379-05:00';
%    [V,TZ]=fulltimestamp2datevec(fulltimestamp_str)
%     
%  See also: DATEVEC, DATESTRING

v=datevec(fulltimestamp_str,'yyyy-mm-ddTHH:MM:SS');

z = find(fulltimestamp_str==':',2,'last');

second_end = find( (fulltimestamp_str(z(1)+1:end) == '-') | (fulltimestamp_str(z(1)+1:end) == '+') ,1,'last');

sign = fulltimestamp_str(z(1)+second_end)=='+';

v(6) = str2num(fulltimestamp_str(z(1)+1:z(1)+second_end-1));

tz = datevec(fulltimestamp_str(z(1)+second_end+1:end),'HH:MM');

tz = tz(4:5);
if ~sign,
	tz(1) = -tz(1);
end;


