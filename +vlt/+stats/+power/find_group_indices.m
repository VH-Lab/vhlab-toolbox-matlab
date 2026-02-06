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
%   1. A STRING, CHAR, or NUMERIC: For simple, single-factor tests. The function finds
%      all rows where the column specified by `category_name` matches the value.
%   2. A STRUCT: For complex, multi-factor post-hoc tests. The function finds
%      all rows that match *all* of the field-value pairs in the struct.
%

    % --- Helper function for robust string comparison ---
    function isEqual = robust_compare(table_col_data, value)
        % Converts both table data and the target value to sanitized cellstrs
        % for a reliable comparison, handling numeric, categorical, and string types.

        % 1. Sanitize the value
        if isnumeric(value)
            value_str = {num2str(value)};
        else
            value_str = {char(strtrim(replace(string(value), char(160), ' ')))};
        end

        % 2. Sanitize the table column data
        if isnumeric(table_col_data)
            table_str = cellstr(num2str(table_col_data));
        else
            table_str = cellstr(strtrim(replace(string(table_col_data), char(160), ' ')));
        end

        % 3. Perform comparison
        isEqual = strcmp(table_str, value_str);
    end

    % --- Main logic ---
    if isstruct(group_definition)
        % Struct-based definition for multi-factor groups
        fields = fieldnames(group_definition);
        indices = true(height(tbl), 1); % Start with all rows true

        for i = 1:numel(fields)
            field = fields{i};
            if ~any(strcmp(tbl.Properties.VariableNames, field))
                eid = 'vlt:stats:power:find_group_indices:invalidField';
                msg = ['The factor name ''' field ''' from the target group struct was not found in the table.'];
                throw(MException(eid,msg));
            end

            value = group_definition.(field);
            table_col_data = tbl.(field);

            % Use the robust comparison for each field
            indices = indices & robust_compare(table_col_data, value);
        end
    else
        % String/numeric-based definition for single-factor groups
        table_col_data = tbl.(category_name);
        indices = robust_compare(table_col_data, group_definition);
    end

    % Final check to ensure we found something if we expected to
    if ~any(indices)
        warning('vlt:stats:power:find_group_indices:noRowsFound', ...
            'No rows were found that match the specified target group. Check for spelling errors or incorrect factor levels.');
    end
end
