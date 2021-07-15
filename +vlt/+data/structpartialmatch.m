function c = structpartialmatch(a,b)
% STRUCTPARTIALMATCH - do the fields present in b match those in a?
%
% C = vlt.data.structpartialmatch(A,B)
%
% Given a structure A and B, returns 1 if A has all of the fields of
% B and if the value of each matching field in B has the same value in
% A.
%
% Example:
%   a=struct('a',5,'b',6);
%   b=struct('b',6);
%   c = vlt.data.structpartialmatch(a,b) % returns 1
%   b2 = struct('b',1);
%   c2 = vlt.data.structpartialmatch(a,b2) % returns 0
%   b3 = struct('alpha',5);
%   c3 = vlt.data.structpartialmatch(a,b3) % returns 0
%

if ~isstruct(a),
	error(['A must be a structure.']);
end;
if ~isstruct(b),
	error(['B must be a structure.']);
end;

fna = fieldnames(a);
fnb = fieldnames(b);

[dummy,ia,ib] = intersect(fna,fnb);
if numel(ib)~=numel(fnb),
	c = logical(0);
	% a is missing at least one field of b
	return;
end;

c = 1;
for i=1:numel(fnb),
	c = c & eqlen(getfield(a,fnb{i}),getfield(b,fnb{i}));
	if ~c,
		break;
	end;
end;

