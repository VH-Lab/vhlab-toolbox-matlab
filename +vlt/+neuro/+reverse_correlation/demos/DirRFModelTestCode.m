
Dt = [ 0:0.001:1 ];
Dx = [ 0:0.1:10 ]; 

D = vlt.neuroscience.reverse_correlation.createdirkernel(Dx, Dt, 1, 0, 4, 1, [3 1], [0.1 0.001 0.1], 1);

Stimx = Dx;
Stimt = [0:0.01:2];

stim_left = vlt.neuroscience.reverse_correlation.stim1d_motion(Stimx,Stimt,1,0,4,1);
stim_right = vlt.neuroscience.reverse_correlation.stim1d_motion(Stimx,Stimt,1,0,4,-1);

R = vlt.neuroscience.reverse_correlation.simulate_1dkernel_response(D, Dx,Dt, stim_left, Stimx, Stimt);


