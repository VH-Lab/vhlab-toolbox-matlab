function DirRFModel_example1

% vlt.neuroscience.reverse_correlation.demos.DirRFModel_example1 - Direction selective responses from a hand-picked kernel
%

 % define parameters for kernel/stimuli

Stimx = [0:0.1:10]; Stimt = [0:0.01:1];

Dx = [ 0:0.1:10 ]; Dt = [ 0:0.001:1];

SpFreq = 1; TFreq = 4; Left = 1; Right = -1;


% create a grating that will give a maximum response to 0.050, which we'll pretend is mW

D = vlt.neuroscience.reverse_correlation.createdirkernel(Dx,Dt,SpFreq,0,TFreq,Left,[3 2],[0.1 0.001 0.2],0.050); % pretend mV
stim_left = vlt.neuroscience.reverse_correlation.stim1d_motion(Stimx,Stimt,SpFreq,0,TFreq,Left);
stim_right = vlt.neuroscience.reverse_correlation.stim1d_motion(Stimx,Stimt,SpFreq,0,TFreq,Right);

disp(['Setup complete, now simulating']);

[R_left,sim_time] = vlt.neuroscience.reverse_correlation.simulate_1dkernel_response(D, Dx,Dt, stim_left, Stimx, Stimt);
[R_right,sim_time] = vlt.neuroscience.reverse_correlation.simulate_1dkernel_response(D, Dx,Dt, stim_right, Stimx, Stimt);

disp(['Linear component simulated, now generating firing rates']);

Rrate_left = 1000*vlt.math.rectify(R_left); %.^3;  % now assume 1 Hz / mV depolarization
Rrate_right = 1000*vlt.math.rectify(R_right); %.^3;

disp(['Firing rates simulated, now generating spike times from these rates']);

sim_time_spikes = 0:0.001:Stimt(end);
Rrate_left_highsample = vlt.math.stepfunc(sim_time,Rrate_left,sim_time_spikes);
Rrate_right_highsample = vlt.math.stepfunc(sim_time,Rrate_right,sim_time_spikes);
Rspikes_right=rand(size(Rrate_right_highsample))<Rrate_right_highsample*(sim_time_spikes(2)-sim_time_spikes(1));
Rspikes_left=rand(size(Rrate_left_highsample))<Rrate_left_highsample*(sim_time_spikes(2)-sim_time_spikes(1));


figure;

colormap(gray(256));

 % plot kernel
subplot(3,2,1);

pcolor(Dx,Dt,D); shading flat; xlabel('Visual space (deg)'); ylabel('Time(s)'); title('Kernel'); box off;

 % plot stim_left

subplot(3,2,3);
pcolor(Stimx,Stimt,stim_left); shading flat;
xlabel('Visual space (deg)'); ylabel('Time(s)'); title('Stimulus: Left'); box off;

subplot(3,2,5);
pcolor(Stimx,Stimt,stim_right); shading flat;
xlabel('Visual space (deg)'); ylabel('Time(s)'); title('Stimulus: Right'); box off;

subplot(3,2,2);

plot(sim_time,R_left,'b');
hold on;
plot(sim_time,R_right,'r');
xlabel('Time(s)'); ylabel('Response (V)'); title('Repsonse to left (blue) and right (red)');
box off;

subplot(3,2,4);

plot(sim_time,Rrate_left,'b');
hold on;
plot(sim_time,Rrate_right,'r');
xlabel('Time(s)'); ylabel('Response (Hz)'); title('Repsonse to left (blue) and right (red)');
box off;

subplot(3,2,6);
plot(sim_time_spikes,Rspikes_left,'b'); hold on;
plot(sim_time_spikes,Rspikes_right,'r');
xlabel('Time(s)'); ylabel('Response (spikes)'); title('Repsonse to left (blue) and right (red)');


