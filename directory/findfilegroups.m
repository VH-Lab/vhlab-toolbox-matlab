function filelist = findfilegroups(parentdir, fileparameters, varargin)
% FINDFILEGROUPS - Find a group of files based on parameters
%
%  FILELIST = FINDFILEGROUPS(PARENTDIR, FILEPARAMETERS, ...)
%
%  Finds groups of files based on parameters.
%
%  FILEPARAMETERS should be a cell list of file name search parameters.
%  These parameters can include regular expresion wildcards ('.*') and symbols
%  that indicate that the same string needs to be present across files ('#').
%  Searches will return matches of these groups of files in PARENTDIR and all
%  of its subdirectories.
%
%  FILELIST is a cell array of all of the instances of these file groups.
%  That is, FILELIST{i} is the ith instance of these file groups.
%  The full path file names are returned in the entries of FILELIST{i}.
%  That is, FILELIST{i}{j} is the jth file in the ith instance of the file groups.
%
%  The parent directory is searched first for matches, and then all subdirectories are searched.
%  
%  This file can be modified by passing name/value pairs:
%
%  Parameter(default):         | Description:
%  ----------------------------------------------------------------------
%  SameStringSearchSymbol('#') | The symbol to be used to indicate the the same
%                              |    string across files
%  UseSameStringSearchSymbol(1)| Should we use the same string search field?
%  UseLiteralCharacter(1)      | Use the LiteralCharacter
%  SearchParentFirst(1)        | Should we search the parent before the subdirectories of the
%                              |    parent? Otherwise, subdirectories are searched first.
%
%  Examples:
%
%      % finds all files with '.ext' extension.
%      fileparameters = {'.*\.ext\>'};
%
%      % finds all sets of files 'stimtimes.txt' and 'reference.txt' when these files
%      % co-occur in the same subdirectory of PARENTDIR
%      fileparameters = {'stimtimes.txt','reference.txt'}; % finds all sets of files
%                    
%      % finds all sets of files 'stimtimes#.txt' and 'reference#.txt', where # is 
%      % the same string, and when these files co-occur in the same subdirectory.
%      % For example, if the files 'stimtimes1.txt' and 'reference1.txt' were in the same
%      % subdirectory, these would be returned together.
%      fileparameters = {'stimtimes#.txt','reference#.txt'}

SameStringSearchSymbol = '#';
UseSameStringSearchSymbol = 1;
SearchParentFirst = 1;

assign(varargin{:});

filelist = {};

d = dirstrip(dir(parentdir));

subdirs = find([d.isdir]);
regularfiles = find([~d.isdir]);

if ~SearchParentFirst,
	for i=1:subdirs,
		filelist = cat(1,filelist,findfilegroups([parentdir filesep d(i)], ...
			fileparameters, varargin{:});
	end;
end;

 % now look in this directory

   % could be many groups of matches in the directory, find all potential lists

filelist_potential = emptystruct('searchString','filelist');

   % in order for a file group to pass, we have to find potential passing matches to the first criterion

s2 = {d(regularfiles).name};

[tf, match_string, searchString] = strcmp_substitution(fileparameters{1}, s2, ...
	'SubstituteStringSymbol', SameStringSearchSymbol, 'UseSubstiteString',UseSameStringSearchSymbol);

indexes = find(tf);
for i=indexes,
	matchpotential.searchString = searchString{i};
	matchpotential.filelist = {match_string{i}};
	filelist_potential(end+1) = matchpotential;
end;

for k=2:length(fileparameters),
	new_filelist_potential = emptystruct('searchString','filelist'); % we will add to this list
	for j=1:length(filelist_potential),
		[tf,match_string,newSearchString] = strcmp_substitution(fileparameters{k}, s2, ...
			'SubstituteStringSymbol', SameStringSearchSymbol, 'UseSubstiteString',UseSameStringSearchSymbol,...
			'SubstituteString',filelist_potential(j).searchString);

		indexes = find(tf);

		for i=indexes,
			if isempty(filelist_potential(j).searchString),
				matchpotential.searchString = newSearchString;
			else,
				matchpotential.searchString = filelist_potential(j).searchString;
			end;
			matchpotential.filelist = cat(1,filelist_potential(j).filelist,{match_string{indexes}});
			new_filelist_potential(end+1) = matchpotential;
		end;
	end;

	filelist_potential = new_filelist_potential;

	if isempty(filelist_potential), break; end; % no matches possible anymore
end;

 % now we have scanned everything, report the file groups

for j=1:length(filelist_potential),
	filelist{end+1} = filelist_potential(j).filelist;
end;

 % now search subdirs if we haven't already

if SearchParentFirst,
	for i=1:subdirs,
		filelist = cat(1,filelist,findfilegroups([parentdir filesep d(i)], ...
			fileparameters, varargin{:});
	end;
end;


