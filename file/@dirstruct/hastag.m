function b = hastag(ds,dir,tagname)
% HASTAG - Returns TRUE if a given tagname is present within a directory
%
%  B = HASTAG(DS, DIR, TAGNAME)
%
%  Looks in the directory DIR that is in the DIRSTRUCT DS and returns B==1 if
%  there is a tag with tagname TAGNAME, and 0 otherwise. 
%  The tag information is stored in the file tags.txt inside DIR.

tags = gettag(ds,dir);

if ~isempty(tags),
	b = any(strcmp(tagname,{tags.tagname}));
else,
	b = 0;
end;

