function mustBeAValidTableVariable(arg, T)
% VLT.VALIDATORS.MUSTBEAVALIDTABLEVARIABLE Custom validator for table variable names.
%
% This function is intended for use in an 'arguments' block to validate
% that an input argument ARG (which should be a string or cell array of
% strings) contains valid variable names that exist in the table T.
%
% ARGUMENTS:
%   arg: The input value being validated (e.g., a data column name).
%   T:   The MATLAB table object against which the names are checked.

    % 1. Check type: must be string, cell array of strings, or empty
    if ~isstring(arg) && ~iscellstr(arg) && ~isempty(arg)
        error('vlt:table:shuffle:InvalidType', ...
              'Input must be a string array or cell array of strings.');
    end

    arg = string(arg); % Convert to a string array for checking

    % 2. Check existence: ensure all names exist in the table T
    if ~isempty(arg) && ~all(ismember(arg, T.Properties.VariableNames))
         error('vlt:table:shuffle:UnknownVariable', ...
               'All provided variable names must exist in the input table DATATABLE.');
    end
end
