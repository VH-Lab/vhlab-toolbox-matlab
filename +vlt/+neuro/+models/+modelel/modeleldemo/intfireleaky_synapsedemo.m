function intfireleaky_synapsedemo
% INTFIRELEAKY_SYNAPSEDEMO - Demo a leaky integrate and fire neuron with synaptic input
%
% Demonstrate a leaky integrate and fire neuron with a synaptic input
% Plots a graph of voltage vs. time and outlines spike times with circles.
%
% See the code: type vlt.neuroscience.models.modelel.modeleldemo.intfireleaky_synapsedemo
%   

 % constant current test

mel(1) = vlt.neuroscience.models.modelel.neuronmodelel.intfiremodels.intfireleakyel_init('name','post','synapse_list',3);
mel(2) = vlt.neuroscience.models.modelel.neuronmodelel.spiketimelistel.spiketimelistel_init('name','pre','spiketimes',0.1); 
mel(3) = vlt.neuroscience.models.modelel.synapseel.synapset1t2el.synapset1t2el_init('name','synapse','pre',2,'post',1,'Gmax',0.5e-9);
dt = 0.0001;  % seconds per step
steps = 1 / dt; % steps
varstosave = {  'modelrunstruct.Model_Final_Structure(1).T', ...
		'modelrunstruct.Model_Final_Structure(1).model.V',...
		'modelrunstruct.Model_Final_Structure(3).model.G'};
[modelrun,varsout] = vlt.neuroscience.models.modelel.modelelrun.modelelrun(mel,'Steps',steps,'Variables',varstosave);

spiketimes = modelrun.Model_Final_Structure(1).model.spiketimes;

figure;
subplot(2,1,1);
plot(varsout(1,:),varsout(2,:),'k-');
hold on;
if ~isempty(spiketimes),
	plot(spiketimes,0.010,'ko');
end;
xlabel('Time(s)');
ylabel('Voltage(V)');
title(['Leaky integrate and fire neuron with synaptic input at t=0.01s']);
box off;

subplot(2,1,2);
plot(varsout(1,:),varsout(3,:),'g');
xlabel('Time(s)');
ylabel('Synapse conductance (S)');
title(['Synaptic conductance with synaptic input at t=0.01s']);

