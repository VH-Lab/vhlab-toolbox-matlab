function [g,g_] = probabilistic_release(varargin)



t_start = -0.1;
t_end = 1;
dt = 1e-5;

presyn_times = [ 0 0.5 ]; % presynaptic spike times

N = 20;   % number of vescicles
P = 0.5;  % peak release probability
Q = 0.1e-6; % peak conductance due to receptors processing 1 quanta
V_recovery_time = 0.1;

 % quantal, receptor-based synaptic time constants
syn_tau1 = 0.001; % onset
syn_tau2 = 0.005; % offset

 % release probability parameters, from Xu-Friedman and Regehr 2000
P_A = 2.47; 
P_tau1 = 6.4e-3;
P_tau2 = 64e-3;
P_B = 0.04;
 % A exp(-t/tau1) + B exp(-t/tau2)

facilitation_increase = 0.3;
facilitation_tau = 0.100;

assign(varargin{:});

if exist('Released_times','var'),
	have_released_times = 1;
else,
	have_released_times = 0;
end;

t = t_start:dt:t_end;

p_release_waveform_t = 0:dt:1;
t_ = 0;
   % need to pick a max value less than 1 for failure proportional calc
p_release_waveform   = ((P_A*exp(-(p_release_waveform_t-t_)/P_tau1)+...
		P_B*exp(-(p_release_waveform_t-t_)/P_tau2))/(P_A+P_B));
p_release_waveform = p_release_waveform/sum(p_release_waveform);

Released = zeros(numel(presyn_times), N);

if ~have_released_times,
	Released_times = cell(1,N);

	for i=1:numel(presyn_times),
		for j=1:N,
			A = isempty(Released_times{j}); % did we never release?
			B = any(Released_times{j}>=(presyn_times(i)-V_recovery_time)); % are we recovered if we need to be?
			if A | ~B, 
				% facilitation
				f = 0;
				for k=1:i-1
					f = f+facilitation_increase * exp( - (presyn_times(i)-presyn_times(k))/facilitation_tau);
				end;
				P_here = min(P + f,1);
				Released(i,j) = rand<=P_here; 
			end;
			if Released(i,j), % if we have release, find the time of the release
				r = rand;
				time_index = find(cumsum(p_release_waveform)>r,1,'first');
				Released_times{j}(end+1) = presyn_times(i)+p_release_waveform_t(time_index);
			end;
		end;
	end;
end;

 % now calculate conductances

g = zeros(size(t));

for j=1:numel(Released_times),
	for k=1:numel(Released_times{j}),
		deltaT = t-Released_times{j}(k);
		deltaT = rectify(deltaT);
		g = g + (deltaT>0).*Q.*(-exp(-deltaT/syn_tau1) + exp(-deltaT/syn_tau2));
	end;
end;

g_ = workspace2struct();

