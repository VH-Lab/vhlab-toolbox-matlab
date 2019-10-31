function D = angdiff(a)

% ANGDIFF - Angular difference in 0..360
%
%  D = ANGDIFF(A)
%
%  Returns min(abs([A;A+360;A-360]));
%
%  See also: ANGDIFFWRAP, ANGDIFFWRAPSIGN, DANGDIFFWRAP

flip = 0; 

if size(a,1)>size(a,2), a = a'; flip = 0; end;

D=min(abs([a;a+360;a-360]));

if flip, D = D'; end;
