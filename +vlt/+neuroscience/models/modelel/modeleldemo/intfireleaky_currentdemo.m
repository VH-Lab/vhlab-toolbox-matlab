function intfireleaky_currentdemo
% INTFIRELEAKY_CURRENTDEMO - Demo a leaky integrate and fire neuron
%
% Demonstrate a leaky integrate and fire neuron with constant
% current input. Plots a graph of voltage vs. time and outlines spike
% times with circles.
%
% See the code: type INTFIRELEAKY_CURRENTDEMO
%   

 % constant current test

Ie = 2.5e-9; % 2.5 nA of constant current
ifn = intfireleakyel_init('Ie',Ie);
dt = 0.0001;  % seconds per step
steps = 1 / dt; % steps
varstosave = {  'modelrunstruct.Model_Final_Structure(1).T', ...
		'modelrunstruct.Model_Final_Structure(1).model.V'};
[modelrun,varsout] = modelelrun(ifn,'Steps',steps,'Variables',varstosave);

spiketimes = modelrun.Model_Final_Structure(1).model.spiketimes;

figure;
plot(varsout(1,:),varsout(2,:),'k-');
hold on;
plot(spiketimes,0.010,'ko');
xlabel('Time(s)');
ylabel('Voltage(V)');
title(['Leaky integrate and fire neuron responds to ' num2str(Ie) ' A']);

box off;

