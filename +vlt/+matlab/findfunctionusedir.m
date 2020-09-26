function fuse = findfunctionusedir(dirname, minfo, varargin)
% FINDFUNCTIONUSEDIR determine where a function is called in a directory of m-files
%
% FUSE = FINDFUNCTIONUSEDIR(DIRNAME, MINFO)
%
% Searches the directory DIRNAME for uses of a Matlab function
% described by minfo returned by vlt.matlab.mfileinfo.
%
% This function searches for instances of [MINFO.NAME]
% Note that it may identify instances in the comments, or instances where the
% user has defined their own internal function of the same name.
%
% Returns the structure described in vlt.matlab.findfunctionusefile.
%
% This function takes extra parameters as name/value pairs:
% Parameter (default)         | Description
% ----------------------------------------------------------------------
% IgnorePackages (0)          | 0/1; should we ignore package directories that
%                             |   begin with a '+' ?
% IgnoreClassDirs (0)         | 0/1: should we ignore class directories that
%                             |   begin with a '@' ?
%
% See also: vlt.matlab.mfileinfo, vlt.matlab.findfunctionusefile, vlt.data.namevaluepair
%

IgnorePackages = 0;
IgnoreClassDirs = 0;

vlt.data.assign(varargin{:});

fuse = vlt.data.emptystruct('fullfilename','name','line','character','incomments','package_class_use','allcaps');

if numel(minfo)>1,
	for j=1:numel(minfo),
		fuse = cat(1,fuse(:),vlt.matlab.findfunctionusedir(dirname,minfo(j),varargin{:}));
	end;
	return;
end;

d = dir(dirname);

d = vlt.file.dirlist_trimdots(d,1);

for i=1:numel(d),
	if d(i).isdir, % a directory
		if IgnorePackages & d(i).name(1)=='+', % ignore
			continue; % go to next i
		end;
		if IgnoreClassDirs & d(i).name(1)=='@', % ignore
			continue; % go to next i
		end;
		fuse = cat(1,fuse(:),vlt.matlab.findfunctionusedir([dirname filesep d(i).name],minfo,varargin{:}));
	else, % a file
		[p,f,e] = fileparts(d(i).name);
		if strcmp(e,'.m'), % if we have a .m file, check it out
			fuse = cat(1,fuse(:), vlt.matlab.findfunctionusefile([dirname filesep d(i).name],minfo));
		end;
	end;
end;


