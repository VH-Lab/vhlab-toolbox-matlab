function out = equnique(in)
% EQUNIQUE - Return unique elements of an arbitrary class using EQ
%
% OUT = vlt.data.equnique(IN)
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
%    A=struct('A',5,'B',6);
%    A = [A A A];
%    B = vlt.data.equnique(A); % B == A(1)
%
% See also: UNIQUE

n = numel(in);

if n>=1,
	out = in(1);
else,
	out = [];
end

tf=[];
for i=1:n,
	tf(i) = ~isequaln(in(i),out);  % who is not equal to out
end

if any(tf),
	out = cat(1,out,vlt.data.equnique(in(find(tf))));
end

