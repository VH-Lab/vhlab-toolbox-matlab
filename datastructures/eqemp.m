function b = eqemp(x,y)

%  EQEMP
%
%    B = EQEMP(X,Y)
%
%  If both X and Y are not empty, returns X==Y.  If both X and Y are empty, b=1.
%  Otherwise, b=0.
%
%  X==Y AND CELL/STRUCT INPUTS. Earlier help here said that an error results
%  if X==Y is not defined. That is true of stock MATLAB but not of this
%  toolbox: datastructures/@cell/eq.m and datastructures/@struct/eq.m are
%  class-directory overloads that define == for cell arrays and structures,
%  and vlt_Init puts them on the path (it genpaths the whole tree). So
%  eqemp({'r','g','b'},{'r','g','b'}) returns 1 rather than erroring.
%
%  Two consequences worth knowing:
%    * Those overloads are global. Once vlt is on the path, == on any cell or
%      struct in the session uses them, not just inside vlt code.
%    * They live only in the legacy datastructures/ tree; there is no +vlt
%      equivalent. Retiring that tree would make this function start erroring
%      on cell and struct inputs. Verified: with datastructures/ off the path,
%      {'a'}=={'a'} throws MATLAB:math:mustBeNumericCharOrLogical.
%
%  See also:  EQ, ISEQUALN, EQTOT, EQLEN

b=1;
xe=isempty(x);
ye=isempty(y);
if (xe&(~ye))|(ye&(~xe)),
	b=0;
elseif ~xe&~ye,
	b=(x==y);
end;
