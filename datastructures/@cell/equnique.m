function out = equnique(in)
% EQUNIQUE - Return unique elements of an arbitrary class using EQ
%
% OUT = EQUNIQUE(IN)
%
% Returns the unique elements of an object array IN as a column OUT.
% 
% Uses EQ to test for equality.
%
% This function is a little more general than Matlab's UNIQUE in that it
% can operate on any object that implements an EQ function, not just CELL arrays. 
% It performs no sorting, and has no requirement that elements are ordered or sortable.
%
% Example:
%    A={ [1 2] [1] [1] [3 4 5] }
%    B = equnique(A); % B == A([1 2 4])
%
% See also: UNIQUE

n = numel(in);

if n>=1,
	out = in{1};
else,
	out = [];
end

tf=[];
for i=1:n,
	tf(i) = ~(eqlen(in{i},out));
end

if any(tf),
	out = cat(1,{out},equnique(in(find(tf))));
end

