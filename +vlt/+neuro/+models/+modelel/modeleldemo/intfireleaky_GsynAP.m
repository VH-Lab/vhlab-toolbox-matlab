function GsynAP = intfireleaky_GsynAP(intfireel, synapseel, searchtime, searchrange)
% INTFIRELEAKY_GSYNAP - Empirically determine minimum synaptic strength for AP
%
%   GSYNAP = vlt.neuroscience.models.modelel.modeleldemo.intfireleaky_GsynAP(INTFIREEL, SYNAPSEEL,
%        SEARCHTIME, SEARCHRANGE)
%
%   Determine minimum current necessary to generate a single action potential
%   in an integrate and fire neuron modelel INTFIRE and a synapse to be connected
%   called SYNAPSEEL. The program will step from time 0 to time SEARCHTIME to see
%   if an action potential is generated.
%
%   If INTFIREEL and SYNAPSEEL are empty, defaults will be used. The default synapse
%   is a vlt.neuroscience.models.modelel.synapseel.synapset1t2el.synapset1t2el_init.
%  
%   The variable SEARCHRANGE = [ MIN MAX STEPS ] specifies the search domain.
%   The conductance values will be searched between MIN and MAX in a
%   binary search fashion of STEPS number of steps.
%
%   Examples:
%    % using default intfire and synapse
%    GsynAP = vlt.neuroscience.models.modelel.modeleldemo.intfireleaky_GsynAP([],[],[],[]) % use defaults
% 
%    GsynAP = vlt.neuroscience.models.modelel.modeleldemo.intfireleaky_GsynAP([],vlt.neuroscience.models.modelel.synapseel.synapset1t2el.synapset1t2el_init('tau2',0.200),[],[]) 
% 
%
%   See also: vlt.neuroscience.models.modelel.neuronmodelel.intfiremodels.intfireleakyel_init, vlt.neuroscience.models.modelel.synapseel.synapset1t2el.synapset1t2el_init 

if isempty(intfireel),
	intfireel = vlt.neuroscience.models.modelel.neuronmodelel.intfiremodels.intfireleakyel_init;
end;
if isempty(synapseel),
	synapseel = vlt.neuroscience.models.modelel.synapseel.synapset1t2el.synapset1t2el_init;
end;
if isempty(searchtime),
	searchtime = 3*synapseel.model.tau2;
end;
if isempty(searchrange),
	searchrange = [0 10e-9 30];
end;

dt = synapseel.dT;
timesteps = ceil(searchtime/dt); % number of steps to simulate

 % make sure cells are connected 
synapseel.model.post = 1;
synapseel.model.pre= 3;
intfireel.model.synapse_list = 2;
spiketimelistel = vlt.neuroscience.models.modelel.neuronmodelel.spiketimelistel.spiketimelistel_init('name','pre','spiketimes',dt);
model = [intfireel;synapseel;spiketimelistel];

 % test both bounds

GsynAP = doactualsearch(model, timesteps, searchrange(3),searchrange(1:2),[NaN NaN]);

%%%%%%%%%%%%%%%%%%%%%%

function Gsyn_estimate = doactualsearch(model,timesteps,searchsteps,B,bstatus)  % B is bounds

 % B comes in as a 2 element vector, becomes a 3. B(1) is lower bound, B(2) is upper bound, B(3) is middle
 % bstatus - is this point above threshold? 
B(3) = mean(B(1:2)); % midpoint
bstatus(3) = NaN; % we don't know if it is above or below threshold

if searchsteps>0,
	for n=1:3,
		% make sure both bounds are tested
		if isnan(bstatus(n)), % need to test bound
			model(2).model.Gmax = B(n);
			modelout=vlt.neuroscience.models.modelel.modelelrun.modelelrun(model,'Steps',timesteps);
			if any(modelout.Model_Final_Structure(1).model.spiketimes),
				Bnext(n) = 1; % this is suprathreshold
			else,
				Bnext(n) = -1; % this is subthreshold
			end;
		else,
			Bnext(n) = bstatus(n);
		end;
	end;
	if all(Bnext(1:2)<0), % our search failed, both bounds are below threshold
		error(['Both suggested bounds are below threshold']); % more help
	end;
	if all(Bnext(1:2)>0), % our search failed, both bounds are below threshold
		error(['Both suggested bounds are above threshold']); % more help
	end;
	% now we know Bnext(1) is below threshold, Bnext(2) is above; what is Bnext(3)?
	if Bnext(3)<0,
		Gsyn_estimate = doactualsearch(model,timesteps,searchsteps-1,[B(3) B(2)],[Bnext(3) Bnext(2)]);
	else,
		Gsyn_estimate = doactualsearch(model,timesteps,searchsteps-1,[B(1) B(3)],[Bnext(1) Bnext(3)]);
	end;
else,
	Gsyn_estimate = max(B(1:2)); % must return something above threshold
	return;
end;


