function dirlist = dirlist_trimdots(dirlist, output_struct)
% DIR_TRIMDOTS - Trim strings '.' or '..' from a list of directory strings
%   
%  DIRLIST = DIRLIST_TRIMDOTS(DIRLIST_OR_DIRLISTSTRUCT, [OUTPUT_STRUCT])
%
%  When one obtains output from the MATLAB DIR function, the list sometimes
%  includes the POSIX directories '.' (an abbreviation for the current
%  directory) and '..' (an abbreviation for the parent directory). 
%  This function trims those entries from the directory list (a cell array of
%  strings) and returns all other entries.
%
%  One can also pass the direct output from the MATLAB DIR function, and
%  the directory list will be extracted.
%
%  The function stops when it has found both '.' and '..'; if these entries
%  occur more than once they will not be removed.
%
%  If the argument OUTPUT_STRUCT is present and is 1, and if
%  DIRLIST_OR_DIRLISTSTRUCT is a structure returned from the function DIR,
%  then the output will be a structure of the same type with the '.' and
%  '..' removed.
%
%  See also: DIR, DIRSTRIP
%
%  Example:
%    D=dir
%    dirnumbers=find([D.isdir]) %return indexes that correspond to directories
%    % display all of these directories
%    dirlist = {D(dirnumbers).name}
%    % now trim
%    dirlist = dirlist_trimdots(dirlist)
%

if nargin<2, output_struct = 0; end;

if isstruct(dirlist),
    
    if output_struct,
        thisdir = [];
        theparent = [];
        for i=1:length(dirlist),
            if strcmp(dirlist(i).name,'.'), 
                thisdir(end+1) = i;
            elseif strcmp(dirlist(i).name,'..'),
                theparent(end+1) = i;
            end;
        end;

        if ~isempty([thisdir theparent]),
            dirlist([thisdir theparent]) = [];
        end;
        return;
    end;
        
	dirnumbers = find([dirlist.isdir]);
	dirlist = {dirlist(dirnumbers).name};
end;

if ~iscell(dirlist),
	error(['DIRLIST must be a cell array of strings.']);
end;

thisdir = [];
theparent = [];

for i=1:length(dirlist),
	if strcmp(dirlist{i},'.'), 
		thisdir(end+1) = i;
	elseif strcmp(dirlist{i},'..'),
		theparent(end+1) = i;
	end;

	%if ~isempty(thisdir) & ~isempty(theparent)
	%	break; % assume we are done
	%end;
end;

if ~isempty([thisdir theparent]),
	dirlist([thisdir theparent]) = [];
end;
