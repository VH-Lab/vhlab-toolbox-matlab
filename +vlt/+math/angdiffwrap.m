function D = angdiff(a,wrap)

% vlt.math.angdiff - Angular difference in 0..WRAP
%
%  D = vlt.math.angdiff(A,WRAP)
%
%  Returns min([A;A+WRAP;A-WRAP]);
%  See also: vlt.math.angdiff, vlt.math.angdiffwrapsign, vlt.math.dangdiffwrap


if min(size(a))==1,
	D=min(abs([a;a+wrap;a-wrap]));
else,
	B = cat(3,abs(a),abs(a+wrap),abs(a-wrap));
	D = min(B,[],3);
end;
