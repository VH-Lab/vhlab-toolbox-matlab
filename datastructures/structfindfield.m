function index = structfindfield(celllistofstructs, field, value)
% STRUCTFINDFIELD - find structure entries in a cell list with a field equal to value
%
% INDEX = STRUCTFINDFIELD(CELLLISTOFSTRUCTS, FIELD, VALUE)
%
% Examines a cell list of structures CELLLISTOFSTRUCTS and returns the index values
% of those that contain a field FIELD with value equal to VALUE.
%

index = [];

for i=1:numel(celllistofstructs),
	if isfield(celllistofstructs{i},field),
		if eqlen(getfield(celllistofstructs{i},field),value),
			index(end+1) = i;
		end;
	end;
end;

