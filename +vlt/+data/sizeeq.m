function b = sizeeq(x,y)

% vlt.data.sizeeq  Determines if size of two variables is same
%   
%   B = vlt.data.sizeeq(X,Y)
%
%  Returns 1 if the size of X and Y are equal.  Otherwise, returns 0.

sz1 = size(x);
sz2 = size(y);

if length(sz1)==length(sz2),
	f=double(vlt.data.eqemp(sz1,sz2));
	sz=size(f);
	b=prod(reshape(f,1,prod(sz)));
else,
	b=0;
end;
