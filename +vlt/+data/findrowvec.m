function i = findrowvec(a,b)
% FINDROWVEC - finds the occurrence of a complete row in a matrix
%
% I = vlt.data.findrowvec(A,B)
%
% Given a row vector B and a matrix A that has the same number of columns as B,
% I will be all rows such that all elements of A(i,:) equal those of B.
% 

[na,ma] = size(a);
[nb,mb] = size(b);

if nb~=1,
	error(['B must be a row vector.']);
end;

if ma~=mb,
	error(['A and B must have the same number of columns.']);
end;

i = find( all(a==repmat(b,na,1), 2) );

