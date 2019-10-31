function [FWHM,hm_presk_loc,hm_postsk_loc,V_hm, prespk_WHM,postsk_WHM] = spikeFWHM(spikewaves, V_spikepeak, spikepeak_loc, kink_vm, kink_index, samplerate, timevector)

% spikeFWHM - find the full-width, half-maximum range in single spike waveforms
%
% [FWHM] = SPIKEFWHM(SPIKEWAVES, V_SPIKEPEAK, SPIKEPEAK_LOC,V_INITIATION,SAMPLERATE)
%
% Inputs: 
% SPIKEWAVES      | 1D vector containing voltage values for each spikewave
% V_SPIKEPEAK     | 1D vector containing maximum voltage value of every
%                 | spike wave (units V)
% SPIKEPEAK_LOC   | Position value of each spike peak
% KINK_VM         | Value where action potential begins, calculated
%                 | by sister function spikekink (units V)
% SAMPLERATE      | Rate of sampling for each epoch (units Hz), given by ndi_app_spikeextractor 
%                  
% Outputs:
% FWHM            | Full-width half maximum value, calculated from sample rate and converted to ms
% HM_PRESK_LOC    | Position value of half-maximum value before spike peak               | 
% HM_POSTSK_LOC   | Position value of half-maximum value after spike peak
% V_hm            | Voltage value of the half-maximum points (units V)
%
%


     V_hm = (V_spikepeak + kink_vm)/2; % take midpoint between spike kink and spike peak to find halfmax voltage
    
     dV_presk = interp1([spikewaves(kink_index),spikewaves(spikepeak_loc)],[1,2], V_hm);
     dV_postsk = interp1([spikewaves(spikepeak_loc),spikewaves(end)],[1,2], V_hm);
     
     hm_presk_loc = find(spikewaves(1:spikepeak_loc) < V_hm, 1, 'last');  %give pt in gz where 1st 1/2 max fall                                                                                              
     hm_postsk_loc = (find(spikewaves(spikepeak_loc:end) < V_hm, 1, 'first')) + spikepeak_loc-1;
     
      if isempty(hm_postsk_loc),
          hm_postsk_loc = NaN;
      end
     
     prespk_WHM = (1/samplerate)*(spikepeak_loc - (hm_presk_loc+(abs(1.5-dV_presk)))); %subract time positions of spike index and prespike half max to give pre-spike width
     postsk_WHM =  (1/samplerate)*(spikepeak_loc + (hm_postsk_loc-(abs(1.5-dV_postsk)))); %add time positions of spike index and postspike half max to give pre-spike width
     
      if isempty(postsk_WHM),
          postsk_WHM = NaN;
      end 
      
     FWHM = (1/samplerate) * ((hm_postsk_loc-(abs(1.5-dV_postsk))) - (hm_presk_loc+(abs(1.5-dV_presk))+1));
      
      if isempty(FWHM),
          FWHM = NaN;
      end  
      
end