function d = dirstrip(ds)

%  D = vlt.file.dirstrip(DS)
%
%  Removes '.' and '..' from a directory structure returned by the function
%  "DIR". Also removes '.DS_Store' (Apple desktop information) and '.git' (GitHub)
%  from the list.
%
%  This will return all file names, including regular files. To return only
%  directories, see vlt.file.dirlist_trimdots().
%
%  See also: DIR, vlt.file.dirlist_trimdots()

g = {ds.name};
[B,I] = setdiff(g,{'.','..','.DS_Store','.git'});
d = ds(I);
