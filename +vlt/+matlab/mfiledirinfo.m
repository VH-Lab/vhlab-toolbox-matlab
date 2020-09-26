function minfo = mfiledirinfo(dirname, varargin)
% MFILEDIRINFO - return m-file info for all files in a directory recursively
% 
% MINFO = MFILEDIRINFO(DIRNAME, ...)
%
% Traveres all the m files in DIRNAME and all subdirectories and collects 
% the same information as vlt.matlab.mfileinfo().
%
% This function takes extra parameters as name/value pairs:
% Parameter (default)         | Description
% ----------------------------------------------------------------------
% IgnorePackages (1)          | 0/1; should we ignore package directories that
%                             |   begin with a '+' ?
% IgnoreClassDirs (1)         | 0/1: should we ignore class directories that
%                             |   begin with a '@' ?
%
% 
% See also: vlt.matlab.mfileinfo(), vlt.data.namevaluepair()
%
% Example:
%   dirname = '/Users/vanhoosr/Documents/matlab/tools/vhlab-toolbox-matlab';
%   m=vlt.matlab.mfiledirinfo(dirname);
%

IgnorePackages = 1;
IgnoreClassDirs = 1;

vlt.data.assign(varargin{:});

minfo = [];

d = dir(dirname);

d = vlt.file.dirlist_trimdots(d, 1);

for i=1:numel(d),
	if d(i).isdir, % a directory
		if IgnorePackages & d(i).name(1)=='+', % ignore
			continue; % go to next i
		end;
		if IgnoreClassDirs & d(i).name(1)=='@', % ignore
			continue; % go to next i
		end;
		minfo_d = vlt.matlab.mfiledirinfo([dirname filesep d(i).name]);
		if isempty(minfo),
			minfo = minfo_d;
		else,
			minfo = [minfo(:); minfo_d(:)];
		end;
	else, % a file
		[p,f,e] = fileparts(d(i).name);
		if strcmp(e,'.m'), % if we have a .m file, check it out
			minfo_f = vlt.matlab.mfileinfo([dirname filesep d(i).name]);
			if isempty(minfo),
				minfo = minfo_f;
			else,
				minfo(end+1,:) = minfo_f;
			end;
		end;
	end;
end;

