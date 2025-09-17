function b = fieldsearch(A, searchstruct)
% VLT.DATA.FIELDSEARCH - Search a structure based on a set of rules
%
%   B = vlt.data.fieldsearch(A, SEARCHSTRUCT)
%
%   Determines if a structure A matches the search criteria defined in
%   SEARCHSTRUCT. SEARCHSTRUCT is a structure array with the following fields:
%   'field', 'operation', 'param1', and 'param2'.
%
%   Operations:
%     'regexp'               - Regular expression match between field value and 'param1'.
%     'exact_string'         - Exact string match with 'param1'.
%     'exact_string_anycase' - Case-insensitive exact string match with 'param1'.
%     'contains_string'      - Field value contains the string 'param1'.
%     'exact_number'         - Field value is exactly equal to 'param1'.
%     'lessthan', 'lessthaneq', 'greaterthan', 'greaterthaneq' - Numerical comparisons.
%     'hassize'              - Field value has the size specified in 'param1'.
%     'hasmember'            - Field value contains the member specified in 'param1'.
%     'hasfield'             - The field is present in the structure.
%     'partial_struct'       - Field value is a struct that matches the fields in 'param1'.
%     'hasanysubfield_contains_string' - Subfield contains a string.
%     'hasanysubfield_exact_string'    - Subfield exactly matches a string.
%     'or'                   - Logical OR of two search structures.
%     '~'                    - Negates the outcome of any operation (e.g., '~regexp').
%
%   Example:
%       A = struct('a', 'string_test', 'b', [1 2 3]);
%       search = struct('field','a','operation','contains_string','param1','test','param2','');
%       b1 = vlt.data.fieldsearch(A, search); % b1 will be 1
%
%   See also: REGEXP, STRCMP, STRCMPI, STRFIND, ISMEMBER, ISFIELD
%

b = true; % assume it matches

if numel(searchstruct)>1,
	% we need to do an AND, everything has to be true
	for i=1:numel(searchstruct),
		b_ = vlt.data.fieldsearch(A, searchstruct(i));
		if ~b_,
			b = false;
			break;
		end;
	end;
	return;
end;

 % if we are here, we will implement the searchstruct

b = false; % now it has to pass

[isthere, value] = vlt.data.isfullfield(A,searchstruct.field);

negation = false;

if searchstruct.operation(1) == '~',
	negation = true;
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
					b_ = true; % does this one match?
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
