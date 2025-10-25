function c = structdiff(a,b)
% STRUCTDIFF - Asymmetrically check if all fields and values of struct A are in struct B
%
%   C = structdiff(A, B)
%
%   Performs an asymmetric comparison to check if a struct B contains all the
%   fields of struct A, and that the values for those fields are identical.
%
%   The function returns 1 (true) if all fields present in A are also present
%   in B with the same values. It returns 0 (false) if A has fields that B
%   is missing, or if the values for any common fields are different.
%
%   Crucially, this check is one-way. Any fields that are present in B but
%   not in A are ignored. Therefore, this function can be thought of as
%   answering the question: "Is struct A a subset of struct B?"
%
%   Example:
%      a = struct('field1', 5);
%      b = struct('field1', 5, 'field2', 10);
%      c = structdiff(a, b) % returns 1 (true)
%
%      a2 = struct('field1', 5, 'field3', 20);
%      c2 = structdiff(a2, b) % returns 0 (false), because field3 is not in b
%

c = 1;
fna = fieldnames(a);
fnb = fieldnames(b);

for i=1:length(fna)
	[j,jj,ii]=intersect(fna{i},fnb);
	if ~isempty(j),
		if ~(getfield(a,fna{i})==getfield(b,fnb{ii})),
			disp(['Fields ''' fna{i} ''' differ.']);
			c = 0;
			break;
		end;
	else,
		c = 0;
		disp(['Field name ''' fna{i} ''' not present in b.']);
		break;
	end;
end;

