function [newsimpletable, newcategorylist] = simpletable(oldsimpletable,oldcategories,this_entry,this_categories)
% SIMPLETABLE - Simple X/Y numeric table
%
%   [NEWSIMPLETABLE,NEWCATEGORYLABELS] = vlt.data.simpletable(OLDSIMPLETABLE,...
%        OLDCATEGORIES, THIS_ENTRY, THIS_CATEGORIES)
%
%   Builds a simple row-based table of data values for specified numerical categories.
%   The function takes an existing table (OLDSIMPLETABLE) with numeric categories
%   listed in OLDCATEGORIES, and adds a row THIS_ENTRY with a possibly different
%   set of numeric categories THIS_CATEGORIES.
%
%   If the catogories being added do not exist, then these entries are
%   added to NEWCATEGORYLABELS and the preceding entries are filled with NaN
%   for that category.
%
%   At the end of the function, the table is sorted in ascending order
%   by NEWCATEGORYLABELS.
%
%   Notes: OLDCATEGORIES and THIS_CATEGORIES must each contain no repeats
%   (the same number can appear in both variables, but cannot appear twice in either).
%
%   Example: 
%       oldcategories = [ 0:pi/2:2*pi ];
%       oldsimpletable = [ 1:5 ];
%       X2 = [ 0:pi/4:2*pi];
%       Y2 = [ 1:0.5:5 ] + 5;
%       [newtable,newcats] = vlt.data.simpletable(oldsimpletable,oldcategories,Y2,X2),
%
%   See also: TABLE

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

