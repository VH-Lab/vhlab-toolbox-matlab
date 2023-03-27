function fn = structfullfields(s, prefix)
% STRUCTFULLFIELDS - return full field names for structures and substructures
%
% FN = vlt.data.structfullfields(S)
%
% Returns the field names of a structure S, including substructures.
%
% For example, if a structure A has fields AA and AB, and AA is a structure
% with fields AAA and AAB, then FN is {'A.AA.AAA','A.AA.AAB','A.AB'}.
%
% Example:
%    A = struct('AA',struct('AAA',5,'AAB',7),'AB',2);
%    fn = vlt.data.structfullfields(A);

if nargin<2,
	prefix = '';
end;

if ~isstruct(s),
	error(['This function only works for structures.']);
end;

fn = fieldnames(s);
out_fn = {};

for i=1:numel(fn),
	out_fn = cat(1,out_fn,[prefix fn{i}]);
	v = getfield(s,fn{i});
	if isstruct(v),
		newfn = vlt.data.structfullfields(v,[prefix fn{i} '.']);
		out_fn = cat(1,out_fn,newfn(:));
	end;
end;

fn = out_fn;
