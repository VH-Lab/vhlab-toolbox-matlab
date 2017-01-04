function [corr] = correlation_stepfunc(t1, signal1, corr_times, t2, signal2)

% CORRELATION_STEPFUNC - Perform correlation between a time series and a step function
%
% CORR = CORRELATION(T1, SIGNAL1, CORR_TIMES, T2, SIGNAL2)
%
%  Computes the discrete approximation to the correlation
%   between a signal (SIGNAL1), which is sampled at times T1,
%   and up to N step-function signals in the columns SIGNAL2,
%   which change values at times T2.  SIGNAL2 does not have to
%   have the same sample interval (sample rate) as SIGNAL1.
%   Note that values of SIGNAL2 that are out of the range
%   are set to 0.
%
%  WARNING: At present, this function produces tiny differences between
%  XCORR of the step function and SIGNAL1. I am at a loss to explain it...
%
%  The correlation function is:
%
%      Integral({t from T1(1) to T1(end)}, dt * SIGNAL1*SIGNAL2)
%	(Dayan and Abbott 2005, equation in chapter 1)
%
%  and the discrete version is:
%      Let dt = T1(2)-T1(1)  (use signal 1's sample interval)
%      CORR(tau) = sum over all times t in T1: dt*SIGNAL1(t)*SIGNAL2(t-tau)
%      where TAU assumes all values listed in the vector CORR_TIMES.
%
%  See also: XCORR, STEPFUNC, XCORR_STEPFUNC

   % damn it, there is some tiny error in this that I can't find; this uses
   % less memory but it is slightly off and for reverse correlations with non-white stimuli it
   % can matter, some reconstructions become unstable

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

