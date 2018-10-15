function s = struct2tabstr(a)
% STRUCT2TABSTR - convert a struct to a tab-delimited string
%
% S = STRUCT2TABSTR(A)
%
% Given a Matlab STRUCT variable A, this function creates a tab-delimited 
% string with the values of the structure.
%
% Values are read from the FIELDNAMES of the structure in turn. If they are
% of type 'char', then they are added to the string S directly. Otherwise,
% they are converted using MAT2STR.
%
% See also: LOADSTRUCTARRAY, SAVESTRUCTARRAY, TABSTR2STRUCT
%
% Example:
%    a.fielda = 5;
%    a.fieldb = 'my string data';
%    s = struct2tabstr(a)
%    % convert back
%    a2 = tabstr2struct(s, {'fielda','fieldb'} )
%

fn = fieldnames(a);

s = '';

for i=1:length(fn)
	f = getfield(a,fn{i});
	if ischar(f)
		s = [s char(9) f];
    else
        try,
    		s = [s char(9) mat2str(f)];
        catch,
            error(['field not character or numeric: ' fn{i} ' is ' class(f) '.']);
        end;
	end
end

s = s(2:end);

