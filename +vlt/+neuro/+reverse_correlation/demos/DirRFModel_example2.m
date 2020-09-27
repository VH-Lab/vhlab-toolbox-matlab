function DirRFModel_example2

% vlt.neuroscience.reverse_correlation.demos.DirRFModel_example2 -
%     Generating a firing rate with hand-picked kernel, then Reconstructing the linear kernel from that firing rate.
%    (Note that there are no spikes generated here, that is vlt.neuroscience.reverse_correlation.demos.DirRFModel_example3)

% STEP 1  - Generate a hand-picked kernel

 % kernel parameters

Stimx = [0:0.1:10]; Stimt = [0:0.1:100];
Dx = [ Stimx ]; Dt = [ 0:0.001:1]; % these are the time and space values for the hand-picked kernel
dt = 0.001; % our time resolution for our kernel, both for computing response and reverse-correlation
SpFreq = 1; TFreq = 4; Left = 1; Right = -1; Stim_Center_Position = 3;

  % make the kernel
D = vlt.neuroscience.reverse_correlation.createdirkernel(Dx,Dt,SpFreq,0,TFreq,Left,[Stim_Center_Position 2],[0.1 0.001 0.2],0.100);
  % D has units of Volts / (unit contrast * unit time * unit space)

% STEP 2 - Generate a noise stimulus

   % alpha is probability of seeing -100% or 100% contrast instead of 0% contrast
alpha = 0.4;
stim_random = vlt.neuroscience.reverse_correlation.stim1d_random(Stimx,Stimt,100*[1 0 -1],[alpha 1-2*alpha alpha]);

% STEP 3 - Specify the time coordinates of the kernel we will (re)construct

kerneltimes = Dt;  % these will be the times for the calculated kernel

disp(['Setup complete, now simulating']);

% STEP 4 - simulate the response of the hand-picked kernel to the random stimulus

[R_random,sim_time] = vlt.neuroscience.reverse_correlation.simulate_1dkernel_response(D, Dx,Dt, stim_random, Stimx, Stimt); 
Rspikerate_random = 50*vlt.math.rectify(R_random);  % assume units of Hz, 1Hz/mV

% STEP 5 - compute the reverse correlation kernel

disp(['About to compute rate output correlation with the stimulus, this might take a couple minutes....']);

 % now compute the autocorrelation of the stimulus, which is not white noise because it has width in time larger than 1 sample
N = fix((Stimt(2)-Stimt(1)) / dt ); % what is the size of the stimulus pulse in samples of kernel?
stim_autocorrelation = vlt.signal.step_autocorrelation((100*100)*alpha, N, 0:length(kerneltimes));
   % stim_autocorrelation has units of contrast squared

[computed_kernel, computed_kernel_unfiltered, correlation_stimulus_response, correlation_stimulus_stimulus] = ...
		vlt.neuroscience.reverse_correlation.reverse_correlation_mv_stepfunc(R_random,sim_time,kerneltimes,Stimt,stim_random,...
		'dt',dt,'dx',Stimx(2)-Stimx(1), 'xc_stimstim',stim_autocorrelation);
   % correlation_stimulus_response has units of Volts * contrast
   % computed kernel has units of D: Volts / [unit time * unit space / unit contrast]

% STEP 6 -  now plot everything

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
xlabel('Time (s)'); ylabel('Response (V)'); title('Repsonse to random stimulation');
box off;

subplot(3,2,4);

column_with_most_kernel = vlt.data.findclosest(Stimx,Stim_Center_Position);

plot(kerneltimes,D(:,column_with_most_kernel),'b','linewidth',2);
hold on;
plot(kerneltimes,computed_kernel(:,column_with_most_kernel),'r','linewidth',2);
a = axis;
plot(kerneltimes,computed_kernel_unfiltered(:,column_with_most_kernel),'g');
axis(a);
xlabel('Time (s)'); ylabel('Kernel (V/[contrast*time*space])'); title('Original and computed kernels');
box off;
legend('Original kernel','Computed kernel','Computed kernel (unfiltered)');

subplot(3,2,5);
pcolor(Stimx,kerneltimes,computed_kernel); shading flat;
xlabel('Visual space (deg)'); ylabel('Time (s)'); title('Computed kernel'); box off;
set(gca,'clim',clim),

subplot(3,2,6);
pcolor(Stimx,kerneltimes,correlation_stimulus_response); shading flat;
xlabel('Visual space (deg)'); ylabel('Time (s)'); title('Computed kernel'); box off;

disp(['Now you have keyboard control to play with the example. type the word ''dbquit'' to return to the regular command line.']);
keyboard;
