function v = mlstr2var(mlstring)
% VLT.DATA.MLSTR2VAR - Convert a markup language string to a Matlab variable
%
%   V = vlt.data.mlstr2var(MLSTRING)
%
%   Converts a markup language string representation of a Matlab structure or
%   cell array back into a Matlab variable. This function is the inverse of
%   vlt.data.struct2mlstr and vlt.data.cell2mlstr.
%
%   The markup language format is as follows:
%   For structs:
%   <STRUCT size=[X Y Z...] fields={'f1','f2',...} data=
%       <<val1><val2>...>
%   /STRUCT>
%
%   For cells:
%   <CELL size=[X Y Z...] data=
%       <val1>
%       <val2>
%   /CELL>
%
%   Example:
%       str = '<CELL size=[1 3] data=\n     <''test''>\n     <[5]>\n     <[3 4 5]>\n/CELL>';
%       C = vlt.data.mlstr2var(str); % C will be {'test', 5, [3 4 5]}
%
%   See also: vlt.data.cell2mlstr, vlt.data.struct2mlstr, JSONENCODE, JSONDECODE
%

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
	brace = vlt.string.bracelevel(dataregion_meta,'<','>') >= 1;
	onsets = 1+find(diff(brace)==1);
	offsets = find(diff(brace)==-1);
	if structhere,
		for i=1:numel(onsets),
			entrystring = dataregion(onsets(i):offsets(i));
			entrystring_meta = dataregion_meta(onsets(i):offsets(i));
			vlt.string.bracelevel(entrystring_meta,'<','>');
			structlevels = (vlt.string.bracelevel(entrystring_meta,'<','>') >= 1);
			structonsets = 1+find(diff(structlevels)==1);
			structoffsets = find(diff(structlevels)==-1);
			vnew = vlt.data.emptystruct(fieldnames_values{:});
			for j=1:numel(structonsets),
				%entrystring(structonsets(j):structoffsets(j))
				eval(['vnew(1).' fieldnames_values{j} '=vlt.data.mlstr2var(entrystring(structonsets(j):structoffsets(j)));']);
            end
		    v(end+1) = vnew;
		end

	else,
		for i=1:numel(onsets),
			v{i} = vlt.data.mlstr2var(dataregion(onsets(i):offsets(i)));
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
	v = vlt.data.str2nume(codingregion); % use our version that recognizes empty
end


