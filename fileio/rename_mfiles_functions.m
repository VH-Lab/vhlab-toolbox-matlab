function rename_mfiles_functions(mfiledirs, editmfiledirs, varargin)
% RENAME_MFILES_FUNCTIONS - Rename mfiles and function names
%
% RENAME_MFILES_FUNCTIONS(MFILEDIRS, EDITMFILEDIRS, ...)
%
% This function traverses the directory (and all subdirectories) MFILEDIRS and identifies all
% .m files. If any file name renaming parameters (see below) are specified, then the .m files 
% are renamed, and any text within the files that refers to the filename is edited to match the new
% name. The function then traverses the directory EDITMFILEDIRS and any of its subdirectories, looking
% for text occurrences of the renamed functions, which are replaced with the new values.
% 
%
% This file also accepts name/value pairs that specify file renaming parameters:
% Parameter (default)           | Description
% ---------------------------------------------------------------------------------
% dirstrings_to_exclude         | Directories whose name contains these strings will be ignored
%     {'.git','archived_code'}  | 
% 
%
% See also: NAMEVALUEPAIR


 % initialize variables

dirstrings_to_exclude = {'.git', 'archived_code'};

assign(varargin{:});

mfiledirlist = pathstr2cellarray(genpath(mfiledirs));
editmfiledirlist = pathstr2cellarray(genpath(editmfiledirs));

 % remove excluded directories

for i=1:numel(dirstrings_to_exclude),
	matches = strfind(mfiledirlist,dirstrings_to_exclude{i});
	inds = find(isempty_cell(matches)); % find indexes of all matches
	mfiledirlist = mfiledirlist(inds);

	matches = strfind(editmfiledirlist,dirstrings_to_exclude{i});
	inds = find(isempty_cell(matches)); % find indexes of all matches
	editmfiledirlist = editmfiledirlist(inds);
end;

editmfiledirlist = setdiff(editmfiledirlist,mfiledirlist);

 % now traverse directory list

sublist = {};

for i=1:numel(mfiledirlist),
	d = dir([mfiledirlist{i} filesep '*.m']);
	for j=1:length(d),
		d(i).name,
		sublist{end+1}{1} = d(i).name;
		sublist{end}{2} = d(i).name; % substitited name
	end
end

editmfiledirlist = cat(1,mfiledirlist(:),editmfiledirlist(:));

for i=1:numel(editmfiledirlist),
	for j=1:size(sublist,1),
		if 1 | ~strcmp(sublist{j}{1},sublist{j}{2}), % make sure there is something to do
			opstr = ['searchreplacefiles_shell(' editmfiledirlist{i} ', ' sublist{j}{1} ', ' sublist{j}{2} ');'],
			if ~strcmp(upper(sublist{j}{1}),sublist{j}{1}),
				opstr = ['searchreplacefiles_shell(' editmfiledirlist{i} ', ' upper(sublist{j}{1}) ', ' upper(sublist{j}{2}) ');'],
			end
		end
	end
end


