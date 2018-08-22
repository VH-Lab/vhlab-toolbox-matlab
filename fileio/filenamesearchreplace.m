function filenamesearchreplace(dirname, searchStrs, replaceStrs, varargin)
%
% FILENAMESEARCHREPLACE - Seach and replace filenames within a directory
%
% FILENAMESEARCHREPLACE(DIRNAME, SEARCHSTRS, REPLACESTRS, ...)
%
% This function searches all files in the directory DIRNAME for matches
% of any string in the cell array of strings SEARCHSTRS. If it finds a match,
% then it creates a new file with the search string replaced by the
% corresponding entry in the cell array of strings REPLACESTRS.
%
% This function (at present) only operates on regular files, not directories.
%
% This function also can be modified by name/value pairs:
% Parameter (default)      | Description
% ----------------------------------------------------------------
% deleteOriginals (0)      | Should original file be deleted?
% useOutputDir (0)         | Should we write to a different output directory?
% OutputDirPath (DIRNAME)  | The parent path of the output directory
% OutputDir ('subfolder')  | The name of the output directry in OutputDirPath
%                          |   (will be created if it doesn't exist)
% noOp (0)                 | If 1, this will not perform the operation but will
%                          |   display its intended action
%
% See also: NAMEVALUEPAIR
% 
% Example: Suppose mydirname has a file '.ext1'.
%     filenamesearchreplace(mydirname,{'.ext1'},{'.ext2'}, 'deleteOriginals', 1)
%     % renames any files with '.ext1' to have '.ext2', deleting old files
%

deleteOriginals = 0;
useOutputDir = 0;
OutputDirPath = dirname;
OutputDir = 'subfolder';
noOp = 0;

assign(varargin{:});

d = dirstrip(dir(dirname)); % trim '.' and '..' and '.DS_store'

if ~useOutputDir,
	outputPath = dirname;
else,
	outputPath = [OutputDirPath filesep OutputDir];
	if ~exist([outputPath],'dir'),
		if ~noOp,
			mkdir(outputPath);
		else,
			disp(['Would have made ' outputPath '.']);
		end
	end;
end

for i=1:numel(d),
	if ~d(i).isdir, % ignore directories for now
		tf = cellfun(@(x) contains(d(i).name,x,'IgnoreCase',true), searchStrs);
		idx = find(tf);
		if ~isempty(idx),
			idx = min(idx); % pick the first match
			newname = strrep(d(i).name,searchStrs{idx},...
				replaceStrs{idx});
			oldnamefullpath = [dirname filesep d(i).name];
			newnamefullpath = [outputPath filesep newname];
			if ~noOp,
				copyfile(oldnamefullpath, newnamefullpath);
			else,
				disp(['Would have copied ' ...
					oldnamefullpath ' to ' ...
					newnamefullpath '']);
			end
			if deleteOriginals,
				if ~noOp,
					delete([oldnamefullpath]);
				else,
					disp(['Would have deleted ' ...
						oldnamefullpath '']);
				end
			end
		end
	end
end;


