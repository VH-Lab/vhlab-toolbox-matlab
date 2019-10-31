function dD = dangdiff(a,wrap)

% DANGDIFF - Derivative of angular difference in 0..WRAP
%
%  DD = DANGDIFF(A,WRAP)
%
%  Returns numerical derivative of angular difference in 0..wrap
%  Value is always -1, 0, or 1

if min(size(a))==1,
	B=abs([a;a+wrap;a-wrap]);
	C = sign([a;a+wrap;a-wrap]);
	[D,I]=min(B);
	dD=C(sub2ind(size(B),I,1:length(a)));
else,
	error(['this has not been examined...examine code...']);
	B = cat(3,abs(a),abs(a+wrap),abs(a-wrap));
	C = cat(3,sign(a),sign(a+wrap),sign(a-wrap));
	[D,I] = min(B,[],3);
	dD = C(I);
end;
