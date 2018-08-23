function fileList = getAllFiles(dirName)
% GETALLFILES - Get all files (including those in subdirectories) of a given directory
%
%   FILELIST = GETALLFILES(DIRNAME)
%
% Returns the full path file names of all files under the directory DIRNAME.
% Files '.' and '..' are not returned.
%
%
% See also: DIR
%
% By Ziqi Wang  



  dirData = dir(dirName);      %# Get the data for the current directory
  dirIndex = [dirData.isdir];  %# Find the index for directories
  fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
  if ~isempty(fileList)
    fileList = strcat(dirName,filesep,fileList); %# Prepend path to files
  end
  subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
  validIndex = ~ismember(subDirs,{'.','..'});  %# Find index of subdirectories
                                                 %#   that are not '.' or '..'
  for iDir = find(validIndex)                  %# Loop over valid subdirectories
    nextDir = fullfile(dirName,subDirs{iDir});    %# Get the subdirectory path
    fileList = [fileList; getAllFiles(nextDir)];  %# Recursively call getAllFiles
  end

end
