function s = struct2char(a)
% tab deliminated char(9)
fn = fieldnames(a);

s = '';

for i=1:length(fn)
	f = getfield(a,fn{i});
	if ischar(f)
		s = [s char(9) f];
	else
		s = [s char(9) mat2str(f)];
	end
end

s = s(2:end);
