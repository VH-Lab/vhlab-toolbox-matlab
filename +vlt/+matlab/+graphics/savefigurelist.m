function savefigurelist(figlist, varargin)
% SAVEFIGURELIST - Write the current figures to disk using figure tags for file names
%
%   vlt.matlab.graphics.savefigurelist(FIGLIST, ...)
%
%   Writes all of the figures in FIGLIST to the present
%   working directory, using the 'Tag' field of each figure as its filename.
%  
%   If FIGLIST is empty, then all figures are written.
%
%   This function also accepts additional parameter name/value pairs
%     that modify its behavior:
%
%   Parameter (default) | Description
%   -----------------------------------------------------------------------
%   ErrorIfTagEmpty (1) | 0/1 Produces an error if a 'tag' field is empty.
%                       |   If 0, then a warning is given and the figure is
%                       |   skipped.
%   Formats ({'fig',... | File formats to write
%     'epsc','pdf'})    |
%
%   See also: SAVEAS, PWD

ErrorIfTagEmpty = 1;
Formats = {'fig','epsc','pdf'};

vlt.data.assign(varargin{:});     


if nargin==0,
	figlist = get(0,'children');
end;

for i=1:length(figlist),
	tagname = get(figlist(i),'tag');
	if isempty(tagname),
		if ErrorIfTagEmpty,
			error(['Tag of figure ' disp(figlist(i)) ' is empty']);
		else,
			warning(['Tag of figure ' disp(figlist(i)) ' is empty']);
		end;
	end;
	for f=1:length(Formats),
		saveas(figlist(i),tagname,Formats{f});
	end;
end;


