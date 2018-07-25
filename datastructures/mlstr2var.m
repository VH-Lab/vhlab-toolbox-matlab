function v = mlstr2var(mlstring)
% MLSTR2VAR - creates a Matlab variable from markup language strings (STRUCT2MLSTR, CELL2MLSTR)
%
% V = MLSTR2VAR(MLSTRING)
%
% Given a markup language string representation of Matlab structures or cells, this 
% function produces a Matlab variable v.
%
% Matlab STRUCT types are specified in the markup language in the following way:
% <STRUCT size=[X Y Z ...] fields={ 'fieldname1','fieldname2',...} data=
%      <<value1><value2>...<valuen>>
%      <<value1><value2>...<valuen>>
% /STRUCT>
%
% and Matlab CELL types are specified in the markup language in the following way:
% <CELL size=[X Y Z ...] data=
%      <value1>
%      <value2>
% /CELL>
%
%
% See also: CELL2MLSTR, STRUCT2MLSTR

error('still under construction');

mlstring = strip(mlstring); % remove whitespace

if isempty(mlstring),
	v = [];
	return;
end;

if mlstring(1)~='<',
	error(['Could not finding leading ''<'' at ' mlstring(1:10) '...']);
end;

if mlstring(end)~='>',
	error(['Could not finding trailing ''>'' at '  mlstring(end-10:end) '...']);
end;

codingregion = strtrim(mlstring(2:end-1));

if startsWith(lower(codingregion), lower('STRUCT')) | startsWith(lower(codingregion), lower('CELL')),
	% import struct or cell
	datastart = strfind(lower(codingregion), 'data=');
	if isempty(datastart),
		error(['Could not find ''data='' segment.']);
	end

	structhere = startsWith(lower(codingregion), lower('STRUCT'));
	cellhere = 1-structhere;

	if structhere,
		parametersregion = strtrim(codingregion(1+length('STRUCT'):datastart-1)); 
	else,
		parametersregion = strtrim(codingregion(1+length('CELL'):datastart-1)); 
	end

	sizemat = [];
	fieldnames_values = [];

	equalspot = find(parametersregion== '=',1); % find first one
	while ~isempty(equalspot),
		command = strtrim(parametersregion(1:equalspot-1));
		switch lower(command),
			case 'size',
				terminator = find(parametersregion==']'); % last occurrance of this is the terminator
				beginner = find(parametersregion=='['); % first one is beginner
				if isempty(terminator) | isempty(beginner),
					error(['Cannot interpret size values in ' parametersregion '.']);
				end;
				sizemat = eval(parametersregion(beginner(1):terminator(end)));
				parametersregion = parametersregion(terminator(end)+1:end);
			case 'fields',
				terminator = find(parametersregion=='}'); % last occurrance of this is the terminator
				beginner = find(parametersregion=='{'); % first one is beginner
				if isempty(terminator) | isempty(beginner),
					error(['Cannot interpret field values in ' parametersregion '.']);
				end;
				fieldnames_values = eval(parametersregion(beginner(1):terminator(end)));
				parametersregion = parametersregion(terminator(end)+1:end);
		end
		equalspot = find(parametersregion== '=',1); % find first one
	end


	if structhere,
		endofdata = strfind(lower(codingregion),lower('/STRUCT'));
		if isempty(endofdata),
			error(['Could not find corresponding /STRUCT> ending STRUCT .']);
		end
	else,
		endofdata = strfind(lower(codingregion),lower('/CELL'));
		if isempty(endofdata),
			error(['Could not find corresponding /CELL> ending CELL.']);
		end
	end
	endofdata = endofdata(end)-1;

	dataregion = codingregion(datastart+length('data='):endofdata),

	if structhere,
		v = emptystruct(fieldnames_values{:});
	else,
		v = {};
	end;

	sizemat,
	fieldnames_values,
	

	v = reshape(v,sizemat);
elseif codingregion(1)=='''',
	% import char
	if codingregion(end)~='''',
		error(['Could not find proper terminating quote.']);
	end
	v = codingregion(2:end-1);
else,   % it is a matrix
	v = str2nume(codingregion); % use our version that recognizes empty
end


