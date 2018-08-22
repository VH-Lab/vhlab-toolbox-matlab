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
% Ncols (3)                    | Number of columns
% imagewidth (200)             | Image width, in pixels
% 
%
% See also: CELLSTR2TEXT, NAMEVALUEPAIR
%

image_width = 200;
Ncols = 3;

assign(varargin{:});

str = {};

str{end+1} = ['<table id="facebooktable">'];

Nrows = ceil(numel(faceinfo)/3);

for n=1:Nrows,


	for r=1:2,
		str{end+1} = ['   <tr>'];
		for c = 1:3,
			entry = (n-1)*3+c;
			if numel(faceinfo) >= entry,
				str{end+1} = ['      <td>'];

				if r==1,
					str{end+1} = ['      <img src="' faceinfo(entry).imagefile '" alt="' faceinfo(entry).name '" width=' int2str(image_width) 'px>' ];
				elseif r==2,
					str{end+1} = ['      ' faceinfo(entry).name ];
				end

				str{end+1} = ['      </td>'];
			end
		end

		str{end+1} = ['   </tr>'];
	end

end

str{end+1} = '</table>';

