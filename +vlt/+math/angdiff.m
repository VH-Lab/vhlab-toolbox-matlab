function D = angdiff(a)

% vlt.math.angdiff - Angular difference in 0..360
%
%  D = vlt.math.angdiff(A)
%
%  Returns min(abs([A;A+360;A-360]));
%
%  See also: vlt.math.angdiffwrap, vlt.math.angdiffwrapsign, vlt.math.dangdiffwrap

flip = 0; 

if size(a,1)>size(a,2), a = a'; flip = 0; end;

D=min(abs([a;a+360;a-360]));

if flip, D = D'; end;
