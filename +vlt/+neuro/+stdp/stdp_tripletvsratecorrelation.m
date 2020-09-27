function [W,Werr,shifts,freqs,lambda] = stdp_tripletvsratecorrelation

lambda = [ 0.1 1 10 20 40 50]; % mean rates
NumSims = 20;

tres = 0.001;  % time resolution 1ms

freqs = [0.1 0.5 1 5 10 20 30 50 70 100 150]; 

T = 0:0.001:100;

shifts = [-0.020 -0.010 0 0.010 0.020];

W = [];
Werr = [];

for s=1:length(shifts),
	preshift = 0;
	postshift = 0;
	if shifts(s)<0,
		preshift = -shifts(s);
	else,
		postshift = shifts(s);
	end;
	for f=1:length(freqs),
		 % for each mean rate
		for l=1:length(lambda),
			l,
			% simulate each scenario NumSims times
			W_here = [];
			for n=1:NumSims,
				pre = preshift+T(find(rand(size(T))<(tres*lambda(l)*sin(2*pi*freqs(f)*T))));
				post = postshift+T(find(rand(size(T))<(tres*lambda(l)*sin(2*pi*freqs(f)*T))));
				W_here(n) = vlt.neuroscience.stdp.stdp_triplet_apply(pre,post);
			end;
			W(s,f,l) = mean(W_here);
			Werr(s,f,l) = vlt.stats.stderr(W_here(:));
		end;
	end;
end;
