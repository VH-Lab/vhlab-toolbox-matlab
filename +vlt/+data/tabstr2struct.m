function a = tabstr2struct(s,fields)
% TABSTR2STRUCT - convert a tab-separated set of strings to a STRUCT entry
%
% A = vlt.data.tabstr2struct(S, FIELDS)
%
% Given a cell array of strings FIELDS of field names, creates a STRUCT
% array where the values of each field are specified in a tab-delimited string.
%
% Each string is first examined to see if it is a number (using STR2NUM).
% If so, then the value is stored as a double. Otherwise, the value is
% stored as a string.
%
% Exceptions: 
%   a) If the string happens to have two '/' characters or has the form 'yyyy-dd-mm', then it
%      is assumed to be a date and is interpreted as a string.
% 
%   b) If the string should happen to be correspond to a non-numeric object in Matlab,
%      we assume the user wants to specify the string rather than an empty matlab 
%      type (for example, STR2NUM('struct') yields an empty structure).
%
% See also: vlt.file.loadStructArray, vlt.file.saveStructArray, DLMREAD, DLMWRITE, vlt.data.struct2tabstr
%
% Example:
%   s = ['5' char(9) 'my string data'];
%   fn = {'fielda','fieldb'};
%   a = vlt.data.tabstr2struct(s,fn)
% 

a = [];
str = [char(9) s char(9)];
pos = findstr(str,char(9));

for i=1:length(fields)
	t = str(pos(i)+1:pos(i+1)-1);

	if numel(find(t=='/')) > 1 | ~isempty(regexp(t,'(\s*)\d\d\d\d-\d\d-\d\d(\s*)')), % assume it is a date, pass as string
		u = []; 
	else,
%        if ~isempty(regexp(t, '^(-)?(\d*)(\.?)(\d*)(e^(+|-)?(\d*))?$', 'once'));
		    u = str2num(t);
		    if ~isempty(u),
			    if ~isnumeric(u),
				    u = [];
			    end
            end
%        else,
%            u = [];
%        end;
	end

	if ~isempty(u)
		a = setfield(a,fields{i},u);
	else
		a = setfield(a,fields{i},t);
	end
end


