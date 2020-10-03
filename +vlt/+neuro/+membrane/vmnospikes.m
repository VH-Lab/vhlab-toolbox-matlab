function [vmns,t,spiketimes] = vmnospikes(vm,si,varargin)
% VMNOSPIKES - Return underlying voltage with spikes removed
%
%  [VMNS,T,SPIKETIMES] = vlt.neuro.membrane.vmnospikes(VM, SI)
%
%  Removes spikes from the trace VM with sample interval SI.
%  Optionally, one can re-sample at a higher SI (lower sampling rate).
%
%  SPIKETIMES that were detected are returned in SPIKETIMES.
%
%  The behavior of this function can be modified by passing name/value
%  pairs:
%
%  Parameter (default):     | Description:
%  ---------------------------------------------------------------
%  newsi (si)               | If the interval is higher than si,
%                           |   then the waveform is smoothed (boxcar)
%                           |   and downsampled.
%  filter_algorithm         | Filter algorithm: choice of 'vlt.signal.removespikes', which employs
%     ('vlt.signal.removespikes')      |   detects spikes and removes them with vlt.signal.removespikes;
%                           |   or 'medfilt1' which performs a median filter using MEDFILT1
%  spiketimes ([])          | Extracted spike times from the trace
%                           |   (if empty, then spikes are extracted using
%                           |   threshold crossing and vlt.signal.refractory period)
%                           |   Spike times are in same units as SI
%                           |   and are relative to Tstart
%  thresh (-0.030)          | Spike threshold for spike detection (not used
%                           |   if spiketimes is given)
%  refract (0.0025)         | Refractory period (in same units as SI)
%  MedFilterWidth           | MedFilterWidth (see MEDFILT1)
%      (round(0.004/SI) )   | 
%  Tstart (0)               | Time of the first sample of the VM trace
%  removespikes_inputs ({}) | Any custom inputs we should pass to vlt.signal.removespikes
%                           |   (see vlt.signal.removespikes)
%  rm60hz (1)               | 0/1 should we filter 60Hz noise? (uses vlt.signal.remove60hz)
%  rm60hz_inputs ({})       | Any custom arguments we should pass to vlt.signal.remove60hz
%                           |   (see vlt.signal.remove60hz)
%

spiketimes = [];
thresh = -0.030;
refract = 0.0025;
Tstart = 0;
removespikes_inputs = {};
rm60hz = 1;
newsi = si;
rm60hz_inputs = {};
MedFilterWidth = [];

filter_algorithm = 'vlt.signal.removespikes';

vlt.data.assign(varargin{:});

if isempty(MedFilterWidth),
	MedFilterWidth = round(0.004 / si);
end;

t = Tstart + [0:si:(length(vm)-1)*si];

if isempty(spiketimes)
	spiketimes_samples = vlt.signal.threshold_crossings(vm,thresh); % in samples
	spiketimes = t(spiketimes_samples); % now in time
	spiketimes = vlt.signal.refractory(spiketimes,refract); % apply vlt.signal.refractory period 
end;

switch lower(filter_algorithm),
	case 'vlt.signal.removespikes',
		vmns=vlt.signal.removespikes(vm,[Tstart si],spiketimes,removespikes_inputs{:});
	case 'medfilt1',
		vmns=medfilt1(vm,MedFilterWidth);
	otherwise,
		error(['Unknown voltage filter algorithm: ' filter_algorithm]);
end;

if rm60hz,
	vmns = vlt.signal.remove60hz(vmns,1/si,rm60hz_inputs{:});
end;

if newsi>si,
	smooth_window = max(1,round(newsi/si));
	vmns = smooth(vmns,smooth_window);
	Tn = t(1):newsi:t(end);
	vmns = interp1(t,vmns,Tn,'nearest');
	t = Tn;
end;

