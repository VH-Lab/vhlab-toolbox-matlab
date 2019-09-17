function b = fieldsearch(A, searchstruct)
% FIELDSEARCH - Search a structure to determine if it matches a search structure
%
% B = FIELDSEARCH(A, SEARCHSTRUCT)
%
% Determines if a structure A matches the search structure SEARCHSTRUCT.
%
% See SEARCHSTRUCT for information about the search structure format.
%

b = 1; % assume it matches

if numel(searchstruct)>1,
	for i=1:numel(searchstruct),
		b_ = fieldsearch(A, searchstruct(i);
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
				test = regexpi(value, searchstruct.search, 'forceCellOutput');
				b = ~isempty(test);
			end;
		end;
	case 'exact_string',
		if isfield(A,searchstruct.field),
			b = strcmp(getvalue(A,searchstruct.field),searchstruct.search);
		end;
	case 'exact_number',
		if isfield(A,searchstruct.field),
			b = eqlen(getvalue(A,searchstruct.field),searchstruct.search);
		end;
	case 'hasfield',
		b = isfield(A,searchstruct.field);
	
end;

