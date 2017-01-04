function a = char2struct(s,fields)
% tab separated

a = [];
str = [char(9) s char(9)];
pos = findstr(str,char(9));

for i=1:length(fields)
	t = str(pos(i)+1:pos(i+1)-1);
	u = str2num(t);
	if ~isempty(u)
		a = setfield(a,fields{i},u);
	else
		a = setfield(a,fields{i},t);
	end
end
