function v = gettagvalue(ds, dir, name)
% GETTAGVALUE - Get a value of a named tag in a DIRSTRUCT directory
%
%  V = GETTAGVALUE(DS, DIR, NAME)
%
%  Returns the value of the tag with tagname NAME in directory DIR of the
%  DIRSTRUCT DS.
%
%  If there is no tag with the tagname NAME, then empty is returned.
%
%  See also: ADDTAG, GETTAG
%

v = [];

tags = gettag(ds,dir);

if ~isempty(tags),
	names = {tags.tagname};
	tf = strcmp(name,names);
	if any(tf),
		indexes = find(tf);
		v = tags(tf(1)).value; % should only be 1; select the 1st element to be sure
	end;
end; 
