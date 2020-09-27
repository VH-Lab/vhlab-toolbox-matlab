function weight = stdp_triplet_apply(spiketimes_pre, spiketimes_post, varargin)
% STDP_TRIPLET_APPLY Spike-timing dependent-plasticity for calculating changes in synaptic weights
%
%    WEIGHT = vlt.neuroscience.stdp.stdp_triplet_apply(SPIKETIMES_PRE, SPIKETIMES_POST)
%
%  Calculates the change in synaptic weight due to the triplet
%  SPIKE-TIMING-DEPENDENT-PLASTICITY model curve provided in
%  Pfister and Gerstner 2006 (J Neurosci) and described in
%  Bourjaily and Miller 2011 (Frontiers in Comp. Neurosci):
%
%      For all pairs of pre- and post-synaptic spikes, let the
%      time between them be called dT = t_pre - t_post.
%      If dT < 0, delta_weight = A_plus * exp(dT/tau_plus) 
%      If dT >= 0, delta_weight = A_minus * exp(-dT/tau_minus)
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
%    WEIGHT = vlt.neuroscience.stdp.stdp_triplet_apply(SPIKETIMES_PRE, SPIKETIMES_POST, 'tau_plus',0.050)
%
%  Parameter name:               | default value
%  ------------------------------|-----------------------------
%  tau_plus                      | 0.01668 (units are same as spiketimes)
%  tau_minus                     | 0.0337
%  tau_x                         | 0.101
%  tau_y                         | 0.125
%  A2_plus                       | 5e-5
%  A2_minus                      | 7e-3
%  A3_plus                       | 6.2e-3
%  A3_minus                      | 2.3e-4
%  T0                            | 0
%

tau_plus = 0.01668;
tau_minus = 0.0337;
tau_x = 0.101;
tau_y = 0.125;
A2_plus = 5e-5;
A2_minus = 7e-3;

A3_plus = 6.2e-3;
A3_minus = 2.3e-4;

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
		pre_times = spiketimes_pre(find(spiketimes_pre<spiketimes_allnew(t))); % strictly less
		dT = spiketimes_allnew(t) - post_times;
		doublet = 0;
		if ~isempty(dT),
			doublet = sum(exp(-dT/tau_minus));
		end;
		triplet_dt = spiketimes_allnew(t)-pre_times;
		triplet = 0;
		if ~isempty(triplet_dt),
			triplet = sum(exp(-triplet_dt/tau_x));
		end;
		dW = -doublet * (A2_minus+A3_minus*triplet);
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
			triplet = sum(exp(-triplet_dt/tau_y));
		end;
		dW = doublet * (A2_plus+A3_plus*triplet);
		weight = weight + dW;
	end;
end;
