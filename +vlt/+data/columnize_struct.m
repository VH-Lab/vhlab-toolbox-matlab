function s_out = columnize_struct(s_in)
% VLT.DATA.COLUMNIZE_STRUCT - Ensure all vector fields in a struct are columns
%
%   S_OUT = VLT.DATA.COLUMNIZE_STRUCT(S_IN)
%
%   Given a structure S_IN, which may contain nested structures, this function
%   returns a new structure S_OUT where all vector fields within the structure
%   and its substructures are converted to column vectors.
%
%   This is particularly useful for ensuring data consistency, for example,
%   after converting a Matlab structure to and from JSON, which may alter the
%   row/column ordering of vectors.
%
%   Example:
%       my_struct.a = [1 2 3];
%       my_struct.b.c = [4 5 6];
%       columnized_struct = vlt.data.columnize_struct(my_struct);
%       % columnized_struct.a will be [1; 2; 3]
%       % columnized_struct.b.c will be [4; 5; 6]
%
%   See also: JSONENCODE, JSONDECODE, ISCOLUMN, ISROW
%

if ~isstruct(s_in),
	error(['Input must be a struct.']);
end;

s_out = s_in(:); % columize it

f = fields(s_out);

if ~isempty(s_out)
    for i=1:numel(f),
	    v = getfield(s_out,f{i});
	    if isstruct(v),
		    s_out = setfield(s_out,f{i},vlt.data.columnize_struct(v));
        elseif isvector(v),
            s_out = setfield(s_out,f{i},v(:));
	    end;
    end;
end;
