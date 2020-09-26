function [W,Werr, shifts, lambda, corrs] = stdp_tripletvscorrelation
% STDP_TRIPLETVSCORRELATION - Examine dependency of weight change vs. time shift, average firing rate, and spike timing correlation correlation


shifts = [-0.010 0.010]; % 10ms, pre/post shift
lambda = [ 0.1 1 10 20 40 50 ]; % mean rates
corrs = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];  % correlations
NumSims = 20;

tres = 0.001;  % time resolution 1ms


W = [];
Werr = [];

N = 100; % 100 spikes

for s=1:length(shifts),
	 % for each mean rate
	for l=1:length(lambda),
		l,
		for c=1:length(corrs),
			% simulate each scenario NumSims times
			W_here = [];
			for n=1:NumSims,
				pre = spiketrain_poisson_n(lambda(l),N,tres);
				post = spiketrain_timingcorrelated(pre+shifts(s),corrs(c));
				W_here(n) = stdp_triplet_apply(pre,post);
			end;
			W(s,l,c) = mean(W_here);
			Werr(s,l,c) = stderr(W_here(:));
		end;
	end;
end;

