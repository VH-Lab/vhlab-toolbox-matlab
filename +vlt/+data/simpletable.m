function [newsimpletable, newcategorylist] = simpletable(oldsimpletable,oldcategories,this_entry,this_categories)
% VLT.DATA.SIMPLETABLE - Add a row of data to a simple numeric table with dynamic categories
%
%   [NEWSIMPLETABLE, NEWCATEGORYLABELS] = vlt.data.simpletable(OLDSIMPLETABLE, ...
%       OLDCATEGORIES, THIS_ENTRY, THIS_CATEGORIES)
%
%   This function builds a simple row-based table of data values for specified
%   numerical categories. It takes an existing table (OLDSIMPLETABLE) with
%   numeric categories (column headers) listed in OLDCATEGORIES, and adds a new
%   row (THIS_ENTRY) with its own set of categories (THIS_CATEGORIES).
%
%   If any categories in THIS_CATEGORIES do not already exist in OLDCATEGORIES,
%   new columns are added to the table, and existing rows are padded with NaN.
%   The final table is sorted by category labels.
%
%   Example:
%       old_table = [1 2];
%       old_cats = [10 20];
%       new_entry = [3 4];
%       new_cats = [20 30];
%       [new_table, new_cats] = vlt.data.simpletable(old_table, old_cats, new_entry, new_cats);
%       % new_table will be [1 2 NaN; NaN 3 4], new_cats will be [10 20 30]
%
%   See also: TABLE, SORT, ISMEMBER
%

oldcategories = oldcategories(:)'; % make sure is a row
this_categories = this_categories(:)';  % make sure is a row
this_entry = this_entry(:)'; % make sure is a row

 % check for errors
if length(oldcategories) ~= length(unique(oldcategories)),
	error(['Every entry in OLDCATEGORIES must be unique.']);
end;

if length(this_categories) ~= length(unique(this_categories)),
	error(['Every entry in THIS_CATEGORIES must be unique.']);
end;

if ~vlt.data.eqlen(size(this_entry),size(this_categories)),
	error(['THIS_ENTRY and THIS_CATEGORIES must be the same size.']);
end;

 % [lia,locb] = ismember(oldcategories,this_categories); % we actually don't need to know this
[lib,loca] = ismember(this_categories,oldcategories);

loca_entries = find(loca);
unknown_entries = find(lib==0);

 % fill our new row with NaNs
newrow = NaN(1,length(oldcategories)+length(unknown_entries));

 % add in the values where we've already established the categories previously,
 % this will leave NaNs if this_category lacks any entries
newrow(loca(loca_entries)) = this_entry(loca_entries); 

 % now we just need to add the new category types and their entries

newrow(length(oldcategories)+1:length(oldcategories)+length(unknown_entries)) = this_entry(unknown_entries);
newcategorylist = [oldcategories(:)' this_categories(unknown_entries)];

newsimpletable = [oldsimpletable NaN(size(oldsimpletable,1),length(unknown_entries)) ; newrow];

 % now we reshuffle based on sorting

[newcategorylist,order] = sort(newcategorylist);
newsimpletable = newsimpletable(:,order);

