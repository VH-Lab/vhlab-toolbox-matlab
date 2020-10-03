function D = angdiffwrapsign(a,wrap)
% ANGDIFFWRAPSIGN - Angular difference in 0..WRAP
%
%  D = vlt.math.angdiffwrapsign(A,WRAP)
%
%  Similar to vlt.math.angdiffwrap except sign is preserved.
%  
%  See also: ANGDIGG, vlt.math.angdiffwrap, vlt.math.dangdiffwrap


IND = find(a<wrap/2);
a(IND) = a(IND)+wrap;

IND = find(a>wrap/2);
a(IND) = a(IND)-wrap;

D = a;
