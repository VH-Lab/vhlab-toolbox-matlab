function synapseel_stdpdemo
% SYNAPSEEEL_STDPDEMO - Demo of classic STDP at a synapset1t2 synapse
%
%  Enter "TYPE vlt.neuroscience.models.modelel.modeleldemo.synapseel_stdpdemo" to see the code.
%
% See also: vlt.neuroscience.models.modelel.synapseel.synapset1t2el.synapset1t2el_init
%

for stdp = [1 0], % [1 0] % classic first, followed by triplet stdp
	[pre,post] = vlt.neuroscience.stdp.sjostrom_spiketrain(0.010,20,60); % 10ms offset, 5Hz, 60 spikes
	pre = pre + 1e-4; % move dt over 
	post = post + 1e-4;  % move dt over

	if stdp==1,
		dWeight = vlt.neuroscience.stdp.stdp_apply(pre,post);
	else,
		dWeight = vlt.neuroscience.stdp.stdp_triplet_apply(pre,post);
	end;
	
	mel(1) = vlt.neuroscience.models.modelel.neuronmodelel.spiketimelistel.spiketimelistel_init('name','pre','spiketimes',pre);
	mel(2) = vlt.neuroscience.models.modelel.neuronmodelel.spiketimelistel.spiketimelistel_init('name','post','spiketimes',post);
	syn_props = struct('Gmax_max',1,'Gmax_min',-1,'classic_stdp',stdp); % set Gmax to 1 for the test to compare with dWeight
	mel(3) = vlt.neuroscience.models.modelel.synapseel.synapset1t2el.synapset1t2el_init('name','syn','plasticity_params',syn_props,'plasticity_method','vlt.neuroscience.models.modelel.synapseel.plasticity_methods.synapseel_stdp','Gmax',0,...
		'pre',1,'post',2);

	dt = 0.0001;
	timesteps = 15/dt; % 15 seconds worth of steps
	varstosave = { 'modelrunstruct.Model_Final_Structure(1).T',...
			'modelrunstruct.Model_Final_Structure(3).model.Gmax' };
	[modelrun,varsout] = vlt.neuroscience.models.modelel.modelelrun.modelelrun(mel,'Steps',timesteps,'Variables',varstosave);

	figure;
	plot(varsout(1,:),varsout(2,:),'r');
	hold on
	plot([0 15],[1 1]*dWeight,'k--');
	xlabel('Time(s)');
	ylabel('Gmax(S)');
	if stdp==1,
		title('Classic STDP');
	else,
		title('Triplet STDP');
	end;
end;

