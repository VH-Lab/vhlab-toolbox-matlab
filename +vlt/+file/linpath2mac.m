function newpath = linpath2mac(pathname)

%  vlt.file.linpath2mac
%    Converts a Linux pathname to a Macintosh pathname.
%  
%  NEWPATH = vlt.file.linpath2mac(PATHNAME)
%
%  Replaces all '/' characters with ':' characters.

h = find(pathname=='/');
newpath = pathname; newpath(h) = ':';
