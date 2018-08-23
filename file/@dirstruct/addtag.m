function addtag(ds, dir, tagname, value)
% ADDTAG - Add a tag to a dirstruct directory
%
%   ADDTAG(THEDIRSTRUCT, DIR, TAGNAME, VALUE)
%
%  Add a 'tag' to the directory DIR that is part of the directory
%  structure object (DIRSTRUCT) named THEDIRSTRUCT.  DIR should just be the 
%  name of the directory within THEDIRSTRUCT's path.
%
%  Tags are name/value pairs. The TAGNAME must be a valid Matlab
%  variable name. Value can be any value that can be written to a string with
%  SAVESTRUCTARRAY.
%
%  See also: GETTAG, SAVESTRUCTARRAY

wholedir = [getpathname(ds) filesep dir];
tagfilename = [wholedir filesep 'tags.txt'];
taglockfilename = [wholedir filesep 'tags-lock.txt'];

newtag = struct('tagname',tagname,'value',value);

if isvarname(tagname),
	tags = gettag(ds,dir);
	if ~isempty(tags),
		tf = find(strcmp(tagname,{tags.tagname}));
		if length(tf)>0,
			tags(tf) = newtag;
		end;
	else,
		tags = newtag;
	end;
	fid = checkout_lock_file(taglockfilename,30,1);
	if fid>0,
		saveStructArray(tagfilename,tags);
		fclose(fid);
		delete(taglockfilename);
	end;
else,
	error(['Cannot add tag with requested tagname ' tagname ' to directory ' wholedir '; the tag name is not a valid Matlab variable name.']);
end;
