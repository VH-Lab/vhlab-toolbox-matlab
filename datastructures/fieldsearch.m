function b = fieldsearch(A, searchstruct)
% FIELDSEARCH - Search a structure to determine if it matches a search structure
%
% B = FIELDSEARCH(A, SEARCHSTRUCT)
%
% Determines if a structure A matches the search structure SEARCHSTRUCT.
%
% SEARCHSTRUCT should be a structure array with the following fields:
%
% Field:                     | Description
% ----------------------------------------------------------------------------
% field                      | A character string of the field of A to examine
% operation                  | The operation to perform. This operation determines 
%                            |   values of fields 'param1' and 'param2'.
%     -----------------------|
%     |   'regexp'             - are there any regular expression matches between 
%     |                          the field value and 'param1'?
%     |   'exact_string'       - is the field value an exact string match for 'param1'?
%     |   'contains_string'    - is the field value a char array that contains 'param1'?
%     |   'exact_number'       - is the field value exactly 'param1' (same size and values)?
%     |   'lessthan'           - is the field value less than 'param1' (and comparable size)
%     |   'lessthaneq'         - is the field value less than or equal to 'param1' (and comparable size)
%     |   'greaterthan'        - is the field value greater than 'param1' (and comparable size)
%     |   'greaterthaneq'      - is the field value greater than or equal to 'param1' (and comparable size)
%     |   'hasfield'           - is the field present? (no role for 'param1' or 'param2')
%     |   'hasanysubfield_contains_string' - Is the field value an array of structs or cell array of structs
%     |                        such that any has a field named 'param1' with a string that contains the string
%     |                        in 'param2'?
%     -----------------------|
% param1                     | Search parameter 1. Meaning depends on 'operation' (see above).
% param2                     | Search parameter 2. Meaning depends on 'operation' (see above).
%
% A 'comparable' size means the 2 variables can be compared. [1 2 3]>=1 is comparable. [1 2 3]>=[0 0 0] is comparable. 
% [1 2 3]>[1 2] is an error.
% 
%
% Examples: 
%     A = struct('a','string_test','b',[1 2 3])
%     b1=fieldsearch(A,struct('field','a','operation','contains_string','param1','test','param2',''))
%     b2=fieldsearch(A,struct('field','b','operation','greaterthaneq','param1',1,'param2',''))
% 
%     B = struct('values',A);
%     b3=fieldsearch(B,struct('field','values','operation','hasanysubfield_contains_string','param1','a','param2','string_test'))
%

b = 1; % assume it matches

if numel(searchstruct)>1,
	for i=1:numel(searchstruct),
		b_ = fieldsearch(A, searchstruct(i));
		if ~b_,
			b = 0;
			break;
		end;
	end;
	return;
end;

 % if we are here, we will implement the searchstruct

b = 0; % now it has to pass

switch(lower(searchstruct.operation))
	case 'regexp',
		if isfield(A,searchstruct.field),
			value = getfield(A,searchstruct.field);
			if ischar(value), % it has to be a char or string to match
				test = regexpi(value, searchstruct.param1, 'forceCellOutput');
				b = ~isempty(test);
			end;
		end;
	case 'exact_string',
		if isfield(A,searchstruct.field),
			b = strcmp(getfield(A,searchstruct.field),searchstruct.param1);
		end;
	case 'contains_string',
		if isfield(A,searchstruct.field),
			try,
				b = ~isempty(strfind(getfield(A,searchstruct.field),searchstruct.param1));
			end;
		end;
	case 'exact_number',
		if isfield(A,searchstruct.field),
			b = eqlen(getfield(A,searchstruct.field),searchstruct.param1);
		end;
	case 'lessthan',
		if isfield(A,searchstruct.field),
			v = getfield(A,searchstruct.field);
			try,
				b = all(getfield(A,searchstruct.field)<searchstruct.param1);
			end;
		end;
	case 'lessthaneq',
		if isfield(A,searchstruct.field),
			v = getfield(A,searchstruct.field);
			try,
				b = all(getfield(A,searchstruct.field)<=searchstruct.param1);
			end;
		end;
	case 'greaterthan',
		if isfield(A,searchstruct.field),
			v = getfield(A,searchstruct.field);
			try,
				b = all(getfield(A,searchstruct.field)>searchstruct.param1);
			end;
		end;
	case 'greaterthaneq',
		if isfield(A,searchstruct.field),
			v = getfield(A,searchstruct.field);
			try,
				b = all(getfield(A,searchstruct.field)>=searchstruct.param1);
			end;
		end;
	case 'hasfield',
		b = isfield(A,searchstruct.field);
	case 'hasanysubfield_contains_string',
		if isfield(A,searchstruct.field),
			v = getfield(A,searchstruct.field);
			if ~ (isstruct(v) | iscell(v) ), return; end; % must be a structure or cell
			for i=1:numel(v),
				if isstruct(v),
					item = v(i);
				else,
					item = v{i};
				end;
				if isstruct(item), % item must be a struct,
					if isfield(item,searchstruct.param1),
						v2 = getfield(item,searchstruct.param1);
						if ischar(v2),
							b = ~isempty(strfind(v2,searchstruct.param2));
							if b, break; end;
						end;
					end;
				end;
			end;
		end;
	otherwise,
		error(['Unknown search operation ' searchstruct.operation ]);
end;

