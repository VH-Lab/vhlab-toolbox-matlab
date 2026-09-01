function b = eqlen(x,y)

%  EQLEN  Returns 1 if objects to compare are equal and have same size
%  
%    B = EQLEN(X,Y)
%
%  Returns 1 iff X and Y have the same length and all of the entries in X and
%  Y are the same.
%
%  Examples:  EQLEN([1],[1 1])=0, whereas [1]==[1 1]=[1 1], EQTOT([1],[1 1])=1
%             EQLEN([1 1],[1 1])=1
%             EQLEN([],[]) = 1
%
%  Comparison bottoms out in X==Y (see EQEMP), which has two consequences
%  worth knowing: NaN is not equal to itself, so EQLEN(NaN,NaN) is 0; and
%  classes for which == is undefined raise an error rather than returning a
%  value. Cell arrays of char vectors are not among them -- EQLEN({'r','g','b'},
%  {'r','g','b'}) is 1, not an error (issue #137, item 2). Use ISEQUALN when you
%  want either of those to come out the other way. See issue #137 (items 2 and 3).
%
%  See also:  EQTOT, EQEMP, EQ, ISEQUALN

if sizeeq(x,y), b = eqtot(x,y); else, b = 0; end;

