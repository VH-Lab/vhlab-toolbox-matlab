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
    % 1. Check type: must be string array, cell array of char vectors, or a single char row vector.
    %    This logic handles: "str", ["str1", "str2"], 'char', {'char1', 'char2'},
    %    and empty variants: "", string.empty, '', {}
    if ~(isstring(arg) || iscellstr(arg) || (ischar(arg) && (isrow(arg) || isempty(arg))))
        error('vlt:validators:mustBeAValidTableVariable:InvalidType', ...
              'Input must be a string array, cell array of strings, or a char row vector.');
    end
    % 2. Check existence: ensure all names exist in the table T
    arg = string(arg); % Convert to a string array for checking

    if ~isempty(arg) && ~all(ismember(arg, T.Properties.VariableNames))
         error('vlt:validators:mustBeAValidTableVariable:UnknownVariable', ...
               'All provided variable names must exist in the input table DATATABLE.');
    end
end
