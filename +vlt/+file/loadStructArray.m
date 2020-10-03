function a = loadStructArray(fname,fields)
% LOADSTRUCTARRAY - load a struct array from a tab-delimited file
%
% A = vlt.file.loadStructArray(FNAME [, FIELDS])
%
% Reads tab-delimited text from the file FNAME to create an array of
% Matlab STRUCT objects. If FIELDS is not provided, then the field names
% are read from the first row of FNAME.
%
% If the header row contains strings that are not valid Matlab structure
% field names % (because they have a space or begin with a number for example), 
% then they will be converted to valid variable names with 
% MATLAB.LANG.MAKEVALIDNAME.
%
% Each subsequent row contains the values for each entry in the STRUCT array.
%
% See also: vlt.file.saveStructArray, vlt.data.tabstr2struct
% 

[fid,msg] = fopen(fname, 'rt');
if fid == -1
	error(['Could not open file ' fname '.']);
	a = [];
	return;
end

try,
	if nargin == 1
		s = fgetl(fid);
		s = [char(9) s char(9)];
		pos = findstr(s,char(9));
		for i=1:length(pos)-1
			fields{i} = matlab.lang.makeValidName(...
				s(pos(i)+1:pos(i+1)-1));
			eval(['a.' fields{i} '=[];']);
		end
	end
catch,
	fclose(fid);
	error(['Error reading header row: ' lasterr ...
		', field name attempted was ''' fields{i} '''.']);
end

a = a([]);
count = 1;

while ~feof(fid),
	s = fgetl(fid);
	if length(s)>0,
		if ~isstr(s)
			break;
		end
		try,
			a(count) = vlt.data.tabstr2struct(s,fields);
		catch,
			fclose(fid);
			error(['Error reading data content line ' ...
				int2str(count) ': ' lasterr]);
		end
		count = count + 1;
	end;
end

fclose(fid);

