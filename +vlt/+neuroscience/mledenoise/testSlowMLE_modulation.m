function testSlowMLE
% testSlowMLE - A function that demonstrates the use of SlowMLEDenoise.m
%
%  Read this function to see a demo of testSlowMLE in action on
%  simulated data that exhibits modulated responses to stimulation.
%
%  See also: TESTSLOWMLE for an example where the response is a 
%  a constant response instead of modulated.
%

model = 'Gaussian';  % or choose 'Gaussian'

dt = 0.001;
freq = 4;  % modulation frequency

 % Step 1 - Create an example experiment and plot it
[spiketimes,r,t,stimon,stimoff,stimids,g]=gaindriftexample('gain_amplitude',0.5,'stim_response',[30 25 20 15 10 5 0],...
	'gain_offset',0.5,'response_tf',freq);
fig = figure;
plot(t,r,'k','DisplayName','True underlying response rate');
hold on;


spikeplot = plot(spiketimes,50,'kx'); % plot an x for each simulated spike time
for i=1:length(spikeplot),  % don't do a legend for these points
	hAnnotation = get(spikeplot(i),'Annotation');
	hLegendEntry = get(hAnnotation','LegendInformation');
	set(hLegendEntry,'IconDisplayStyle','off');
end;

plot(t,g,'g','DisplayName','True underlying gain modulation'); % plot gain
response_rate = [];

stim_center_times = mean([stimon;stimoff]);
stim_durations = [stimoff-stimon];

real_sinparams = [ 0.5 2*pi/300 0 0 0 0 0 0 0 0 0 0 0];
real_s_i = [ 30 25 20 15 10 5 0];
RR_real = response_gaindrift_model(stim_center_times, stim_durations, stimids, real_sinparams, real_sinparams(1:3:12), real_s_i);
hold on;
plot((stimon+stimoff)/2, RR_real,'ko','DisplayName','True underlying responses s(t)*g(t) w/o noise');

spike_response = spikeresponse_tf(stimon,stimoff,stimids,spiketimes,dt,freq);

for i=1:length(stimon),
	text(stim_center_times(i), 55, int2str(stimids(i)));
	spike_response_index = spike_response.indexes(i,:);
	response_rate(end+1) = spike_response.inds{spike_response_index(1)}(spike_response_index(2));
end;

plot((stimon+stimoff)/2, 2*abs(response_rate),'bs','DisplayName','Response rates measured with noisy spike procecss (2x, b/c sinwave rectified)');

axis([t(1) t(end) -60 60]); box off;
xlabel('Time(s)'); ylabel('Firing rate');
title('x indicates spike, numbers indicate stimulus number');

response = spiketimes;
response_s_i_arg = abs(response_rate);

 % Step 2 - Estimate the parameters
[s_i_params, g_params, sinparams, mle, responseobserved, stimlist, responses_s_i] = ...
	SlowMLEDeNoise(stimon, stimoff, stimids, spiketimes,'showfitting',1,'numIterations',6,...
	'mlesmoothness',Inf,'responses_s_i',response_s_i_arg,'model',model);

 % plot real and estimated responses
fig2 = figure; 
plot(1:length(real_s_i),real_s_i,'ko');
hold on;
h1=myerrorbar(1:length(real_s_i),abs(spike_response.curve(2,:)),abs(spike_response.curve(4,:)),abs(spike_response.curve(4,:)),'bs');
delete(h1(2));
h2=myerrorbar(1:length(real_s_i),s_i_params,'ro');
delete(h2(2));

figure(fig);


responseobserved = responseobserved; % convert to a rate; 2 second stimuli

plot((stimon+stimoff)/2, responseobserved,'bx','DisplayName','Response rates measured with noisy spike process');

disp(['The normalized real parameters were ' num2str(real_s_i/max(real_s_i)) '.']);
disp(['The identified normalized parameters are ' num2str(s_i_params/max(s_i_params)) '.']);

RR = response_gaindrift_model((stimon+stimoff)/2, 2, stimids, sinparams, g_params, s_i_params);
hold on;
plot((stimon+stimoff)/2, 2*RR,'r','linewidth',2,'DisplayName','Fit response s(t)*g(t) (2x, because sinwave rectified)');
   % red line is fitted response

legend('toggle');
legend('Location','Southeast');
