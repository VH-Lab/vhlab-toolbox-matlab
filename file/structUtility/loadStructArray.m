function a = loadStructArray(fname,fields)
% if no fields, get fields from first line

[fid,msg] = fopen(fname, 'rt');
if fid == -1
	a = [];
	return;
end

if nargin == 1
	s = fgetl(fid);
	s = [char(9) s char(9)];
	pos = findstr(s,char(9));
	for i=1:length(pos)-1
		fields{i} = s(pos(i)+1:pos(i+1)-1);
		eval(['a.' fields{i} '=[];']);
	end
end
a = a([]);
count = 1;
while ~feof(fid),
	s = fgetl(fid);
	if length(s)>0,
		if ~isstr(s)
			break;
		end
		a(count) = char2struct(s,fields);
		count = count + 1;
	end;
end

fclose(fid);
