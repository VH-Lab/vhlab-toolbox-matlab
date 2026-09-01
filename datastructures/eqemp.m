function b = eqemp(x,y)

%  EQEMP
%
%    B = EQEMP(X,Y)
%
%  If both X and Y are not empty, returns X==Y.  If both X and Y are empty, b=1.
%  Otherwise, b=0;
%
%  X==Y must be defined for the classes of X and Y, or there will be an error.
%  MATLAB does not define == for cell arrays, so EQEMP({'r'},{'r'}) raises
%  MATLAB:UndefinedFunction rather than returning a value; the same is true of
%  EQTOT and EQLEN, which reach this comparison. Use ISEQUAL or ISEQUALN for
%  cells, structs and objects. See issue #137 (item 2), which measured this on
%  a supported release.
%
%  See also:  EQ, ISEQUAL, ISEQUALN, EQTOT, EQLEN

b=1;
xe=isempty(x);
ye=isempty(y);
if (xe&(~ye))|(ye&(~xe)),
	b=0;
elseif ~xe&~ye,
	b=(x==y);
end;
