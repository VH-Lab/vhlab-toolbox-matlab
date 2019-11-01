function [spikewaves_Vtrim, firstNZpt,spikepeak_trim_loc, lastNZpt] = spiketrimmer(spikewaves, spikepeak_loc)

% SPIKETRIMMER - remove the zero padding from spikewaves and yield the time preceding spike peaks
% [KINK_VM, MAX_DVDT, KINK_INDEX_] = SPIKEKINK(SPIKE_TRACE, T, SPIKE_INDEXES, ...)
%
% Inputs:        
% SPIKEWAVES      | 1D vector containing values for voltage at every
%                 | timestep in spike_trace (units V)
% SPIKEPEAK_LOC   | Position of spike peak location
%
% Outputs:
% SPIKEWAVES_ | A trimmed vector of spikewaves' voltages with all padding removed
%
%
%
    V_mod = spikewaves;

    firstNZpt = find(spikewaves, 1,'first'); %calculate first non-zero voltage value in spikewaves
        if ~isempty(firstNZpt),
            V_mod(1:firstNZpt-1) = V_mod(firstNZpt);
        end
        
    lastNZpt = find(spikewaves(spikepeak_loc:end), 1, 'last') + spikepeak_loc-1; %calculate second non-zero voltage value in spikewaves
        if ~isempty(lastNZpt)
            V_mod(lastNZpt+1:end) = V_mod(lastNZpt);
        end
        if isnan(lastNZpt)
           lastNZpt = size(spike_wave,1);
           V_mod(lastNZpt) = V_mod(NZpt);    
        end
    spikewaves_Vtrim = V_mod(firstNZpt:lastNZpt);
    spikepeak_trim_loc = spikepeak_loc - firstNZpt;
        
        if isempty(spikewaves_Vtrim),
            firstNZpt = 1;
            lastNZpt = size(spikewaves,1);
            spikepeak_trim_loc = spikepeak_loc;
            spikewaves_Vtrim = V_mod(firstNZpt:lastNZpt);
            keyboard,
        end

end
