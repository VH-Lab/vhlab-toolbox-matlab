function b = matrow2cell(a)
% MATROW2CELL - Convert a matrix to a cell array with each row as a cell
% 
% B = vlt.data.matrow2cell(A)
%
% Given a matrix A, a cell array B is created such that the entries of 
% B{i} are the ith rows of A.
%
%   If A is a cell array, then no action is taken and B = A.
%
%   This can be useful when working with data from sources like JSON, where
%   uniformly-sized arrays may be represented as a matrix instead of a cell
%   array.
%
%   Example:
%       A = [1 2; 3 4];
%       B = vlt.data.matrow2cell(A);
%       % B will be {[1 2], [3 4]}
%
%   See also: MAT2CELL, NUM2CELL
%

if iscell(a),
	b = a;
	return;
end;

b = {};
for i=1:size(a,1),
	b{i} = a(i,:);
end;

