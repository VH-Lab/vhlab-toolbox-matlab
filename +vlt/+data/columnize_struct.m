function s_out = columnize_struct(s_in, options)
% vlt.data.columnize_struct - turn all vector substructures into columns
%
% S_OUT = COLUMNIZE_STRUCT(S_IN, ...)
%
% Given a structure S_IN, that potentially has structures as fields,
% return an almost equivalent structure S_OUT where all of the structure vector arrays
% are organized in columns.
%
% This function is useful because, when converting a Matlab structure to and from
% JSON using JSONENCODE and JSONDECODE, sometimes the row/column ordering of structure
% vectors is altered.
%
% Options:
%     columnizeNumericVectors (default false) - if true, any numeric vectors
%         found in the fields will be converted to column vectors.
%

arguments
    s_in struct
    options.columnizeNumericVectors (1,1) logical = false
end

s_out = s_in(:); % columnize the struct array itself

f = fieldnames(s_out);

for i = 1:numel(s_out)
    for j = 1:numel(f)
        v = s_out(i).(f{j});
        if isstruct(v)
            s_out(i).(f{j}) = vlt.data.columnize_struct(v, 'columnizeNumericVectors', options.columnizeNumericVectors);
        elseif options.columnizeNumericVectors && isnumeric(v) && isvector(v)
            s_out(i).(f{j}) = v(:);
        end
    end
end
