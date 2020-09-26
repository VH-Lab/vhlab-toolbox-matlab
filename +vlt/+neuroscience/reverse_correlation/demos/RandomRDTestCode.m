
Dt = [ 0:0.001:1 ];
Dx = [ 0:01:10 ]; 

D = createdirkernel(Dx, Dt, 1, 0, 4, 1, [3 1], [0.1 0.001 0.1], 1);

Stimx = Dx;
Stimt = [0:0.01:20];

stim = stim1d_random(Stimx,Stimt,[-1 0 1],[1 8 1]);

[R,t] = simulate_1dkernel_response(D, Dx,Dt, stim, Stimx, Stimt);

corr = correlation_stepfuncs(t,Stimt,stim,Dt,Stimt,stim);


