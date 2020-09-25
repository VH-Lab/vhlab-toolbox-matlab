function d = dirstrip(ds)

%  D = DIRSTRIP(DS)
%
%  Removes '.' and '..' from a directory structure returned by the function
%  "DIR". Also removes '.DS_Store' (Apple desktop information) and '.git' (GitHub)
%  from the list.
%
%  This will return all file names, including regular files. To return only
%  directories, see DIRLIST_TRIMDOTS.
%
%  See also: DIR, DIRLIST_TRIMDOTS

g = {ds.name};
[B,I] = setdiff(g,{'.','..','.DS_Store','.git'});
d = ds(I);
