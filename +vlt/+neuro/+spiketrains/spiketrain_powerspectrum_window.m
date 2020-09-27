function [Pxx, Fxx, bandvalues, bands] = spiketrain_powerspectrum_window(spike_train, interval, varargin);
% SPIKETRAIN_POWERSPECTRUM_WINDOW - calculate the power spectrum of a spike train using a sliding window
%
%  [Pxx,Fxx, BANDVALUES, BANDS] = vlt.neuro.spiketrains.spiketrain_powerspectrum_window(SPIKETRAIN,...
%         [START WINDOWSIZE STEP STOP], ...)
%
%  Returns the power spectrum Pxx at different frequencies Fxx.  The power spectrum is
%  calculated from time START to STOP using sliding windows of size WINDOWSIZE.  The
%  window is advanced STEP units each time.
%
%  The power spectrum is calculated by calling the function vlt.neuro.spiketrains.spiketrain_powerspectrum.
%
%  One can modify the default parameters by adding name/value pairs to the function:
%  Parameter (default value)  :  Description
%  --------------------------------------------------------------------------------
%  BINSIZE (0.002)            :  Bin size for spike trains (seconds)
%  NFFT (2^15)               :  Number of FFT values to use in powerspectrum
%  bands ([0.1 4;,...         :  Frequency bands for averaging.
%          4 8; ...
%          8 12; ...
%         12 30]);
%
%
%
% 0.1-4 Hz, theta 4-8, alpha 8-12, beta 12-30
%  
%
%  See also: vlt.neuro.spiketrains.spiketrain_powerspectrum
%
%  

BINSIZE = 0.002;
bands = [0.1 4; 4 8; 8 12; 12 30 ];
NFFT = 2^15;

vlt.data.assign(varargin);

bandvalues = [];

start = interval(1);
windowsize = interval(2);
step = interval(3);
stop = interval(4);

start_times = start:step:stop-windowsize;
if isempty(start_times), start_times = 0; end;
stop_times = start_times + windowsize;

Pxx = [];
bandinds = [];

for i=1:length(start_times),
	z = spike_train(find(spike_train>=start_times(i) & spike_train <= stop_times(i)));
	[Pxx_here, dummy, Fxx] = vlt.neuro.spiketrains.spiketrain_powerspectrum(z,BINSIZE,'NFFT',NFFT);
	Pxx(:,i) = Pxx_here;
	if i==1,
		for j=1:size(bands,1),
			for k=1:2,
				bandinds(j,k) = vlt.data.findclosest(Fxx,bands(j,k));
			end;
		end;
	end;
	for j=1:size(bands,1),
		bandvalues(j,i) = mean(Pxx_here(bandinds(j,1):bandinds(j,2)));
	end;
end;

Pxx = mean(Pxx',1)';
