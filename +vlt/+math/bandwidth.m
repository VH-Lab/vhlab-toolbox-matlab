function bw = bandwidth(low, high)
% BANDWIDTH - calculate the bandwidth between two frequencies
%
% BW = BANDWIDTH(LOW, HIGH)
%
% Calculates bandwidth as log2(HIGH/LOW).
%
% If LOW is NaN or +/-Inf, BW is Inf;
% If HIGH is NaN or +/Inf, BW is Inf.
% Otherwise, BW is log2(HIGH/LOW).
%

if isnan(low) | isinf(low),
	bw = Inf;
elseif isnan(high) | isinf(high),
	bw = Inf;
else,
	bw = log2(high/low);
end;

