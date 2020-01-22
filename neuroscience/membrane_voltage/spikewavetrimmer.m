function [spikewave_Vtrim, firstNZpt,spikepeak_trim_loc, lastNZpt] = spikewavetrimmer(spikewave, spikepeak_loc)
% SPIKEWAVETRIMMER - remove the zero padding from spikewave and yield the time preceding spike peaks
% [SPIKEWAVE_VTRIM] = SPIKEWAVETRIMMER(SPIKEWAVE, SPIKEPEAK_LOC)
%
% Inputs:        
% SPIKEWAVE          | 1D vector containing values for voltage at every
%                    | timestep in spike_trace (units V)
% SPIKEPEAK_LOC      | Position of spike peak location
%
% Outputs:
% SPIKEWAVE_VTRIM    | A trimmed vector of spikewave voltages with all
%                    |  0 padding removed and replaced with the leading (or
%                    |  trailing) non-zero data points at the beginning and
%                    |  end of the wave, respectively.
% 
%
%
%

V_mod = spikewave;

firstNZpt = find(spikewave, 1,'first'); %calculate first non-zero voltage value in spikewave
if ~isempty(firstNZpt),
	V_mod(1:firstNZpt-1) = V_mod(firstNZpt);
end
        
lastNZpt = find(spikewave(spikepeak_loc:end), 1, 'last') + spikepeak_loc-1; %calculate second non-zero voltage value in spikewave
if ~isempty(lastNZpt)
	V_mod(lastNZpt+1:end) = V_mod(lastNZpt); 
end

if isnan(lastNZpt)
	lastNZpt = size(spike_wave,1);
	V_mod(lastNZpt) = V_mod(NZpt);  % NZpt not defined, this will cause an error, not sure why it is here
end
        
spikewave_Vtrim = V_mod(firstNZpt:lastNZpt);
spikepeak_trim_loc = spikepeak_loc - firstNZpt;
        
if isempty(spikewave_Vtrim),
	error(['Empty trimmed spikewave']);
end

