function r = absolute2relative(absolutepath1, absolutepath2, varargin)
% vlt.path.absolute2relative - Determine the relative path between two filenames, given two absolute names
%
% r = vlt.path.absolute2relative(absolutepath1, absolutepath2)
%
% Given two absolute paths, this function returns the relative path of path1 with respect to path2.
%
% This function takes name/value pairs that modify its default behavior:
% | Parameter                | Description                                 |
% | ------------------------ | ------------------------------------------- |
% | input_filesep ('/')      | Input file separator (consider filesep)     |
% | output_filesep ('/')     | Output file separator (usually '/' for html |
% | backdir_symbol ('..')    | Symbol for moving back one directory        |
% 
%
% **Example**:
%     r=vlt.path.absolute2relative('/Users/me/mydir1/mydir2/myfile1.m', '/Users/me/mydir3/myfile2.m')
%     % r = '../mydir1/mydir2/myfile1.m'
%

input_filesep = '/';
output_filesep = '/';
backdir_symbol = '..';

vlt.data.assign(varargin{:});

c1 = strsplit(absolutepath1,input_filesep);
c2 = strsplit(absolutepath2,input_filesep);

 % find common depth

d = 1;

while strcmp(c1{d},c2{d}) & d<numel(c1) & d<numel(c2),
	d = d+1;
end; 

depth = d-1;
c2_depth = numel(c2) - 1;

r = [ repmat([backdir_symbol output_filesep],1,c2_depth-depth) strjoin(c1(depth+1:end),output_filesep) ];


