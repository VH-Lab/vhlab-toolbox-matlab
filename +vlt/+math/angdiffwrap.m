function D = angdiff(a,wrap)

% ANGDIFF - Angular difference in 0..WRAP
%
%  D = ANGDIFF(A,WRAP)
%
%  Returns min([A;A+WRAP;A-WRAP]);
%  See also: ANGDIFF, ANGDIFFWRAPSIGN, DANGDIFFWRAP


if min(size(a))==1,
	D=min(abs([a;a+wrap;a-wrap]));
else,
	B = cat(3,abs(a),abs(a+wrap),abs(a-wrap));
	D = min(B,[],3);
end;
