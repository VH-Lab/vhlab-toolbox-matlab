# vlt.file.findfilegroups

  FINDFILEGROUPS - Find a group of files based on parameters
 
   FILELIST = vlt.file.findfilegroups(PARENTDIR, FILEPARAMETERS, ...)
 
   Finds groups of files based on parameters.
 
   FILEPARAMETERS should be a cell list of file name search parameters.
   These parameters can include regular expresion wildcards ('.*') and symbols
   that indicate that the same string needs to be present across files ('#').
   Searches will return matches of these groups of files in PARENTDIR and all
   of its subdirectories.
 
   FILELIST is a cell array of all of the instances of these file groups.
   That is, FILELIST{i} is the ith instance of these file groups.
   The full path file names are returned in the entries of FILELIST{i}.
   That is, FILELIST{i}{j} is the jth file in the ith instance of the file groups.
 
   The parent directory is searched first for matches, and then all subdirectories are searched.
   
   This file can be modified by passing name/value pairs:
 
   Parameter(default):         | Description:
   ----------------------------------------------------------------------
   SameStringSearchSymbol('#') | The symbol to be used to indicate the the same
                               |    string across files
   UseSameStringSearchSymbol(1)| Should we use the same string search field?
   UseLiteralCharacter(1)      | Use the LiteralCharacter
   SearchParentFirst(1)        | Should we search the parent before the subdirectories of the
                               |    parent? Otherwise, subdirectories are searched first.
   SearchParent (1)            | Should we search the parent?
   SearchDepth (Inf)           | How many directories 'deep' should we search?
                               |   0 means parent only, 1 means one folder in, ...
 
   Examples:
 
       ffg_prefix = [userpath filesep 'tools' filesep 'vhlab-toolbox-matlab' ...
 		filesep 'file' filesep 'test_dirs' filesep]; % location of test directories
 
       % finds all files with '.ext' extension.
       fileparameters = {'.*\.ext\>'};
       filelist = vlt.file.findfilegroups([ffg_prefix 'findfilegroupstest1'],fileparameters);
       % list all files to see which subset(s) was(were) selected:
       dir(([ffg_prefix 'findfilegroupstest1' filesep '**/*']))
 
       % finds all sets of files 'myfile.ext1' and 'myfile.ext2' when these files
       % co-occur in the same subdirectory of PARENTDIR
       fileparameters = {'myfile.ext1','myfile.ext2'}; % finds all sets of files
       filelist = vlt.file.findfilegroups([ffg_prefix 'findfilegroupstest2'],fileparameters);
       dir(([ffg_prefix 'findfilegroupstest2' filesep '**/*']))
                     
       % finds all sets of files 'myfile_#.ext1' and 'myfile_#.ext2', where # is 
       % the same string, and when these files co-occur in the same subdirectory.
       % For example, if the files 'stimtimes1.txt' and 'reference1.txt' were in the same
       % subdirectory, these would be returned together.
       fileparameters = {'myfile_#.ext1','myfile_#.ext2'}
       filelist = vlt.file.findfilegroups([ffg_prefix 'findfilegroupstest3'],fileparameters);
       dir(([ffg_prefix 'findfilegroupstest3' filesep '**/*']))
 
   See also: VLT.STRING.STRCMP_SUBSTITUTE
