function c = structdiff(a,b)
c = 1;
fna = fieldnames(a);
fnb = fieldnames(b);

for i=1:length(fna)
	[j,jj,ii]=intersect(fna{i},fnb);
	if ~isempty(j),
		if ~(getfield(a,fna{i})==getfield(b,fnb{ii})),
			disp(['Fields ''' fna{i} ''' differ.']);
			c = 0;
			break;
		end;
	else,
		c = 0;
		disp(['Field name ''' fna{i} ''' not present in b.']);
		break;
	end;
end;

