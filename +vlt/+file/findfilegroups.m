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
%  SearchParent (1)            | Should we search the parent?
%  SearchDepth (Inf)           | How many directories 'deep' should we search?
%                              |   0 means parent only, 1 means one folder in, ...
%
%  Examples:
%
%      ffg_prefix = [userpath filesep 'tools' filesep 'vhlab-toolbox-matlab' ...
%		filesep 'file' filesep 'test_dirs' filesep]; % location of test directories
%
%      % finds all files with '.ext' extension.
%      fileparameters = {'.*\.ext\>'};
%      filelist = vlt.file.findfilegroups([ffg_prefix 'findfilegroupstest1'],fileparameters);
%      % list all files to see which subset(s) was(were) selected:
%      dir(([ffg_prefix 'findfilegroupstest1' filesep '**/*']))
%
%      % finds all sets of files 'myfile.ext1' and 'myfile.ext2' when these files
%      % co-occur in the same subdirectory of PARENTDIR
%      fileparameters = {'myfile.ext1','myfile.ext2'}; % finds all sets of files
%      filelist = vlt.file.findfilegroups([ffg_prefix 'findfilegroupstest2'],fileparameters);
%      dir(([ffg_prefix 'findfilegroupstest2' filesep '**/*']))
%                    
%      % finds all sets of files 'myfile_#.ext1' and 'myfile_#.ext2', where # is 
%      % the same string, and when these files co-occur in the same subdirectory.
%      % For example, if the files 'stimtimes1.txt' and 'reference1.txt' were in the same
%      % subdirectory, these would be returned together.
%      fileparameters = {'myfile_#.ext1','myfile_#.ext2'}
%      filelist = vlt.file.findfilegroups([ffg_prefix 'findfilegroupstest3'],fileparameters);
%      dir(([ffg_prefix 'findfilegroupstest3' filesep '**/*']))
%
%  See also: VLT.STRING.STRCMP_SUBSTITUTE

SameStringSearchSymbol = '#';
UseSameStringSearchSymbol = 1;
SearchParentFirst = 1;
SearchDepth = Inf;
SearchParent = 1;

vlt.data.assign(varargin{:});

filelist = {};

if SearchDepth < 0, return; end; % we're done if we've exceeded search depth

d = vlt.file.dirstrip(dir(parentdir));

subdirs = find([d.isdir]);
regularfiles = find(~[d.isdir]);

if ~SearchParentFirst,
	for i=subdirs,
		filelist = cat(1,filelist,vlt.file.findfilegroups([parentdir filesep d(i).name], ...
			fileparameters, varargin{:},'SearchParent',1));
	end;
end;

 % now look in this directory, if we are supposed to

if SearchParent,

	   % could be many groups of matches in the directory, find all potential lists

	filelist_potential = vlt.data.emptystruct('searchString','filelist');

	   % in order for a file group to pass, we have to find potential passing matches to the first criterion

	s2 = {d(regularfiles).name}';

	[tf, match_string, searchString] = vlt.string.strcmp_substitution(fileparameters{1}, s2, ...
		'SubstituteStringSymbol', SameStringSearchSymbol, 'UseSubstiteString',UseSameStringSearchSymbol);
	tf = tf(:);
	match_string = match_string(:);
	searchString = searchString(:);

	indexes = find(tf);
	for i=1:length(indexes),
		matchpotential.searchString = searchString{indexes(i)};
		matchpotential.filelist = {match_string{indexes(i)}};
		filelist_potential(end+1) = matchpotential;
	end;

	for k=2:length(fileparameters),
		new_filelist_potential = vlt.data.emptystruct('searchString','filelist'); % we will add to this list
		for j=1:length(filelist_potential),
			[tf,match_string,newSearchString] = vlt.string.strcmp_substitution(fileparameters{k}, s2, ...
				'SubstituteStringSymbol', SameStringSearchSymbol, 'UseSubstiteString',UseSameStringSearchSymbol,...
				'SubstituteString',filelist_potential(j).searchString);

			indexes = find(tf);

			for i=1:length(indexes),
				if isempty(filelist_potential(j).searchString),
					matchpotential.searchString = newSearchString;
				else,
					matchpotential.searchString = filelist_potential(j).searchString;
				end;
				matchpotential.filelist = cat(1,filelist_potential(j).filelist,{match_string{indexes(i)}});
				new_filelist_potential(end+1) = matchpotential;
			end;
		end;

		filelist_potential = new_filelist_potential;

		if isempty(filelist_potential), break; end; % no matches possible anymore
	end;

	 % now we have scanned everything, report the file groups

	for j=1:length(filelist_potential),
		myfilelist = {};
		for k=1:length(filelist_potential(j).filelist),
			myfilelist{end+1} = [parentdir filesep filelist_potential(j).filelist{k}];
		end;
		filelist{end+1} = myfilelist(:); % columns
	end;

end
 % now search subdirs if we haven't already

filelist = filelist(:); % columns

if SearchParentFirst,  % now that we've searched the parent, we need to search the subdirs
	for i=subdirs,
		filelist = cat(1,filelist,vlt.file.findfilegroups([parentdir filesep d(i).name], ...
			fileparameters, varargin{:},'SearchDepth',SearchDepth-1,'SearchParent',1));
	end;
end;

