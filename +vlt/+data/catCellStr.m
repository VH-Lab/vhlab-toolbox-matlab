function g = catCellStr(v)
% VLT.DATA.CATCELLSTR - Concatenate a cell array of strings into a single string
%
%   STR = VLT.DATA.CATCELLSTR(CELLSTR)
%
%   Concatenates a cell array of strings into one long string separated by
%   spaces. The list must be one-dimensional and be made up entirely of
%   character strings.
%
%   Example:
%      mycell = {'hello', 'world'};
%      mystr = vlt.data.catCellStr(mycell) % mystr will be ' hello world'
%
%   See also: VLT.DATA.CELL2STR, STRCAT
%

g = [];
for i=1:length(v),
        g = [ g ' ' char(v(i)) ];
end;
