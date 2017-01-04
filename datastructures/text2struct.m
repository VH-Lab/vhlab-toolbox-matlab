function S = text2struct(str, varargin)
% TEXT2STRUCT - Convert a text string to a structure
%
%   S = TEXT2STRUCT(STR)
%
% Given a full, multi-line string, converts to Matlab structures.
%
% Each line of the text string STR should have a field name,
% a colon (':') and values following. If the user wishes to specify
% a substructure, provide a '<' following the name of the substructure.
%
% Multiple structures can be specified by leaving a blank line between
% structure descriptions.
%
% If there is more than 1 struct to convert, then S is a cell list of
% all of the structures described in STR.
%
% Note: At this time, this function does not handle cell lists, which is
% too bad. Someone should add this.
%
% Example input:
% eol = sprintf('\n');                   % end of line character
% str = ['type: spiketimelistel' eol ... % indicates that the field type has a value of 'spiketimelistel'
%        'T: 0' eol ...                  % indicates that the field 'T' has a value of 0
%        'dT: 0.0001' eol ...            % indicates that the field dT has a value of 0.0001
%        'name: cell1' eol ...           % name is 'cell1'
%        'spiketimelistel: <' eol ...    % a substructure called spiketimelistel
%        'spiketimelist: 0.0001' eol ... % the field in the substructure
%        '>' eol ...                     % indicate end of substructure
%        eol ];                          % blank line ends the structure (not necessary for last structure in list)
%
% mystruct = text2struct(str);
%
% The function can be modified by the addition of name/value pairs:
% Name (default):                | Description          
% ---------------------------------------------------------------------
% WarnOnBadField (0)             | 0/1 Produce a warning when a field name
%                                |   that cannot be a Matlab field name
%                                |   is encountered.
% ErrorOnBadField (0)            | 0/1 Produce an error when a field name
%                                |   that cannot be a Matlab field name
%                                |   is encountered (otherwise that entry
%                                |   is ignored)
% BraceLeft ('<')                | The left brace character
% BraceRight ('>')               | The right brace character
% 
%   See also: CHAR2STRUCT


WarnOnBadField = 0;
ErrorOnBadField = 0;
BraceLeft = '<';
BraceRight = '>';

assign(varargin{:});

 % assume no whitespace

[dummy,dummy,eol_marks] = line_n(str,1);

bracedepth = bracelevel(str,BraceLeft,BraceRight);

linesread = 0;
S = {};
out = 1;

while linesread<length(eol_marks),
	% read a structure
	a = struct; % empty structure
	% read in a modelel
	field = '';
	value = '';

	%disp('entering big while loop')
	
	[nextline,position] = line_n(str,1+linesread,'eol_marks',eol_marks),

	while (~isempty(nextline) & linesread<length(eol_marks)), % while no end of structure mark
		disp(['nextline: ' nextline ])
		field = sscanf(nextline,'%s:');
		field = field(1:end-1);
		b = struct;
		% check for valid field name
		stillgood = 1;
		try,
			setfield(b,field,'0');
		catch,
			if ErrorOnBadField,
				error(['Encountered invalid field name ' field '.']);
			end;
			if WarnOnBadField,
				warning(['Encountered invalid field name ' field ', ignoring.']);
			end;
			stillgood = 0;
		end;
		if stillgood,
			colon = find(nextline==':');
			value_str = strtrim(nextline(colon+1:end));
			if strcmp(value_str,'<'), % indicates a substructure
				z = find(nextline=='<',1,'first');
				pos_match = bracematch(str,position+z-1,'braceleft','<','braceright','>','bracedepth',bracedepth);
				N = find(eol_marks>position+z-1,1,'first');
				%str(eol_marks(N)+1:pos_match-1),
				%double(str(eol_marks(N)+1:pos_match-1)),
				value = text2struct(str(eol_marks(N)+1:pos_match-1)),
				% now update the number of lines read
				N = find(eol_marks>pos_match-1,1,'first');
				linesread = N-1;
			elseif ~isempty(value_str), % it's a matrix or a string
				value = str2num(nextline(colon+1:end));
				if isempty(value),
					value = value_str;
				end;
			else,
				value = [];
			end;
			a = setfield(a,field,value);
		end;
		linesread = linesread + 1;
		if 1+linesread<=length(eol_marks),
			[nextline,position] = line_n(str,1+linesread,'eol_marks',eol_marks);
		else,
			nextline = '';
		end;
	end;
	S{out} = a;
	out = out + 1;

	if isempty(strtrim(nextline)),
		linesread = linesread + 1;
	end;
end;

if length(S)==1, S = S{1}; end;

%disp(['>>>Function exit']);
