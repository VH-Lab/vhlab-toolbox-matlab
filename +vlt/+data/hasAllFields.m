function [good, errormsg] = hasAllFields(variable, fieldNames, fieldSizes)

% VLT.DATA.HASALLFIELDS - Check if a structure has all specified fields and correct sizes
%
%   [GOOD, ERRORMSG] = vlt.data.hasAllFields(VARIABLE, FIELDNAMES, [FIELDSIZES])
%
%   Checks if a structure VARIABLE contains all the field names listed in the
%   cell array FIELDNAMES. Optionally, it can also check if the dimensions of
%   each field match the sizes specified in the cell array FIELDSIZES.
%
%   Inputs:
%   'VARIABLE' is the structure to check.
%   'FIELDNAMES' is a cell array of strings with the required field names.
%   'FIELDSIZES' (optional) is a cell array of the same size as FIELDNAMES,
%     where each element specifies the expected size of the corresponding field.
%     Use -1 for any dimension that should not be checked.
%
%   Outputs:
%   'GOOD' is 1 if all checks pass, and 0 otherwise.
%   'ERRORMSG' is a string containing an error message if a check fails.
%
%   Example:
%       r = struct('test1', 5, 'test2', [6 1]);
%       [g,e] = vlt.data.hasAllFields(r, {'test1','test2'}, {[1 1], [1 2]});
%       % g will be 1, e will be ''
%
%   See also: ISFIELD, SIZE
%

good = 1; errormsg = '';

if nargin == 3, checkSizes = 1; else, checkSizes = 0; end;

	notbad = 1;
	
for i=1:length(fieldNames),
	if good, notbad = 1; end;
	good = good & isfield(variable,fieldNames{i});
	if (notbad& ~good), 
		errormsg = ['''' fieldNames{i} ''' not present.']; notbad = 0;
	end;
    if checkSizes & good,
        sz = []; szg = fieldSizes{i};
        eval(['sz = size(variable.' fieldNames{i} ');']);
        if (szg(1) > -1) good=good&(szg(1)==sz(1)); end;
        if (szg(2) > -1) good=good&(szg(2)==sz(2)); end;
    end;
	if (notbad& ~good),
		if (szg(1)==-1), eT1 = 'N'; else, eT1 = int2str(szg(1)); end;
		if (szg(2)==-1), eT2 = 'N'; else, eT2 = int2str(szg(2)); end;
		errormsg = [fieldNames{i} ' not of expected size ' ...
		'(got ' int2str(sz(1)) 'x' int2str(sz(2)) ' but expected ' eT1 'x' eT2 ').'];
		notbad = 0;
	end;
end;
