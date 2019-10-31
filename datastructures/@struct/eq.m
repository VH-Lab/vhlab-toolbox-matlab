function b = eq(x,y)
% EQ - are two structures equal?
%
% B = EQ(X, Y)
%
% Returns 1 if and only if the structures X and Y have the same
% fieldnames and all fields have the same values.
% 

b=0;

if isstruct(y),
	sz1 = size(x);
	sz2=size(y);
	if all(sz1==sz2), % sizes match
		b=1;
		if prod(sz1)==1, % if we are down to single structures:
			fn1=fieldnames(x);
			fn2=fieldnames(y);
			if sort(fn1)==sort(fn2), % don't require order to be ==
				for i=1:length(fn1),
					xv=getfield(x,fn1{i});
					yv=getfield(y,fn1{i});
					if ~(eqlen(xv,yv)),
						b = 0; % we found a difference
						break;
					end;
				end;
			else,
				b = 0;
			end;
		else, % call the function repeatedly on every x(i), y(i)
			for i=1:prod(sz1),
				if x(i)~=y(i),
					b = 0;
					break;
				end;
			end;
		end;
	end;
end;
