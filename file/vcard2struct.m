function v = vcard2struct(vcardfile)
% VCARD2STRUCT - read information from Vcard text file, return as Matlab struct
%
% V = VCARD2STRUCT(VCARDFILE)
%
% Reads entries from a VCARD text file.
%
% VCARDFILE can be a text filename or a FILEOBJ object.
%
% Entries that take more than one line (like embedded photos) are currently skipped.
%
% The file will be closed at the conclusion of reading it.
%

v = {};

fid = fopen(vcardfile);
if fid<0,
	error(['Could not open file ' vcardfile '.']);
end;

while ~feof(fid),

	% read until we get a 'begin'

	nextline = fgetl(fid);

	if startsWith(lower(nextline),'begin:vcard')
		nextline = '';
		v_here = struct([]);

		while ~startsWith(lower(nextline),'end:vcard'),
			nextline = fgetl(fid);
			c = find(nextline==':');
			d = find(nextline==';');
			if isempty(c),
				firstc = Inf;
			else,
				firstc = c(1);
			end;
			if isempty(d),
				firstd = Inf;
			else,
				firstd = d(1);
			end;
			if isinf(firstd) & isinf(firstc), 
				% skip it
			elseif firstc<firstd, % single line
				param = matlab.lang.makeValidName(nextline(1:c(1)-1));
				value = nextline(c(1)+1:end);
				try,
					myvalue = eval(value);
					myvalue = value;
				catch,
					value = strrep(value,char(39),[char(39) char(39)]);
					myvalue = ['''' value ''''];
				end;
				%['v_here(1).' param ' = ' myvalue ';'];
				if ~strcmpi(param, 'end'),
					eval(['v_here(1).' param ' = ' myvalue ';']);
				end
			else, % multi-line
				try,
					here = split(nextline(1:c(1)-1),';');
				catch,
					here = {};
					% too long, skip it
				end;
				s = struct([]);
				s(1).type = {};
				for i=2:numel(here),
					e = find(here{i}=='=');
					value = here{i}(e(1)+1:end);
					value = strrep(value,char(39),char([39 39]));
					eval(['s.type{i-1}=' ''''  value '''' ';']);
				end;
				value = nextline(c(1)+1:end);
				value = strrep(value,char(39),char([39 39]));
				eval(['s.data = ' '''' value '''' ';']);
				if ~isempty(here),
					fn = matlab.lang.makeValidName(here{1});
					if isfield(v_here,fn),
						eval(['v_here(1).' fn '{end+1}=s;']);
					else,
						eval(['v_here(1).' fn '{1}=s;']);
					end;
				end;
			end;
		end;
		v{end+1} = v_here;
	end;
end;

fclose(fid);
