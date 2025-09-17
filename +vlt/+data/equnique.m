function out = equnique(in)
% VLT.DATA.EQUNIQUE - Find unique elements in an array using equality comparison
%
%   OUT = vlt.data.equnique(IN)
%
%   Returns the unique elements of an array IN as a column vector OUT.
%   This function uses the '==' operator (EQ) to test for equality.
%
%   This function is more general than Matlab's UNIQUE because it can operate
%   on any object that implements the '==' (EQ) function, not just cell arrays.
%   It does not perform any sorting and does not require that the elements
%   can be sorted.
%
%   Example:
%       A = [1 2 2 3 1 4];
%       B = vlt.data.equnique(A); % B will be [1; 2; 3; 4] in some order
%
%       S.a = 1; S.b = 2;
%       A = [S S S];
%       B = vlt.data.equnique(A); % B will be a single struct S
%
%   See also: UNIQUE, ISEQUALN
%

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

