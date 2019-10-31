function D = angdiffwrapsign(a,wrap)
% ANGDIFFWRAPSIGN - Angular difference in 0..WRAP
%
%  D = ANGDIFFWRAPSIGN(A,WRAP)
%
%  Similar to ANGDIFFWRAP except sign is preserved.
%  
%  See also: ANGDIGG, ANGDIFFWRAP, DANGDIFFWRAP


IND = find(a<wrap/2);
a(IND) = a(IND)+wrap;

IND = find(a>wrap/2);
a(IND) = a(IND)-wrap;

D = a;
