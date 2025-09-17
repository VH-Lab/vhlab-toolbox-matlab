function str = cell2mlstr(thecell, varargin)
% VLT.DATA.CELL2MLSTR - Create a text string to fully characterize a cell array
%
%   STR = vlt.data.cell2mlstr(THECELL)
%
%   Produces a string representation of a cell array that can be passed to
%   an external program to fully encapsulate it. Character strings are written
%   directly, integers and numbers are written using MAT2STR, and nested cells
%   are written recursively using vlt.data.cell2mlstr. Any other objects are
%   written using the function DISP.
%
%   The cell array is written in the following format:
%   <CELL size=[X Y Z ...] data=
%        <value1>
%        <value2>
%   /CELL>
%
%   where X,Y,Z are the dimensions of the cell array, and data contains the
%   data for each cell entry, inside < and >.
%
%   The default parameters may be overridden by passing NAME/VALUE pairs as
%   additional arguments:
%
%   STR = vlt.data.cell2mlstr(THECELL, 'NAME1', VALUE1,...)
%
%   Parameters:              | Description
%   ------------------------------------------------------------------
%   precision                | Precision for mat2str (default: 15)
%   varname                  | Variable name, entered before data= line as name=
%   indent                   | Indentation (default: 0)
%   indentshift              | How much to indent sub-cells (default: 5)
%
%   Example:
%       A = {'test', 5, [3 4 5]};
%       str = vlt.data.cell2mlstr(A);
%
%   See also: MAT2STR, VLT.DATA.STRUCT2MLSTR, DISP
%

precision = 15;
indent = 0;
indentshift = 5;
varname = '';

vlt.data.assign(varargin{:});

sizestr = mat2str(size(thecell));
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

str = ['<CELL size=' sizestr varstr 'data=' sprintf('\n')];

for i=1:numel(thecell),
	str = cat(2,str,repmat(' ',1,indent+indentshift),'<');
	value = thecell{i};
	if ischar(value),
		valuestr = char([39 value 39]);
	elseif vlt.data.isint(value),
		s = mat2str(value);
        if isscalar(value), s = ['[' s ']']; end;
		valuestr = s;
	elseif isnumeric(value),
		s = mat2str(value,precision);
        if isscalar(value), s = ['[' s ']']; end;
		valuestr = s;
	elseif isstruct(value)
		valuestr = vlt.data.struct2mlstr(value,'indent',indent+indentshift);
	elseif iscell(value),
		valuestr = vlt.data.cell2mlstr(value,'indent',indent+indentshift);
	else,
		valuestr = disp(value);
	end;
	str = cat(2,str,valuestr);
	str = cat(2,str,'>',sprintf('\n'));
end;

str = [ str repmat(' ',1, indent) '/CELL>'];

