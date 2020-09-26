function table = packagenamereplacementtable(minfo, toolboxprefix, packageprefix)
% PACKAGENAMEREPLACEMENTTABLE - create a replacement name table from MFILEDIRINFO structures
%
% REPLACEMENTTABLE = PACKAGENAMEREPLACEMENTTABLE(MINFO, TOOLBOXPREFIX, PACKAGEPREFIX)
%
% Built a search/replace table to replace naked function names with 
% package-linked function names.
%
% 

table = vlt.data.emptystruct('original','replacement');

for m=1:numel(minfo),
	t_here.original = minfo(m).name;
	[p,f,e] = fileparts(minfo(m).fullfile);
	r = strrep([p filesep f],toolboxprefix,packageprefix);
	r(find(r==filesep)) = '.';
	t_here.replacement = r;
	table(end+1) = t_here;
end;
