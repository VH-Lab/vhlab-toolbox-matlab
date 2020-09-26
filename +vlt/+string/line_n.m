function [line_n_str, pos, eol_marks]=line_n(str, n, varargin)
% LINE_N - Get the Nth line of a character string
%
%  [LINE_N_STR, POS, EOL_MARKS] = vlt.string.line_n(STR, N, ...)
%
%  Returns the Nth line of a multiline string STR.
%  LINE_N_STR is the string contents of the Nth line,
%  without the end of line character.
%  The position of the beginning of the Nth line within the
%  string STR is returned in POS.
%  The function also returns all of the locations of the
%  end of line marks EOL_MARKS.
%
%  If the last character of STR is not an end-of-line, then the function
%  adds an end-of-line character to the end of the string (and this is returned
%  in EOL_MARKS).
%
%  The behavior of the function can be altered by adding
%  name/value pairs:
%  Name (default value):          | Description
%  -----------------------------------------------------------------------
%  eol (sprintf('\n'))            | End of line character, could also use '\r'
%  eol_marks ([])                 | If it is non-empty, then the program
%                                 |   skips the search for eol_marks and
%                                 |   uses the provided variable. This is useful
%                                 |   if the user is going to call vlt.string.line_n
%                                 |   many times; one can save the search time
%                                 |   in subsequent calls.   
%
%  Example:
%     str = sprintf('This is a test.\nThis is line two.\nThis is line 3.')
%     vlt.string.line_n(str,1)
%     vlt.string.line_n(str,2)
%     vlt.string.line_n(str,3)

eol_marks = [];
eol = sprintf('\n'); % newline character

vlt.data.assign(varargin{:});

if isempty(eol_marks),
	eol_marks = find(str==eol);
	if isempty(eol_marks) | (eol_marks(end)~=length(str)),
		eol_marks(end+1) = length(str)+1;
	end;
end;

if n>length(eol_marks),
	error(['Requested line ' int2str(n) ' of a string with only ' int2str(length(eol_marks)) ' lines.']);
end;

if n<1,
	error(['Line request cannot be less than 1']);
end;

if n==1,
	pos = 1;
else,
	pos = eol_marks(n-1)+1;
end;

line_n_str = str(pos:eol_marks(n)-1);
