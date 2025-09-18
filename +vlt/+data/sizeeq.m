function b = sizeeq(x,y)

% VLT.DATA.SIZEEQ - Check if two variables have the same size
%
%   B = vlt.data.sizeeq(X,Y)
%
%   Returns 1 if the size of variables X and Y are identical.
%   Otherwise, it returns 0.
%
%   Example:
%       vlt.data.sizeeq([1 2], [3 4])      % returns 1
%       vlt.data.sizeeq([1 2], [3; 4])     % returns 0
%
%   See also: SIZE, EQLEN
%

sz1 = size(x);
sz2 = size(y);

if length(sz1)==length(sz2),
	f=double(vlt.data.eqemp(sz1,sz2));
	sz=size(f);
	b=prod(reshape(f,1,prod(sz)));
else,
	b=0;
end;
