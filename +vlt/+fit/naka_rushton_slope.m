function [R,Rdiscrete]=naka_rushton_slope(c, c50, n, ss)

% vlt.fit.naka_rushton_slope - Evaluate slope of Naka Rushton function
%
%  R=vlt.fit.naka_rushton_slope (C, C50, N, S)
%
%  Returns the derivative of the Naka Rushton
%     function: d[C^N/(C^(N*S)+c50^(N*S))]/dc.
%
%  If S is not specified, S is assumed to be 1.
%  If C is negative, the result is negative.
%

if nargin<4, 
	s = 1;
else,
	s = ss;
end;

R_ = sign(c).*abs(c).^n./(abs(c).^(s*n)+c50.^(s*n));

Rdiscrete = diff(R_)./diff(c);

R = n * ((abs(c)).^(n-1)).*(c50^(s*n)+(1-s)*((abs(c)).^(s*n))) ./ ((c.^(s*n)+c50^(s*n)).^2);


