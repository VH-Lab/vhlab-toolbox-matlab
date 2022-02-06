function b = fieldsearch(A, searchstruct)
% FIELDSEARCH - Search a structure to determine if it matches a search structure
%
% B = vlt.data.fieldsearch(A, SEARCHSTRUCT)
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
%     |   'regexp'               - are there any regular expression matches between 
%     |                            the field value and 'param1'?
%     |   'exact_string'         - is the field value an exact string match for 'param1'?
%     |   'exact_string_anycase' - is the field value an exact string match for 'param1' (case insensitive)?
%     |   'contains_string'      - is the field value a char array that contains 'param1'?
%     |   'exact_number'         - is the field value exactly 'param1' (same size and values)?
%     |   'lessthan'             - is the field value less than 'param1' (and comparable size)
%     |   'lessthaneq'           - is the field value less than or equal to 'param1' (and comparable size)
%     |   'greaterthan'          - is the field value greater than 'param1' (and comparable size)
%     |   'greaterthaneq'        - is the field value greater than or equal to 'param1' (and comparable size)
%     |   'hassize'              - does the field value have the size as indicated in 'param1' [x y z ...]
%     |   'hasmember'            - does the field value have the member indicated in 'param1' ?
%     |   'hasfield'             - is the field present? (no role for 'param1' or 'param2')
%     |   'partial_struct'       - is the field value a structure that has all the fields of 'param1' with the same values?
%     |                            (note that it may have additional fields not found in the structure in param1)
%     |   'hasanysubfield_contains_string' - Is the field value an array of structs or cell array of structs
%     |                          such that any has a field named 'param1' with a string that contains the string
%     |                          in 'param2'? If 'param1' is a cell list, then 'param2' can be a cell list of contained
%     |                          strings to be matched.
%     |   'hasanysubfield_exact_string' - Is the field value an array of structs or cell array of structs
%     |                          such that any has a field named 'param1' with a string that exactly matches the string
%     |                          in 'param2'? If 'param1' is a cell list, then 'param2' can be a cell list of contained
%     |                          strings to be matched.
%     |   'or'                   - are the searchstruct elements specified in 'param1' OR 'param2' true?
%     |   '~'                    - NOT of any operator, such as ~regexp, negates the outcome of the search
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
%     b1=vlt.data.fieldsearch(A,struct('field','a','operation','contains_string','param1','test','param2',''))
%     b2=vlt.data.fieldsearch(A,struct('field','b','operation','greaterthaneq','param1',1,'param2',''))
% 
%     B = struct('values',A);
%     b3=vlt.data.fieldsearch(B,struct('field','values','operation','hasanysubfield_contains_string','param1','a','param2','string_test'))
%
%     b4=vlt.data.fieldsearch(A,struct('field','','operation','or', ...
%         'param1', struct('field','b','operation','hasfield','param1','','param2',''), ...
%         'param2', struct('field','c','operation','hasfield','param1','','param2','') ))
%

b = 1; % assume it matches

if numel(searchstruct)>1,
	% we need to do an AND, everything has to be true
	for i=1:numel(searchstruct),
		b_ = vlt.data.fieldsearch(A, searchstruct(i));
		if ~b_,
			b = 0;
			break;
		end;
	end;
	return;
end;

 % if we are here, we will implement the searchstruct

b = 0; % now it has to pass

[isthere, value] = vlt.data.isfullfield(A,searchstruct.field);

negation = 0;

if searchstruct.operation(1) == '~',
	negation = 1;
	searchstruct.operation = searchstruct.operation(2:end);
end;

switch(lower(searchstruct.operation)),
	case 'regexp',
		if isthere,
			if ischar(value), % it has to be a char or string to match
				test = regexpi(value, searchstruct.param1, 'forceCellOutput');
				if ~isempty(test),
					b = ~isempty(test{1});
				end;
			end;
		end;
	case 'exact_string',
		if isthere,
			b = strcmp(value,searchstruct.param1);
		end;
	case 'exact_string_anycase',
		if isthere,
			b = strcmpi(value,searchstruct.param1);
		end;
	case 'contains_string',
		if isthere,
			try,
				b = ~isempty(strfind(value,searchstruct.param1));
			end;
		end;
	case 'exact_number',
		if isthere,
			b = vlt.data.eqlen(value,searchstruct.param1);
		end;
	case 'lessthan',
		if isthere,
			try,
				b = all(value<searchstruct.param1);
			end;
		end;
	case 'lessthaneq',
		if isthere,
			try,
				b = all(value<=searchstruct.param1);
			end;
		end;
	case 'greaterthan',
		if isthere,
			try,
				b = all(value>searchstruct.param1);
			end;
		end;
	case 'greaterthaneq',
		if isthere,
			try,
				b = all(value>=searchstruct.param1);
			end;
		end;
	case 'hassize',
		if isthere,
			try,
				b = vlt.data.eqlen(size(value),searchstruct.param1);
			end;
		end;
	case 'hasmember',
		if isthere,
			try,
				b = ismember(searchstruct.param1,value);
			end;
		end;
	case 'hasfield',
		b = isthere;
	case 'partial_struct',
		if isthere,
			try,
				b = vlt.data.structpartialmatch(value,searchstruct.param1);
			end;
		end;
	case {'hasanysubfield_contains_string','hasanysubfield_exact_string'},
		if isthere,
			if ~ (isstruct(value) | iscell(value) ), return; end; % must be a structure or cell
			for i=1:numel(value),
				if isstruct(value),
					item = value(i);
				else,
					item = value{i};
				end;
				if isstruct(item), % item must be a struct,
					if ~iscell(searchstruct.param1),
						searchstruct.param1 = {searchstruct.param1};
					end;
					if ~iscell(searchstruct.param2),
						searchstruct.param2 = {searchstruct.param2};
					end;
					b_ = 1; % does this one match?
					for k=1:numel(searchstruct.param1),
						[isthere2,value2] = vlt.data.isfullfield(item,searchstruct.param1{k});
						if ischar(value2) | isempty(value2),
							if strcmp(lower(searchstruct.operation),'hasanysubfield_contains_string'),
								b_ = b_ & ~isempty(strfind(value2,searchstruct.param2{k}));
							elseif strcmp(lower(searchstruct.operation),'hasanysubfield_exact_string');
								b_ = b_ & strcmp(value2,searchstruct.param2{k});
							else,
								error(['Unknown operation; shouldn''t happen.']);
							end;
						end;
					end;
					b = b_;
				end;
				if b, % we found that it matches
					break;
				end;
			end;
		end;
	case 'or',
		if ~isstruct(searchstruct.param1) | ~isstruct(searchstruct.param2),
			error(['In operation ''or'', searchstruct ''param1'' and ''param2'' must be an array of structures.']);
		end;
		b = (vlt.data.fieldsearch(A,searchstruct.param1) | vlt.data.fieldsearch(A,searchstruct.param2));
	otherwise,
		error(['Unknown search operation ' searchstruct.operation ]);
end;

if negation,
	b = ~b;
end;
