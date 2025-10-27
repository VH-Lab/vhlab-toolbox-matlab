function indices = find_group_indices(tbl, group_definition)
% FIND_GROUP_INDICES - Finds table rows that match a group definition.
%
%   indices = FIND_GROUP_INDICES(tbl, group_definition)
%
%   This is a helper function for the LME power analysis suite. It finds
%   the logical indices of rows in the table `tbl` that match the criteria
%   specified in `group_definition`.
%
%   The `group_definition` can be:
%   1. A STRING or CHAR: In this case, the function finds all rows where the
%      *first* column of the table matches the string. This is for simple,
%      single-factor main effect tests.
%   2. A STRUCT: In this case, the function finds all rows that match *all*
%      of the field-value pairs specified in the struct. This is for complex,
%      multi-factor post-hoc tests.
%
    if isstruct(group_definition)
        % Struct-based definition for multi-factor groups
        fields = fieldnames(group_definition);
        indices = true(height(tbl), 1); % Start with all rows true
        for i = 1:numel(fields)
            field = fields{i};
            value = group_definition.(field);

            % Get table data for the current field
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

            % Accumulate the logical AND across all fields
            indices = indices & (table_data == value);
        end
    else
        % String-based definition for single-factor groups
        % Assumes the first column is the one to test
        primary_category_name = tbl.Properties.VariableNames{1};
        indices = (tbl.(primary_category_name) == group_definition);
    end
end
