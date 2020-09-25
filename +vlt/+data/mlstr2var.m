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
% Consider also: JSONENCODE, JSONDECODE
%
% See also: CELL2MLSTR, STRUCT2MLSTR, JSONDECODE

mlstring = strip(mlstring); % remove whitespace

if isempty(mlstring),
	v = [];
	return;
end;

hasleading = 1;
hastrailing = 1;

if mlstring(1)~='<',
	hasleading = 0;
end;

if mlstring(end)~='>',
	hastrailing = 0;
end;

if ~hasleading & ~hastrailing,
	v = eval(mlstring); % it's just a variable
	return;
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
	endofdata = endofdata(end)-1; % should be correct even if these occur within the data

	dataregion = codingregion(datastart+length('data='):endofdata);

	if structhere,
		v = vlt.data.emptystruct(fieldnames_values{:});
	else,
		v = {};
	end;

	isinmatlabstring = vlt.string.ismatlabstring(dataregion);
	dataregion_meta = dataregion;
	dataregion_meta(find(isinmatlabstring)) = 'X'; % ignore strings, which might have our metacharacters
	brace = bracelevel(dataregion_meta,'<','>') >= 1;
	onsets = 1+find(diff(brace)==1);
	offsets = find(diff(brace)==-1);
	if structhere,
		for i=1:numel(onsets),
			entrystring = dataregion(onsets(i):offsets(i));
			entrystring_meta = dataregion_meta(onsets(i):offsets(i));
			bracelevel(entrystring_meta,'<','>');
			structlevels = (bracelevel(entrystring_meta,'<','>') >= 1);
			structonsets = 1+find(diff(structlevels)==1);
			structoffsets = find(diff(structlevels)==-1);
			vnew = emptystruct(fieldnames_values{:});
			for j=1:numel(structonsets),
				%entrystring(structonsets(j):structoffsets(j))
				eval(['vnew(1).' fieldnames_values{j} '=vlt.data.mlstr2var(entrystring(structonsets(j):structoffsets(j)));']);
            end
		    v(end+1) = vnew;
		end

	else,
		for i=1:numel(onsets),
			v{i} = mlstr2var(dataregion(onsets(i):offsets(i)));
		end
    end
    
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


