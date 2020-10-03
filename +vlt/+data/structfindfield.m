function index = structfindfield(celllistofstructs, field, value)
% STRUCTFINDFIELD - find structure entries in a cell list with a field equal to value
%
% INDEX = vlt.data.structfindfield(CELLLISTOFSTRUCTS, FIELD, VALUE)
%
% Examines a cell list of structures CELLLISTOFSTRUCTS and returns the index values
% of those that contain a field FIELD with value equal to VALUE.
%

index = [];

for i=1:numel(celllistofstructs),
	if isfield(celllistofstructs{i},field),
		if vlt.data.eqlen(getfield(celllistofstructs{i},field),value),
			index(end+1) = i;
		end;
	end;
end;

