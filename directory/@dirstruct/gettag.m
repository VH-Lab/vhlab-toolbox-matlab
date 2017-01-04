function tag = gettag(ds,dir)
% GETTAG - Get tag(s) from a DIRSTRUCT directory
%
%   TAG = GETTAG(THEDIRSTRUCT, DIR)
%
%  Reads tag(s)s from the DIR directory that is located with
%  the DIRSTRUCT THEDIRSTRUCT.
%
%  Tags are name/value pairs returned in the form of a structure array
%  with fields 'name' and 'value'.  They are located in a text file
%  within the directory DIR with the filename 'tags.txt'.
%  
%  See also: ADDTAG, LOADSTRUCTARRAY
%  

wholedir = [getpathname(ds) filesep dir];
tagfilename = [wholedir filesep 'tags.txt'];

if exist(tagfilename,'file')==2,
	tag = loadStructArray(tagfilename);
else,
	tag = struct('tagname','','value','');
	tag = tag([]);
end;
