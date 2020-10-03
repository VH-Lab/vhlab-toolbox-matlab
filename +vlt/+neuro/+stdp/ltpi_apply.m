function weight = ltpi_apply(spiketimes_pre, spiketimes_post, varargin)
% LTPI_APPLY Spike-timing dependent-plasticity for calculating changes in synaptic weights
%
%    WEIGHT = vlt.neuro.stdp.ltpi_apply(SPIKETIMES_PRE, SPIKETIMES_POST)
%
%  Calculates the change in synaptic weight due to the "veto" long 
%  term potentiation of inhibition rule based on the experimental
%  data of Maffei et. al 2006 (Nature) and on the equations in
%  Bourjaily and Miller 2011 (Frontiers in Computational Neuroscience).
%  
%      For all presynaptic (inhibitory) spikes, we look to see if there
%      is a postsynaptic spike in the interval [t_pre-tau_minus,
%      tpre+tau_plus]. If so, there is an inhibitory potentiation:
%      weight = weight + dIW
%
%  WEIGHT is a factor that indicates how the maximumal
%  conductance is modified.In Song and Abbott (2001), the synaptic 
%  conductance was modified by the following forumla:
%  G -> G + G_max * WEIGHT
%
%  Only spikes that occur at or after the time T0 will be examined for STDP.
%  By default, T0 is 0.  (One could use this to restrict the influence
%  of STDP to spike pairs where at least one member of the pair occurs
%  after a particular time.)
%
%  Normally, we do not know what additional spikes are coming in the future.
%  The code assumes that we only know up to time of the latest spike in
%  the 2 trains. (That is, if an inhibitory spike is the last spike to occur,
%  and it has no postsynaptic partners, then we do not yet know if it will
%  generate a potentiation event.  One can explicitly set T1 to indicate
%  the latest time that we have information for (which might be later than
%  the latest spike time).
% 
%  
%  
%  
%  The parameters of the synapse can be varied by providing additional 
%  inputs as name, value pairs. The names and values that are default are
%  shown here. For example,
%    WEIGHT = vlt.neuro.stdp.ltpi_apply(SPIKETIMES_PRE, SPIKETIMES_POST, 'tau_plus',0.050)
%
%  Parameter name:               | default value
%  ------------------------------|-----------------------------
%  tau_plus                      | 0.020 (units are same as spiketimes)
%  tau_minus                     | 0.020
%  dIW                           | 0.001 (a 1% change)
%  T0                            | 0
%  T1                            | max(spiketimes_pre(end),spiketimes_post(end))

tau_plus = 0.020;
tau_minus = 0.020;
dIW = 0.001;

T0 = 0;
T1 = max(spiketimes_pre(end),spiketimes_post(end));

vlt.data.assign(varargin{:});

 % the slow way is to really consider all pairs of spikes

eps = 1e-6;

weight = 0;

%spiketimes_pre = sort(spiketimes_pre);
%spiketimes_post = sort(spiketimes_post);
%spiketimes_all = unique([spiketimes_pre(:); spiketimes_post(:)]);
%spiketimes_allnew = spiketimes_all(find(spiketimes_all>=T0));

 % strategy:
 %   Two steps, a backward and forward step
 %   1) Backward step: Figure out if we have any spikes that occurred before T0 that were not possible to assign previously
 %      a) Find pre spikes in interval [TO-tau_minus]
 %      b) For each of these spikes, see if any of these had post partners before T0; if so, then we know they not generate a potentiation
 %      c) if there are no partners, then it remains unknown whether these spikes will generate an inhibitory potentiation
 %      d) If T0 == t_spike-tau_minus (within epsilon), then declare it "known" and generate a potentiation event 
 %   2) Foward step:
 %      a) Find the latest spike we know about, t_latest
 %      b) Check all presynaptic spikes up to t_latest-tau_minus, and see if they have partners
 %      c) Generate a potentiation event for all of those that do not have partners; events later than that are unknown
%             until we have evidence that more time has passed

 % backward step
[spiketimes_pre_unknown_ind] = find( (T0-tau_minus)>=spiketimes_pre & spiketimes_pre<T0);
spiketimes_pre_unknown = spiketimes_pre(spiketimes_pre_unknown_ind);
for t=1:length(spiketimes_pre_unknown),
	if ~any( ((spiketimes_pre_unknown(t)-spiketimes_post)>=0 & (spiketimes_pre_unknown(t)-spiketimes_post)<=tau_minus) | ...
           ((spiketimes_pre_unknown(t)-spiketimes_post)<0 & (spiketimes_pre_unknown(t)-spiketimes_post)>=-tau_plus)),
		% then it remains unknown unless T0==spiketimes_pre_unknown(t)+tau_minus
		if abs(spiketimes_pre_unknown(t)-(T0-tau_minus))<eps,
			weight = weight + dIW;
		end;
	end;
end;

 % now we've dealt with all spikes before T0

 % going foward we can only deal with spikes up to the latest spike we know about
 % if there is an inhibitory spike within tau_plus of this time, and no corresponding post spike, we don't know its status
 % forward step

t_latest = T1;
[spiketimes_pre_new_inds] = find(spiketimes_pre>=T0);
spiketimes_pre_new = spiketimes_pre(spiketimes_pre_new_inds);

for t=1:length(spiketimes_pre_new),
        % for debugging
	%A = (spiketimes_pre_new(t)-spiketimes_post)>=0;
	%B = (spiketimes_pre_new(t)-spiketimes_post)<=tau_minus;
	%C = A&B;
	%D = (spiketimes_pre_new(t)-spiketimes_post)<0;
	%E = (spiketimes_pre_new(t)-spiketimes_post)>=-tau_plus;
	%F = D&E;
	%G = C | F;

	if ~any( ((spiketimes_pre_new(t)-spiketimes_post)>=0 & (spiketimes_pre_new(t)-spiketimes_post)<=tau_minus) | ...
           ((spiketimes_pre_new(t)-spiketimes_post)<0 & (spiketimes_pre_new(t)-spiketimes_post)>=-tau_plus)),
		if spiketimes_pre_new(t) <= t_latest-tau_plus, % then we know we'll never find a future partner for this spike
			weight = weight + dIW;
		end;
	end;
end;


