function struct_out = structunique(struct_in)
% STRUCTUNIQUE - Return unique elements of a struct array
%
% STRUCT_OUT = STRUCTUNIQUE(STRUCT_IN)
%
% Returns the unique elements of a given structure array STRUCT_IN 
% in STRUCT_OUT.
% 
% Uses STRUCT/EQ to test for equality.
%
% Example:
%    A=struct('A',5,'B',6);
%    A = [A A A];
%    B = structunique(A); % B == A(1)

n = numel(struct_in);

if n>=1,
	struct_out = struct_in(1);
else,
	struct_out = [];
end

tf=[];
for i=1:n,
	tf(i) = (struct_in(i)~=struct_out);
end

if any(tf),
	struct_out = cat(1,struct_out,structunique(struct_in(find(tf))));
end

