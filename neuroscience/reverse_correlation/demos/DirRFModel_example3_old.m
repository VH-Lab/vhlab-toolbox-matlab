function DirRFModel_example3

%  DIRRFMODEL_EXAMPLE3 - Using reverse correlation to reconstruct linear kernel in response to noise

% STEP 1 - Create a hand-picked kernel

	Dx = [ 0:0.1:10 ]; Dt = [ 0:0.01:1];

SpFreq = 1; TFreq = 4; Left = 1; Right = -1;

D = createdirkernel(Dx,Dt,SpFreq,0,TFreq,Left,[3 2],[0.1 0.001 0.2],0.03); % assume mV output

% STEP 2 - Create a random stimulus

Stimx = [0:0.1:10]; Stimt = [0:0.01:150];
stim_random = stim1d_random(Stimx,Stimt,[1 0 -1],[0.1 0*0.8 0.1]);

disp(['Setup complete, now simulating']);

% STEP 3 - Simulate the response

[R_random,sim_time] = simulate_1dkernel_response(D, Dx,Dt, stim_random, Stimx, Stimt);

Rspikerate_random = 0.1*rectify(R_random*1000).^3;  % non-linear spike function

% STEP 4 - generate spikes from the rate

 % sample spikes at 1ms intervals

sim_time_spikes = 0:0.001:Stimt(end);
Rrate_random_highsample = stepfunc(sim_time,Rspikerate_random,sim_time_spikes);
Rspikes_random=rand(size(Rrate_random_highsample))<Rrate_random_highsample*(sim_time_spikes(2)-sim_time_spikes(1));

disp(['Average spike rate was ' num2str(sum(Rspikes_random)/Stimt(end)) ' Hz.']);

% STEP 5 - Use reverse correlation to calculate the linear kernel

disp(['Now computing reverse correlation']);

kerneltimes = Dt;
computed_kernel = spike_triggered_average_stepfunc(sim_time_spikes(find(Rspikes_random)),kerneltimes,Stimt,stim_random);

figure;

colormap(gray(256));

 % plot kernel
subplot(3,2,1);

pcolor(Dx,Dt,D); shading flat; xlabel('Visual space (deg)'); ylabel('Time (s)'); title('Kernel'); box off;
clim = get(gca,'clim');

 % plot stim_random

subplot(3,2,3);
pcolor(Stimx,Stimt,stim_random); shading flat;
set(gca,'clim',[-1 1]);
xlabel('Visual space (deg)'); ylabel('Time (s)'); title('Stimulus: Random'); box off;

subplot(3,2,2);

plot(sim_time,R_random,'b');
hold on;
xlabel('Time (s)'); ylabel('Response (V)'); title('Repsonse to left (blue) and right (red)');
box off;

subplot(3,2,4);

plot(sim_time,Rspikerate_random,'b');
hold on;
xlabel('Time (s)'); ylabel('Response (Hz)'); title('Repsonse to left (blue) and right (red)');
box off;

subplot(3,2,6);
plot(sim_time_spikes,Rspikes_random,'b');
xlabel('Time (s)'); ylabel('Spike (present/absent)'); title('Repsonse to left (blue) and right (red)');
box off

subplot(3,2,5);
pcolor(Stimx,kerneltimes,computed_kernel); shading flat;
xlabel('Visual space (deg)'); ylabel('Time (s)'); title('Computed kernel, should be correct up to scale factor'); box off;
set(gca,'clim',clim),

disp(['Now entering keyboard mode so you can play with the variables. Type ''return'' to exit. ']);
disp(['Try the command: set(gca,''clim'',[-1 1]/5) , to change the scale of the computed kernel plot.']);

keyboard;
