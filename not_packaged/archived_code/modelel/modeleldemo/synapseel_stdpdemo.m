function synapseel_stdpdemo
% SYNAPSEEEL_STDPDEMO - Demo of classic STDP at a synapset1t2 synapse
%
%  Enter "TYPE SYNAPSEEL_STDPDEMO" to see the code.
%
% See also: SYNAPSET1T2EL_INIT
%

for stdp = [1 0], % [1 0] % classic first, followed by triplet stdp
	[pre,post] = sjostrom_spiketrain(0.010,20,60); % 10ms offset, 5Hz, 60 spikes
	pre = pre + 1e-4; % move dt over 
	post = post + 1e-4;  % move dt over

	if stdp==1,
		dWeight = stdp_apply(pre,post);
	else,
		dWeight = stdp_triplet_apply(pre,post);
	end;
	
	mel(1) = spiketimelistel_init('name','pre','spiketimes',pre);
	mel(2) = spiketimelistel_init('name','post','spiketimes',post);
	syn_props = struct('Gmax_max',1,'Gmax_min',-1,'classic_stdp',stdp); % set Gmax to 1 for the test to compare with dWeight
	mel(3) = synapset1t2el_init('name','syn','plasticity_params',syn_props,'plasticity_method','synapseel_stdp','Gmax',0,...
		'pre',1,'post',2);

	dt = 0.0001;
	timesteps = 15/dt; % 15 seconds worth of steps
	varstosave = { 'modelrunstruct.Model_Final_Structure(1).T',...
			'modelrunstruct.Model_Final_Structure(3).model.Gmax' };
	[modelrun,varsout] = modelelrun(mel,'Steps',timesteps,'Variables',varstosave);

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

