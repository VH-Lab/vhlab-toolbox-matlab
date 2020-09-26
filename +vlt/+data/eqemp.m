function b = eqemp(x,y)

%  vlt.data.eqemp
%
%    B = vlt.data.eqemp(X,Y)
%
%  If both X and Y are not empty, returns X==Y.  If both X and Y are empty, b=1.
%  Otherwise, b=0;  Note that if X==Y is not defined, there will be an error.
%
%  See also:  EQ, vlt.data.eqtot, vlt.data.eqlen

b=1;
xe=isempty(x);
ye=isempty(y);
if (xe&(~ye))|(xe&(~ye)),
	b=0;
elseif ~xe&~ye,
	b=(x==y);
end;
