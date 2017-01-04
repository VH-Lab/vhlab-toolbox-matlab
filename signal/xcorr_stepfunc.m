function [corr,mystepfunc] = xcorr_stepfunc(t1, signal1, maxlag, t2, signal2)
% XCORR_STEPFUNC - Perform correlation between a time series and a step function
%
% [CORR,LAGS] = XCORR_STEPFUNC(T1, SIGNAL1, MAXLAG, T2, SIGNAL2)
%
%  Computes the discrete approximation to the correlation
%   between a signal (SIGNAL1), which is sampled at times T1,
%   and up to N step-function signals in the columns SIGNAL2,
%   which change values at times T2.  SIGNAL2 does not have to
%   have the same sample interval (sample rate) as SIGNAL1.
%   Note that values of SIGNAL2 that are out of the range
%   are set to 0.
%   
%   MAXLAG is the maximum lag to examine (in samples of SIGNAL1)
%
%  See also: XCORR, STEPFUNC, CORRELATION_STEPFUNC


corr = [];

for i=size(signal2,2):-1:1,
	mystepfunc = stepfunc(t2,signal2(:,i)',t1,0);
	[corr(:,i), lags] = xcorr(signal1(:),mystepfunc(:),maxlag,'biased');
end;

return;

corr = zeros(length(corr_times),size(signal2,2));
dt = t1(2) - t1(1);

corr_times = round2sample(corr_times, dt);

for t=1:length(t1),
	corr = corr +...
		 dt*signal1(t)*stepfunc(t2,signal2',round2sample(t1(t)-corr_times,dt),0)'/(t1(end)-t1(1)+dt);
end;

return;



 % This code does the same and is faster but takes more memory; let's not use it and be kind to RAM
 % note there has been a change of variable names in the code above since the code below was written

avgs = zeros(length(kerneltimes), size(stim,2), length(spiketimes));

for s=1:length(spiketimes),
	mydata = stepunc(stimtimes,stim',spiketimes(s)-kerneltimes,0);
	avgs(:,:,s) = stepfunc(stimtimes,stim',spiketimes(s)-kerneltimes,0)';
end;

avgstim = mean(avgs,3);

