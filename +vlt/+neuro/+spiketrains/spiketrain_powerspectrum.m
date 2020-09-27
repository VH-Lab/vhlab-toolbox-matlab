function [Pxx,Pxxc,F] = spiketrain_powerspectrum(spiketimes, sample_interval, varargin)
% SPIKETRAIN_POWERSPECTRUM - Compute power spectrum of a spiketrain using pmtm
%
%  [Pxx,Pxxc,F] = vlt.neuro.spiketrains.spiketrain_powerspectrum(SPIKETIMES, TIME_RESOLUTION)
%
%  Use the Tomson Multi-Taper method (see help pmtm) to calculate the 
%  power spectrum of a list of SPIKETIMES, sampled with time resolution
%  TIME_RESOLUTION (e.g., 0.001 for 1/1000 of the units of SPIKETIMES).
%
%  One may modify the behavior of the function by passing name/value
%  pairs:
%  Parameter (default value) :  Description
%  ------------------------------------------------------------------------
%  NFFT ([])                 :  Number of points to include in the FFT
%                            :     (see HELP PMTM)
%
%
%  Example:
%    dt = 0.001;
%    t = 0:dt:100;  % 100 seconds long
%    rate = 10*vlt.math.rectify(cos(2*pi*0.5*t)*dt); % 
%    spiketimes = t(find(rand(size(rate))<rate)); 
%    [Pxx,Pxxc,F] = vlt.neuro.spiketrains.spiketrain_powerspectrum(spiketimes,0.01);
%    figure;
%    loglog(F,Pxx); 
%    hold on;
%    loglog(F,Pxxc(:,1),'r-');
%    loglog(F,Pxxc(:,2),'r-');
%    title('Tomson Multitaper Power Spectral Density Estimate');
%    xlabel('Frequency (Hz)');
%    ylabel('Power/frequency (dB/Hz)');
%   

NFFT = [];

vlt.data.assign(varargin{:});

if ~isempty(spiketimes),
	timebins = min(spiketimes):sample_interval:max(spiketimes);
else,
	timebins = [];
end;

if isempty(timebins), timebins = 0:sample_interval:30; end;
if length(timebins)<2, timebins = (0:sample_interval:30) + spiketimes(1); end;
if timebins(end)-timebins(1)<30, timebins = (0:sample_interval:30) + spiketimes(1); end;
spikebins = vlt.neuro.spiketrains.spiketimes2bins(spiketimes,timebins);
[Pxx,Pxxc,F] = pmtm(spikebins,[],[NFFT],1/sample_interval,'adapt','onesided');

%[Pxx,F] = pwelch(spikebins,[],[],[],1/sample_interval);
%Pxxc = [Pxx(:)' Pxx(:)']*0;


