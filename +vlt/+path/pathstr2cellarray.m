function path_cellstr = pathstr2cellarray(thepathstr, theseparator)
% PATHSTR2CELLARRAY - Convert a path string to a cell list of strings
%
%   PATH_CELLSTR = vlt.pathpathstr2cellarray
%
%   Converts the current path string to a cell list of strings in
%   PATH_CELLSTR.  
%
%   One can also use the constructions:
%       PATH_CELLSTR = vlt.pathpathstr2cellarray(PATHSTR)
%         to specify a path string other than the current PATH, or
%       PATH_CELLSTR = vlt.pathpathstr2cellarray(PATHSTR, SEPARATOR)
%         to use a path separator other than the current PATHSEP.
%    
%   Example:  Remove all paths that have 'VH_matlab_code' in them
%       path_cellstr = vlt.path.pathstr2cellarray;
%       matches = strfind(path_cellstr,'VH_matlab_code');
%       inds = find(1-vlt.data.isempty_cell(matches)); % find indexes of all matches
%       rmpath(path_cellstr(inds));
%       path_cellstr = vlt.path.pathstr2cellarray; % update the list to reflect the changes
%
%
%   See also: PATH, PATHSEP, vlt.data.isempty_cell

if nargin<1,
	pathstr = path;
else,
	pathstr = thepathstr;
end;

if nargin<2,
	sep = pathsep;
else,
	sep = theseparator;
end;

inds = [0 find(pathstr==sep)];

if inds(end)~=length(pathstr),  % make sure the last point is the point we wish to copy until
	inds(end+1) = length(pathstr)+1;
end;

path_cellstr = {};

for i=1:length(inds)-1,
	path_cellstr{i} = pathstr(inds(i)+1:inds(i+1)-1);
end;

