function R=naka_rushton_func(c, c50, n, ss)

% NAKA_RUSHTON_FUNC - Evaluate Naka Rushton function
%
%  R=NAKA_RUSHTON_FUNC (C, C50, N, S)
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

R = sign(c).*abs(c).^n./(abs(c).^(s*n)+c50.^(s*n));
