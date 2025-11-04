function indices = find_group_indices(tbl, group_definition, category_name)
% FIND_GROUP_INDICES - Finds table rows that match a group definition.
%
%   indices = FIND_GROUP_INDICES(tbl, group_definition, category_name)
%
%   This is a helper function for the LME power analysis suite. It finds
%   the logical indices of rows in the table `tbl` that match the criteria
%   specified in `group_definition`.
%
%   The `group_definition` can be:
%   1. A STRING or CHAR: For simple, single-factor tests. The function finds
%      all rows where the column specified by `category_name` matches the string.
%   2. A STRUCT: For complex, multi-factor post-hoc tests. The function finds
%      all rows that match *all* of the field-value pairs in the struct.
%
    if isstruct(group_definition)
        % Struct-based definition for multi-factor groups
        fields = fieldnames(group_definition);
        indices = true(height(tbl), 1); % Start with all rows true
        for i = 1:numel(fields)
            field = fields{i};
            value = group_definition.(field);

            table_data = tbl.(field);

            % Sanitize strings for comparison
            if iscell(table_data)
                table_data = cellfun(@(s) strtrim(replace(s, char(160), ' ')), table_data, 'UniformOutput', false);
            elseif iscategorical(table_data)
                table_data = categorical(cellfun(@(s) strtrim(replace(s, char(160), ' ')), cellstr(table_data), 'UniformOutput', false));
            end

            if ischar(value) || isstring(value)
                value = strtrim(replace(value, char(160), ' '));
            end

            indices = indices & (table_data == value);
        end
    else
        % String-based definition for single-factor groups
        clean_group_def = strtrim(replace(group_definition, char(160), ' '));
        indices = (tbl.(category_name) == clean_group_def);
    end
end
