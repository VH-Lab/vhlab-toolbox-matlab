function g = catCellStr(v)
%  STR = CATCELLSTR(CELLSTR)
%
%  Concatenates a list into one long string separated by spaces.  Note
%  that the list must be one-dimensional and also be made up entirely of
%  character strings.

g = [];
for i=1:length(v),
        g = [ g ' ' char(v(i)) ];
end;
