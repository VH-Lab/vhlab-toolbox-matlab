function str = facebook_htmltable(faceinfo, varargin)
% FACEBOOK_HTMLTABLE - make a table of faces and names for VHlab website
%
% STR = FACEBOOK_HTMLTABLE(FACEINFO, ...)
%
% Takes as input a STRUCT FACEINFO that has fields 'imagefile' and 'name'
% and generates an html output table (in a cell array of strings) in STR.
% 
% This function also takes name/value pairs that modify its behavior:
% Parameter (default value)    | Description
% ----------------------------------------------------------------
% table_width ('100%')         | Table width of the HTML table
% Ncols (3)                    | Number of columns
% text_weight ('bold')         | Text weight (or '' for none)
% 
%
% See also: CELLSTR2TEXT, NAMEVALUEPAIR
%

table_width = '100%';
Ncols = 3;

assign(varargin{:});

str = {};

str{end+1} = ['<table style="width:' table_width '">'];

Nrows = ceil(numel(info)/3);

for n=1:Nrows,

	str{end+1} = ['   <tr>'];

	for c = 1:3,
		entry = (n-1)*3+c;
		if numel(info) >= entry,
			str{end+1} = ['      <td>'];

			if ~isempty(text_weight),
				str{end+1} = ['      <' text_weight '>'];
			end;

			str{end+1} = ['      ' info(entry).name ];

			if ~isempty(text_weight),
				str{end+1} = ['      </' text_weight '>'];
			end

			str{end+1} = ['      </td>'];
		end
	end

	str{end+1} = ['   </tr>'];

end

str{end+1} = '</table>';
