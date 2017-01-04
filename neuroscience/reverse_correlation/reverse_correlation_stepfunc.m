function [rev_corr, rev_corr_raw, xc_stimsignal, xc_stimstim] = reverse_correlation_stepfunc(spiketimes, signal_t, kerneltimes, stimtimes, stim, varargin)
% REVERSE_CORRELATION_STEPFUNC - Performs RC between a spike train and step function stimulus
%
% [REV_CORR, REV_CORR_RAW, XC_STIMSIGNAL, XC_STIMSTIM] = ...
%        REVERSE_CORRELATION_STEPFUNC(SPIKETIMES, SIGNAL_T, STIM_OFFSETS, STIMTIMES, STIM)
%
%   This function performs reverse correlation between a spike train with spikes at SPIKETIMES
%   and a stimulus STIM to obtain the best linear filter (FIR Wiener filter) that can be used to reconstruct
%   the underlying response kernel from the STIM. It achieves this by computing:
%
%       REV_CORR_RAW = Rinv * XC_STIMSIGNAL, where XC_STIMSIGNAL is the correlation between
%       the SIGNAL and STIM, and Rinv is the inverse of the covariance matrix R of the stimulus.
%       This matrix R is computed from the autocorrelation of the stimulus XC_STIMSTIM.
%
%   Further, this function offers the ability to return a filtered version of REV_CORR_RAW, which is often
%   necessary when the stimulus STIM is not purely white.
%   
%   Inputs:
%       SPIKETIMES is an array of spike times
%       SIGNAL_T is the time of each sample in the stimulus record (used to calculate
%          the autocorrelation of the stimulus)
%       STIM_OFFSETS is a list of times of SPIKETIMES relative to STIM over which
%                  to compute the correlation.
%	The stimulus is assumed to be a step function that assumes different
%       values at each step.  STIMTIMES is a list of the time of each step,
%       and STIM is a matrix of row vectors, where each column corresponds to 
%       one stimulus variable.
%       In calculating the autocorrelation of the stimulus, it is assumed that each
%       column vector of the stimulus has the same statistics.
%   Outputs:
%       REV_CORR is the filtered reverse correlation kernel for each time lag (rows) and
%         each spatial component the kernel (columns).
%         REV_CORR is filtered according to the parameters below (typically a median filter)
%         in order to aid in removing the influence of a non-white stimulus.
%         REV_CORR has units of units('SIGNAL') / (units('STIM') * units('dt') * units('dx'))
%       REV_CORR_RAW is the unfiltered reverse correlation for each lag (rows) and
%         each spatial component of the kernel (columns).
%         REV_CORR_RAW has units of units('SIGNAL') / (units('STIM') * units('dt') * units('dx'))
%       XC_STIMSIGNAL is the correlation between SIGNAL and the STIM. Lags are in rows and
%         spatial components are in columns. XC_STIMSIGNAL has units of units('SIGNAL') * units('STIM')
%       XC_STIMSTIM is the autocorrelation of the STIM for different lags. It has units of
%         units('STIM')^2
%
%   Note: IF you have a theoretically-determined autocorrelation function for your stimulus,
%         it is highly recommended that you pass it to REVERSE_CORRELATION_MV_STEPFUNC as a
%         name/value pair ('xc_stimstim', myxc). This will reduce the likelihood of an unstable/garbage
%         solution.
%
%   See Dayan and Abbott (2005), Chapters 1-2, and any source on FIR Optimal Filtering / FIR Wiener Filtering
%
%   This function also accepts extra parameter inputs in the form of PARAMETER/VALUE
%   pairs that modify default behavior:
%   Parameter (default)        | Description
%   ----------------------------------------------------------------------------------
%   DoMedFilter (1)            | Perform a median filter on the output to deal with
%                              |   noise due to non-white stimulus
%   MedFilterWidth (3)         | Width of the median filter
%   xc_stimstim ([])           | If empty, then xc_stimstim is computed empircally from
%                              |   the stimulus. Otherwise, the xc_stimstim can be specified,
%                              |   which might be useful if the theoretical shape of the 
%                              |   stimulus autocorrelation is known. xc_stimstim(1) should be
%                              |   the autocorrelation with 0 lag, xc_stimstim(2) should be the
%                              |   autocorrelation with lag 1, etc.
%   Rinv ([])                  | The 'whitening function', determined by inverting the 
%                              |   autocorrelation function. If empty, then it is calculated
%                              |   from xc_stimstim.
%   normalize (1)              | Perform normalization of the kernel by dx and dt
%   dx (1)                     | Resolution of kernel in columns
%   dt (1)                     | Resolution of kernel in time
%
%  See also:  STEPFUNC, DIRRFMODEL_EXAMPLE2, FIRWIENER

DoMedFilter = 1;
MedFilterWidth = 3;
xc_stimstim = [];
Rinv = [];
normalize = 1;
dx = 1;
dt = 1;

debug_plot = 0;

assign(varargin{:});

   % Note: KERNELTIMES corresponds to STIM_OFFSETS in the docs

% Step 1: compute the correlation of the SIGNAL and the STIMULUS

xc_stimsignal = spike_triggered_average_stepfunc(spiketimes,kerneltimes,stimtimes,stim);

% Step 2: compute the autocorrelation of the stimulus, if necessary

if isempty(xc_stimstim),
	xc_stimstim = xcorr_stepfuncstepfunc(signal_t,stimtimes,stim,length(kerneltimes),stimtimes,stim);
	center_of_correlation = (size(xc_stimstim,1)+1)/2;  % only take the reverse side
		% only take the reverse side, don't need both sides of autocorrelation 
	xc_stimstim = xc_stimstim( center_of_correlation:center_of_correlation+length(kerneltimes)-1, :);
	xc_stimstim = mean(xc_stimstim,2); % do mean across columns
end;

% Step 3: compute the inverse of the covariance matrix, which is built from the autocorrelation of the stimulus

if isempty(Rinv),
	[Rinv,R] = whitening_filter_from_autocorr(xc_stimstim, length(kerneltimes));
end;

if debug_plot,
	figure;
	subplot(2,2,1);
	plot(xc_stimstim)
	subplot(2,2,2);
	plot(Rinv(:,1),'-o')
end;

% Step 4: compute the raw reverse correlation

rev_corr_raw = Rinv * xc_stimsignal;

if normalize,
	rev_corr_raw = rev_corr_raw / (dx * dt);  % put it in appropriate units
end;
	
% Step 5: If necessary, filter the reverse correlation kernel

if DoMedFilter,
	rev_corr = medfilt1(rev_corr_raw, MedFilterWidth);
else,
	rev_corr = rev_corr_raw;
end;

