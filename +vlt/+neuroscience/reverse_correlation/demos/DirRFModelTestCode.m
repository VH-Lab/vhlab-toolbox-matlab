
Dt = [ 0:0.001:1 ];
Dx = [ 0:0.1:10 ]; 

D = createdirkernel(Dx, Dt, 1, 0, 4, 1, [3 1], [0.1 0.001 0.1], 1);

Stimx = Dx;
Stimt = [0:0.01:2];

stim_left = stim1d_motion(Stimx,Stimt,1,0,4,1);
stim_right = stim1d_motion(Stimx,Stimt,1,0,4,-1);

R = simulate_1dkernel_response(D, Dx,Dt, stim_left, Stimx, Stimt);


