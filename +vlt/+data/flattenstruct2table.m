function t = flattenstruct2table(s, abbrev)
%FLATTENSTRUCT2TABLE Flattens a structure to a table, preserving nested struct array data.
%
%   T = flattenstruct2table(S)
%   T = flattenstruct2table(S, ABBREV)
%
% ## Description
%
% This function converts a structure or structure array `S` into a MATLAB `table`
% `T`. Nested field names are concatenated with a '.' to form the table's
% variable names (e.g., a field `Sub.Value` becomes a variable named 'Sub.Value').
%
% This version is an **optimized replacement** for an older implementation. It
% is specifically designed to replicate the legacy behavior for **nested struct
% arrays**. When a field contains a struct array (with more than one element),
% its data is *not* unrolled into multiple rows. Instead, the values from each
% sub-field are collected into a cell array and placed within a **single cell**
% of the output table. This ensures backward compatibility.
%
% This implementation is also highly optimized for speed and avoids the common
% MATLAB performance bottleneck of growing a table inside a loop.
%
% ## Input Arguments
%
%   S - The input structure or structure array to flatten.
%
%   ABBREV - (Optional) An Nx1 cell array used to shorten long variable
%            names. Each cell must contain a 1x2 cell, such as
%            `{'string_to_replace', 'replacement'}`.
%
% ## Output Arguments
%
%   T - The resulting flattened `table`.
%
% ## Example
%
%   % Create a structure with a nested struct array
%   Sub = struct('X', {10, 20}, 'Y', {'a', 'b'}); % A 1x2 struct array
%   S = struct('A', Sub, 'C', 3);
%
%   % Flatten the structure
%   T = flattenstruct2table(S)
%
%   % The output will be a 1x3 table:
%   %
%   %      A_X        A_Y      C
%   %    ________    _______    ___
%   %    {[10 20]}    {'a' 'b'}    3
%   %
%   % Note how the data from the S.A.X and S.A.Y fields is nested
%   % within single cells, rather than creating two separate rows.

if nargin < 2 || isempty(abbrev)
    abbrev = {};
end

if ~isstruct(s)
    error('Input must be a structure.');
end

if isempty(s)
    t = table();
    return;
end

% --- Main performance strategy: Pre-allocation ---

% 1. Flatten the first element to discover all variable names.
[variable_names, first_row_data] = flatten_scalar_recursive(s(1), '');

% Apply abbreviations once to the final list of names.
for k = 1:size(abbrev, 1)
    variable_names = strrep(variable_names, abbrev{k}{1}, abbrev{k}{2});
end

% 2. Pre-allocate a cell array to hold all the data.
num_rows = numel(s);
num_vars = numel(variable_names);
all_data = cell(num_rows, num_vars);
all_data(1, :) = first_row_data;

% 3. Loop through the rest of the elements and fill the data.
for i = 2:num_rows
    [~, row_data] = flatten_scalar_recursive(s(i), '');
    all_data(i, :) = row_data;
end

% 4. Create the table in a single, fast operation.
t = cell2table(all_data, 'VariableNames', variable_names);

end

function [names, values] = flatten_scalar_recursive(s_scalar, prefix)
% This recursive helper flattens a SINGLE (scalar) struct.
% It's the core of the logic, designed to match the original's behavior.

names = {};
values = {};

fn = fieldnames(s_scalar);

for i = 1:numel(fn)
    field_name = fn{i};
    v = s_scalar.(field_name);
    new_prefix = [prefix, field_name];

    if ~isstruct(v)
        % --- Base Case: Field is not a struct ---
        names = [names, {new_prefix}];
        values = [values, {v}]; % Wrap value in a cell for consistency

    else
        % --- Recursive Step: Field is a struct ---

        if isscalar(v)
            % Case 1: Scalar sub-struct. Recurse normally.
            [sub_names, sub_values] = flatten_scalar_recursive(v, [new_prefix '.']);
            names = [names, sub_names];
            values = [values, sub_values];
        else
            % Case 2: Nested struct array. This is the special case for
            % backward compatibility. We flatten it as a single unit.
            sub_fn = fieldnames(v);
            for k = 1:numel(sub_fn)
                sub_field_name = sub_fn{k};
                % The name is formed (e.g., 'A.X').
                names = [names, {[new_prefix '.' sub_field_name]}];

                % The value is a cell containing ALL values from that
                % sub-field (e.g., {[10, 20]}). This is the critical
                % part that matches the original's nested output.
                sub_field_value = v(1).(sub_field_name);
                if iscell(sub_field_value)
                    values = [values, {{v.(sub_field_name)}}];
                else
                    values = [values, {[v.(sub_field_name)]}];
                end
            end
        end
    end
end
end