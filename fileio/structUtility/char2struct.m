function a = char2struct(s,fields)
% tab separated

a = [];
str = [char(9) s char(9)];
pos = findstr(str,char(9));

for i=1:length(fields)
	t = str(pos(i)+1:pos(i+1)-1);
    if strcmp(t,'struct'), % we assume the user wants the string 'struct'
        u = [];
    else,
    	u = str2num(t);
    end
	if ~isempty(u)
		a = setfield(a,fields{i},u);
	else
		a = setfield(a,fields{i},t);
	end
end
