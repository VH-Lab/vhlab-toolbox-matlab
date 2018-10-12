function str = struct2str(thestruct, varargin)
% STRUCT2STR - Create a short text string to summarize a structure
%
%  STR = STRUCT2STR(THESTRUCT)
%
%  Produces a string representation of a structure.  Character strings
%  are written directly, integers are written using INT2STR, and 
%  numbers are written using NUM2STR.  Any other objects are written
%  using the function DISP.
%
%  If a single structure element is passed as THESTRUCT, then a
%  single string is returned.  If an array or matrix of structure
%  elements is passed, then a cell array/matrix of strings is returned.
%  One can force the routine to return a cell array in the case of a 
%  a single structure with the 'forcecell' option below.
%
%  This is useful for displaying a structure in a listbox or for
%  writing the structure to a file as text.
%
%  The default parameters may be overridden by passing NAME/VALUE
%  pairs as additional arguments, as in:
%
%   STR = STRUCT2STR(THESTRUCT, 'NAME1', VALUE1,...)
%
%  Parameters:             | Description
%  ---------------------------------------------------------------
%  separator               | The separator between fields (default ' : ')
%  forcecell               | Should STR be a cell array of strings even if
%                          |    a single structure element is used as THESTRUCT
%                          |    (Default 0, can be 1)
%  headerrow               | Should we have a header row? (Default 0, can be 1)
%                          |    In this case STR is always returned as a 
%                          |    cell array of strings
%  precision               | Precision we should use for mat2str (default 15)
%                          |    (this is the number of digits we should use)
%                      
%
% See also: STRUCT2CHAR, CHAR2STRUCT, MLSTR2VAR
%

  % extra options someone might want to add: 
  %    ignorefields  -- ignore certain field names
  %    or includeonly -- only include certain field names

separator = ' : ';
forcecell = 0;
headerrow = 0;
precision = 15;

assign(varargin{:});

str = {};

fn = fieldnames(thestruct);

for i=1:numel(thestruct),
	str{i} = [];
	for j=1:length(fn),
		value = getfield(thestruct(i),fn{j});
		if ischar(value),
			valuestr = value;
		elseif isint(value),
			valuestr = int2str(value);
		elseif isnumeric(value),
			valuestr = mat2str(value,precision);
		else,
			valuestr = disp(value);
		end;
		str{i} = cat(2,str{i},valuestr);
		if j~=length(fn),
			str{i} = cat(2,str{i},separator);
		end;
	end;
end;

if numel(thestruct)==1 & ~forcecell & ~headerrow
	str = str{1};
end;

if headerrow,
	headerstr = [];
	for j=1:length(fn),
		headerstr = cat(2,headerstr,fn{j});
		if j~=length(fn),
			headerstr = cat(2,headerstr,separator);
		end;
	end;
	str = { headerstr str{:} };
else,
	if iscell(str),
		str = reshape(str,size(thestruct));
	end;
end;


