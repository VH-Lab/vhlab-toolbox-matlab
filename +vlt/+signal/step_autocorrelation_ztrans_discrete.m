function out = step_autocorrelation_ztrans_discrete(alpha, N, z)
% STEP_AUTOCORRElATION_ZTRANS_DISCRETE Evaluate the z-transform of the step-autocorrelation function
%
%  OUT = vlt.signal.step_autocorrelation_ztrans_discrete(ALPHA, N, Z)
%
%  Evalutes the vlt.signal.step_autocorrelation z-transform for a given
%  value of the pulse height ALPHA and pulse width N (samples),
%  and a given value of Z.  Z may be an array.
%

out = [];

n = 1:N-1;

for zi=1:length(z),
	out(zi) = (alpha/N) * (N+sum( (N-n).*(z(zi).^n+(1/z(zi)).^n)));
end;  


