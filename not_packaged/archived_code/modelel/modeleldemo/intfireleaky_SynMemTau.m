function tau = intfireleaky_SynMemTau(intfireel, synapseel)
% INTFIRELEAKY_SynMemTau - Empirically determine combined tau of synapse and membrane
%
%   TAU= INTFIRELEAKY_GSYNAP(INTFIREEL, SYNAPSEEL)
%
%   Determine time it takes for a subthreshold input to return to 1/exp(1) of baseline 
%   value. 
%
%   If INTFIREEL and SYNAPSEEL are empty, defaults will be used.
%  
%   See also: INTFIRELEAKYEL_INIT, SYNAPSEEL_INIT 

if isempty(intfireel),
	intfireel = intfireleakyel_init;
end;
if isempty(synapseel),
	synapseel = synapset1t2el_init;
end;

dt = synapseel.dT;
timetocheck = 2*(synapseel.model.tau2 + intfireel.model.Taum);
timesteps = ceil(timetocheck/dt); % number of steps to simulate

 % make sure cells are connected 
synapseel.model.post = 1;
synapseel.model.pre= 3;
synapseel.model.Gmax = 100e-15; % tiny tiny conductance
intfireel.model.synapse_list = 2;
spiketimelistel = spiketimelistel_init('name','pre','spiketimes',dt);
model = [intfireel;synapseel;spiketimelistel];

varstosave = {'modelrunstruct.Model_Final_Structure(1).T',...
		'modelrunstruct.Model_Final_Structure(1).model.V'};

[modelrun,varsout] = modelelrun(model,'Steps',timesteps,'Variables',varstosave);

mn = min(varsout(2,:));
mx = max(varsout(2,:));

threshold = mn + (mx-mn)/exp(1);
tz = find(   (varsout(2,1:end-1) > threshold ) & (varsout(2,2:end) < threshold) , 1, 'first');
tau = varsout(1,tz);

