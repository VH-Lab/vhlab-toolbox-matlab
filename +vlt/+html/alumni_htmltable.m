function str = ugalumni_htmltable(faceinfo, varargin)
% FACEBOOK_HTMLTABLE - make a table of faces and names for VHlab website
%
% STR = UGALUMNI_HTMLTABLE(FACEINFO, ...)
%
% Takes as input a STRUCT FACEINFO that has fields 'imagefile' and 'name'
% and generates an html output table (in a cell array of strings) in STR.
% 
% This function also takes name/value pairs that modify its behavior:
% Parameter (default value)    | Description
% ----------------------------------------------------------------
% Ncols (3)                    | Number of columns
% imagewidth (200)             | Image width, in pixels
% nametablestylestring         |    Style of the name table entries 
%   ('style="text-align: center; vertical-align:top; width:200px;font-size:100%;"')  | 
% nametableprefix              | Prefix formatting for name table entries
%  ('<font face="veranda, sans-serif"><b>')      | 
% nametablepostfix             | Postfix formatting for name table entries
%  ('</b></font>')             |
% tableidstr ('')              | If using a style, could be ' id="facebooktable"' for example
%
% We use this to generate the undergraduate alumni portion of 
% vhlab.org/people
% 
% See also: CELLSTR2TEXT, NAMEVALUEPAIR
%

image_width = 200;
Ncols = 3;
nametablestylestring = 'style="text-align: center; vertical-align: top; width:200px;font-size:100%;"';
nametableprefix = '<font face="veranda, sans-serif"><b>';
nametablepostfix = '</b></font>';
tableidstr= '';
addtitle = 0;

assign(varargin{:});

str = {};

str{end+1} = ['<table ' tableidstr '>'];

Nrows = ceil(numel(faceinfo)/3);

for n=1:Nrows,

	for r=1:2,
		str{end+1} = ['   <tr>'];
		for c = 1:Ncols,
			entry = (n-1)*Ncols+c;
			if numel(faceinfo) >= entry,
				str{end+1} = ['      <td ' nametablestylestring '>'];

				if r==1,
					str{end+1} = ['      <img src="' faceinfo(entry).imagefile '" alt="' faceinfo(entry).name '" width=' int2str(image_width) 'px>' ];
				elseif r==2,
					namelink_prefix = '';
					namelink_postfix = '';
					if isfield(faceinfo,'namelink'),
						if ~isempty(faceinfo(entry).namelink),
							namelink_prefix = ['<a href="' faceinfo(entry).namelink '" target="_blank">'];
							namelink_postfix = ['</a>'];
						end;
					end;
					titlestr = '';
					if addtitle&isfield(faceinfo,'title'),
						titlestr = ['<br>' faceinfo(entry).title];
						if isfield(faceinfo,'Years'),
							%faceinfo(entry).Years,
							%numel(faceinfo(entry).Years),
							if ~isempty(strtrim(faceinfo(entry).Years)),
								titlestr = [titlestr ' (' faceinfo(entry).Years(2:end) ')'];
							end
						end
					end
					str{end+1} = ['      ' ...
						nametableprefix ...
						namelink_prefix ...
						faceinfo(entry).name ...
						namelink_postfix ... 
						titlestr ...
						nametablepostfix  ];
				end

				str{end+1} = ['      </td>'];
			end
		end

		str{end+1} = ['   </tr>'];
	end

end

str{end+1} = '</table>';

