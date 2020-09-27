function weight = stdp_eltpi_apply(spiketimes_pre, spiketimes_post, varargin)
% STDP_ELTPI_APPLY Spike-timing dependent-plasticity for calculating changes in synaptic weights
%
%    WEIGHT = vlt.neuroscience.stdp.stdp_eltpi_apply(SPIKETIMES_PRE, SPIKETIMES_POST)
%
%  Calculates the change in synaptic weight due to the early LTPi 
%  rule discovered by Maffei and colleages (unpublished). The model
%  is closely related to the triplet SPIKE-TIMING-DEPENDENT-PLASTICITY
%  model curve provided in Pfister and Gerstner 2006 (J Neurosci)
%  and described in Bourjaily and Miller 2011 (Frontiers in Comp.
%  Neurosci):
%
%      For all pairs of pre- and post-synaptic spikes, let the
%      time between them be called dT = t_pre - t_post.
%      If dT < 0, delta_weight = A_plus * exp(dT/tau_plus) 
%      If dT >= 0, delta_weight = A_minus * exp(dT/tau_minus)
%
%  In addition, this pre/post synaptic activity is boosted by
%  integrating the pre (tau_y) or post (tau_x) rate activity as
%  described in Bourjaily and Miller 2011. (describe this better)
%
%  The "boost" is further modified by a gaussian transformation
%  such that the effect is boosted only at particular firing rates
%  close the center of the gaussian.
%  
%  WEIGHT is a factor that indicates how the maximumal
%  conductance is modified. In Song and Abbott, the synaptic 
%  conductance was modified by the following forumla:
%  G -> G + G_max * WEIGHT
%
%  Only spikes that occur at or after the time T0 will be examined for STDP.
%  By default, T0 is 0.  (One could use this to restrict the influence
%  of STDP to spike pairs where at least one member of the pair occurs
%  after a particular time.)
%  
%  The parameters of the synapse can be varied by providing additional 
%  inputs as name, value pairs. The names and values that are default are
%  shown here. For example,
%    WEIGHT = vlt.neuroscience.stdp.stdp_eltpi_apply(SPIKETIMES_PRE, SPIKETIMES_POST, 'tau_plus',0.050)
%
%  Parameter name:               | default value
%  ------------------------------|-----------------------------
%  tau_plus                      | 0.100 (units are same as spiketimes)
%  tau_minus                     | 0.100
%  tau_x                         | 0.100
%  tau_y                         | 0.100
%  tau_x2                        | 0.025
%  tau_y2                        | 0.025
%  A2_plus                       | 0.00001  
%  A2_minus                      |-0.00001  
%  A3_plus                       | 1e-3
%  A3_minus                      |-1e-3
%  A4_minusgaussmean             | 1.4 (from sum(exp(-(0:1/8:10)/tau_x)) ), 8Hz peak
%  A4_minusgausswidth            | 0.17 (from diff of 8Hz and 6Hz values above)
%  A4_plusgaussmean              | 1.4 
%  A4_plusgausswidth             | 0.17
%  T0                            | 0
%

%error(['This function is not ready yet']);

tau_plus = 0.100;
tau_minus = 0.100;
tau_x = 0.100;
tau_y = 0.100;
tau_x2 = 0.025;
tau_y2 = 0.025;
A2_plus = 1e-5; 
A2_minus = -1e-5;

A3_plus = 1e-3;
A3_minus = -1e-3;

A4_minusgaussmean = 0.39;
A4_minusgausswidth = 0.1;
A4_plusgaussmean = 0.39;
A4_plusgausswidth = 0.1;

T0 = 0;

vlt.data.assign(varargin{:});

 % the slow way is to really consider all pairs of spikes

weight = 0;

spiketimes_pre = sort(spiketimes_pre);
spiketimes_post = sort(spiketimes_post);
spiketimes_all = unique([spiketimes_pre(:); spiketimes_post(:)]);
spiketimes_allnew = spiketimes_all(find(spiketimes_all>=T0));

for t=1:length(spiketimes_allnew),
	prehere = find(spiketimes_pre==spiketimes_allnew(t));
	if ~isempty(prehere),
		% these will be post-before-pre interactions
		post_times = spiketimes_post(find(spiketimes_post<=spiketimes_allnew(t)));
		postrate_times = spiketimes_post(find(spiketimes_post<spiketimes_allnew(t))); % strictly less
		pre_times = spiketimes_pre(find(spiketimes_pre<spiketimes_allnew(t))); % strictly less
		dT = spiketimes_allnew(t) - post_times;
		doublet = 0;
		if ~isempty(dT),
			doublet = sum(exp(-dT/tau_minus));
		end;
		triplet_dt = spiketimes_allnew(t)-postrate_times; % use the current post-synaptic rate
		triplet = 0;
		if ~isempty(triplet_dt),
			triplet = sum(exp(-triplet_dt/tau_x)-exp(-triplet_dt/tau_x2));
		end;
		dW = -doublet * (A2_minus+A3_minus*exp(-((triplet-A4_minusgaussmean).^2)/(2*A4_minusgausswidth^2)));
		weight = weight + dW;
	end;
	posthere = find(spiketimes_post==spiketimes_allnew(t));
	if ~isempty(posthere),
		% these will be pre-before-post interactions
		pre_times = spiketimes_pre(find(spiketimes_pre<=spiketimes_allnew(t)));
		post_times = spiketimes_post(find(spiketimes_post<spiketimes_allnew(t))); % strictly less
		dT = pre_times - spiketimes_allnew(t);
		doublet = 0;
		if ~isempty(dT),
			doublet = sum(exp(dT/tau_plus));
		end;
		triplet_dt = spiketimes_allnew(t)-post_times;
		triplet = 0;
		if ~isempty(triplet_dt),
			triplet = sum(exp(-triplet_dt/tau_y)-exp(-triplet_dt/tau_y2));
		end;
		dW = doublet * (A2_plus+A3_plus*exp(-((triplet-A4_plusgaussmean).^2)/(2*A4_plusgausswidth^2)));
		weight = weight + dW;
	end;
end;
