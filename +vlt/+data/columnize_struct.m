function s_out = columnize_struct(s_in)
% vlt.data.columize_struct - turn all vector substructures into columns
%
% S_OUT = COLUMNIZE_STRUCT(S_IN)
%
% Given a structure S_IN, that potentially has structures as fields,
% return an almost equivalent structure S_OUT where all of the structure vector arrays
% are organized in columns.
%
% This function is useful because, when converting a Matlab structure to and from
% JSON using JSONENCODE and JSONDECODE, sometimes the row/column ordering of structure
% vectors is altered.
%

if ~isstruct(s_in),
	error(['Input must be a struct.']);
end;

s_out = s_in(:); % columize it

f = fields(s_out);

for i=1:numel(f),
	v = getfield(s_out,f{i});
	if isstruct(v),
		s_out = setfield(s_out,f{i},vlt.data.columnize_struct(v));
	end;
end;
 
