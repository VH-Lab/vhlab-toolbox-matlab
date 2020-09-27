function DirRFModel_example0

% vlt.neuroscience.reverse_correlation.demos.DirRFModel_example0 - Tests 1d kernel with a "trivial" kernel
%
%   This simulates the response of a "trivial" kernel with only 1 non-zero
%   value.  The output should equal the input.
%

 % stimulus and kernel parameters

Stimx = [0:0.1:10]; Stimt = [0:0.01:2];
Dx = [ 0:0.1:10 ]; Dt = [ 0:0.001:2];

SpFreq = 1; TFreq = 4; Left = 1; Right = -1;

 % make the kernel and the stimulus
D = vlt.neuroscience.reverse_correlation.createdirkernel(Dx,Dt,SpFreq,0,TFreq,Left,[3 2],[0.1 0.001 0.2],0.010);
stim_left = vlt.neuroscience.reverse_correlation.stim1d_motion(Stimx,Stimt,SpFreq,0,TFreq,Left);

 % now modify the kernel so it is trivial
D_trivial = zeros(size(D));
D_trivial(1,1) = 1;

 % simulate the kernel response
[R_left_trivial,sim_time] = vlt.neuroscience.reverse_correlation.simulate_1dkernel_response(D_trivial, Dx,Dt, stim_left, Stimx, Stimt);

 % find scale difference due to units of stimulus/D

scale = max(stim_left(:))./max(R_left_trivial(:));

figure;
plot(sim_time,R_left_trivial*scale,'b');
hold on;
plot(Stimt,stim_left(:,1),'ro');
title([{'Response(blue) should match stimulus (red) except with higher time resolution' ...
	'(few apparent mismatches are actually correct; the sim time clock sometimes slips 1e-14)'}]);
