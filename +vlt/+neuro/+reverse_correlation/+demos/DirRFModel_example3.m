function DirRFModel_example3

%  vlt.neuro.reverse_correlation.demos.DirRFModel_example3 - Using reverse correlation to reconstruct linear kernel in response to noise

% STEP 1 - Create a hand-picked kernel

 % kernel parameters
Stimx = [0:0.1:10]; Stimt = [0:0.1:100];  % space and time values for the stimulus
dt_kernel = 0.001; % our time resolution for our kernel, both for computing response and reverse-correlation
Dx = [ 0:0.1:10 ]; Dt = [ 0:dt_kernel:1];      % time values for the kernel
SpFreq = 1; TFreq = 4; Left = 1; Right = -1; Stim_Center_Position = 3;

 % make the kernel
D = vlt.neuro.reverse_correlation.createdirkernel(Dx,Dt,SpFreq,0,TFreq,Left,[Stim_Center_Position 2],[0.1 0.001 0.2],0.03); % assume V output
 % D has units of Volts / (unit contrast * unit time * unit space)

% STEP 2 - Create a random stimulus

   % alpha is probability of seeing -100% or 100% contrast instead of 0% contrast
alpha = 0.5;
stim_random = vlt.neuro.reverse_correlation.stim1d_random(Stimx,Stimt,100*[1 0 -1],[alpha 1-2*alpha alpha]);

% STEP 3 - Specify the time coordinates of the kernel we will (re)construct

kerneltimes = Dt;

disp(['Setup complete, now simulating']);

% STEP 4 - simulate the response of the hand-picked kernel to the random stimulus

[R_random,sim_time] = vlt.neuro.reverse_correlation.simulate_1dkernel_response(D, Dx,Dt, stim_random, Stimx, Stimt);
  % R_random is a voltage signal; we now create a spike-rate signal from R_random
Rspikerate_random = 5*vlt.math.rectify(R_random*10);  % non-linear spike function (rectification)
  % we now generate spike times from the spike rate signal
  % sample spikes at 1ms intervals
spike_dt = 0.001;
sim_time_spikes = 0:spike_dt:Stimt(end);
Rrate_random_highsample = vlt.math.stepfunc(sim_time,Rspikerate_random,sim_time_spikes);
Rspikes_random=rand(size(Rrate_random_highsample))<Rrate_random_highsample*spike_dt;

disp(['Average spike rate was ' num2str(sum(Rspikes_random)/Stimt(end)) ' Hz.']);

% STEP 5 - Use reverse correlation to calculate the linear kernel

disp(['Now computing reverse correlation']);

 % now analytically compute the autocorrelation of the stimulus, which is not white noise because it has width in time larger than 1 sample
N = fix((Stimt(2)-Stimt(1)) / dt_kernel ); % what is the size of the stimulus pulse in samples of kernel?
stim_autocorrelation = vlt.signal.step_autocorrelation((100*100)*alpha, N, 0:length(kerneltimes));
   % stim_autocorrelation has units of contrast squared

kerneltimes = Dt;

spiketimes = sim_time_spikes(find(Rspikes_random));
[computed_kernel, computed_kernel_unfiltered, xc_stimsignal, xc_stimstim] = ...
	vlt.neuro.reverse_correlation.reverse_correlation_stepfunc(spiketimes,sim_time_spikes,kerneltimes,Stimt,stim_random,...
	'dt',dt_kernel,'dx',Stimx(2)-Stimx(1));% ,'xc_stimstim',stim_autocorrelation);

 % as of now, this is best kernel; whitening blows it up
 %computed_kernel = xc_stimsignal / (dt_kernel*(Stimx(2)-Stimx(1))*xc_stimstim(1)^2);

% STEP 6 - Now plot everything

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

subplot(3,2,5);
pcolor(Stimx,kerneltimes,computed_kernel); shading flat;
xlabel('Visual space (deg)'); ylabel('Time (s)'); title('Computed kernel, should be correct'); box off;
set(gca,'clim',clim),

subplot(3,2,6);
pcolor(Stimx,kerneltimes,xc_stimsignal); shading flat;
xlabel('Visual space (deg)'); ylabel('Time (s)'); title('Stim x Response, should be correct up to scale factor'); box off;


disp(['Note: At the present time, filtering the signal by the autocorrelation of the stimulus seems to produce garbage. We are still studying why this is.']);

disp(['Now entering keyboard mode so you can play with the variables. Type ''return'' to exit. ']);
disp(['Try the command: set(gca,''clim'',[-1 1]/5) , to change the scale of the computed kernel plot.']);

keyboard;
