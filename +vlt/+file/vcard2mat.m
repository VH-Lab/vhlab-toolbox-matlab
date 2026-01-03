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
   % developer note: assumes parameter names are 'type', should read it
   % need to look ahead to next line


v = {};

fid = fopen(vcardfile);
if fid<0
	error(['Could not open file ' vcardfile '.']);
end

while ~feof(fid)

	% read until we get a 'begin'

	nextline = fgetl(fid);

	if startsWith(lower(nextline),'begin:vcard')
		nextline = '';
		v_here = struct([]);

		while ~startsWith(lower(nextline),'end:vcard')
			% read the next line, which might consist of many file lines
			nextline = fgetl(fid);
			% continue to read lines that should be combined
			linedone = 0;
			loc = ftell(fid); % remember where we are
			while linedone==0
				if ~feof(fid) % if we don't have EOF then keep going
					loc = ftell(fid); % remember where we are
					nextchar = fread(fid,1,'char'); % read a character
					if nextchar==' ' % we need the line
						nextnextline = fgetl(fid);
						nextline = [nextline nextnextline];
					else % that line is something new, just go back
						linedone = 1;
						fseek(fid,loc,'bof');
					end
				else
					linedone = 1;
				end
			end
				
			c = find(nextline==':');
			d = find(nextline==';');
			if isempty(c)
				firstc = Inf;
			else
				firstc = c(1);
			end
			if isempty(d)
				firstd = Inf;
			else
				firstd = d(1);
			end
			if isinf(firstd) && isinf(firstc)
				% skip it
			elseif firstc<firstd % single line
				param = matlab.lang.makeValidName(nextline(1:c(1)-1));
				value = nextline(c(1)+1:end);
                value = value(value<=127);
				try
					eval([value ';']);
					myvalue = value;
				catch
					value = strrep(value,'''','''''');
					myvalue = ['''' value ''''];
				end
				%['v_here(1).' param ' = ' myvalue ';'];
				if ~strcmpi(param, 'end')
					eval(['v_here(1).' param ' = ' myvalue ';']);
				end
			else % multi-line
				try
					here = split(nextline(1:c(1)-1),';');
				catch
					here = {};
					% too long, skip it
				end
				s = struct([]);
				for i=2:numel(here)
					e = find(here{i}=='=');
                    if isempty(e)
                        param = 'type';
                        value = here{i};
                    else
					value = here{i}(e(1)+1:end);
                        param = here{i}(1:e(1)-1);
                    end
                    value = value(value<=127);
					value = strrep(value,'''','''''');
					param = matlab.lang.makeValidName(param);
					if isfield(s,param)
						N = numel(getfield(s,param));
					else
						N = 0;
					end
					eval(['s(1).' param '{N+1}=' ''''  value '''' ';']);
				end
				value = nextline(c(1)+1:end);
                value = value(value<=127);
				value = strrep(value,'''','''''');
				eval(['s.data = ' '''' value '''' ';']);
				if ~isempty(here)
					fn = matlab.lang.makeValidName(here{1});
					if isfield(v_here,fn)
						eval(['v_here(1).' fn '{end+1}=s;']);
					else
						eval(['v_here(1).' fn '{1}=s;']);
					end
				end
			end
		end
		v{end+1} = v_here;
	end
end

fclose(fid);
