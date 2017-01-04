function str = struct2mlstr(thestruct, varargin)
% STRUCT2MLSTR - Create a text string to fully characterize a structure
%
%  STR = STRUCT2MLSTR(THESTRUCT)
%
%  Produces a string representation of a structure that can be passed to
%  an external program to fully encapsulate the structure.  Character strings
%  are written directly, integers are written using INT2STR, 
%  numbers are written using NUM2STR, cells are written using CELL2MLSTR.
%  Any other objects are written using the function DISP.
%
%  The structure is written in the following way:
%  <STRUCT size=[X Y Z ...] fields={ 'fieldname1','fieldname2',...} data=
%       <<value1><value2>...<valuen>>
%       <<value1><value2>...<valuen>>
%  /STRUCT>
%
%  where X,Y,Z are the dimension of the structure array
%  fieldname1, fieldname2, etc. are the fieldnames of the structure, and
%  data contains the data for each struct entry, inside < and >.  Within each data,
%  values for each field separated with < and > characters.
%  /STRUCT ends the structure.
%
%  Newline characters are produced after 'data=' and after each variable entry
%  ('\n').
%
%  The default parameters may be overridden by passing NAME/VALUE
%  pairs as additional arguments, as in:
%
%   STR = STRUCT2STR(THESTRUCT, 'NAME1', VALUE1,...)
%
%  Parameters:             | Description
%  ---------------------------------------------------------------
%  precision               | Precision we should use for mat2str (default 15)
%                          |    (this is the number of digits we should use)
%  varname                 | Variable name, entered before data= line as name=
%  indent                  | Indentation (default 0)
%  indentshift             | How much to indent sub-structures (default 5)
%                      

precision = 15;
indent = 0;
indentshift = 5;
varname = '';

assign(varargin{:});

fn = fieldnames(thestruct);
sizestr = mat2str(size(thestruct));
if sizestr(1)~='[',
	sizestr = [ '[' sizestr ']' ];
end;

varstr = ' ';
if ~ischar(varname),
        error(['Variable name varname must be a character array (that is, a string).']);
end;
if ~isempty(varname),
        varstr = [' name=' 39 varname 39 ' '];
end;


str = ['<STRUCT size=' sizestr varstr ' fields=' cell2str(fn) ' data=' sprintf('\n')];

for i=1:numel(thestruct),
	str = cat(2,str,repmat(' ',1,indent+indentshift),'<');
	for j=1:length(fn),
		str = cat(2,str,'<');
		value = getfield(thestruct(i),fn{j});
		if ischar(value),
			valuestr = char([39 value 39]);
		elseif isint(value),
			valuestr = ['[' int2str(value) ']'];
		elseif isnumeric(value),
			valuestr = [ '[' mat2str(value,precision) ']'];
		elseif isstruct(value)
			valuestr = struct2mlstr(value,'indent',indent+indentshift);
		elseif iscell(value),
			valuestr = cell2mlstr(value,'indent',indent+indentshift);
		else,
			valuestr = disp(value);
		end;
		str = cat(2,str,valuestr);
		str = cat(2,str,'>');
	end;
	str = cat(2,str,'>',sprintf('\n'));
end;

str = [ str repmat(' ',1, indent) '/STRUCT>'];
