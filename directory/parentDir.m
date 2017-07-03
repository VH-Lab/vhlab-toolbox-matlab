function pDir = parentDir(inputDir)
  % returns parent directory of input directory
  if nargin ~= 1
    disp('This function accepts only one input - the directory whose parent directory is requested');
  else
    dirParts = strsplit(inputDir, filesep);
    pDir = strjoin(dirParts(1:end-1), filesep);
  end
