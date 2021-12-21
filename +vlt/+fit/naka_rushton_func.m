function R=naka_rushton_func(c, c50, n, ss)

% vlt.fit.naka_rushton_func - Evaluate Naka Rushton function
%
%  R=vlt.fit.naka_rushton_func (C, C50, N, S)
%
%  Returns Naka Rushton function:  C^N/(C^(N*S)+c50^(N*S))
%
%  If S is not specified, S is assumed to be 1.
%  If C is negative, the result is negative.
%

if nargin<4, 
	s = 1;
else,
	s = ss;
end;

if nargin<3,
	n = 1;
end;

R = sign(c).*abs(c).^n./(abs(c).^(s*n)+c50.^(s*n));
