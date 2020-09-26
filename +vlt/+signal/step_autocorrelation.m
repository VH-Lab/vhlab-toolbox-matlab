function sac=step_autocorrelation(alpha, N, n)
% STEP_AUTOCORRELATION - Mathematical function describing autocorrelation of a step function
%
%  SAC = STEP_AUTOCORRELATION(ALPHA, N, n)
%
%  Produces the mathematically determined autocorrelation function of a process
%  that, with probability alpha, produces a unit pulse of width N samples.
%
%  n is the lag of the autocorrelation to be computed, and can be a vector.
%
%  Example:  
%     alpha = 0.2; 
%     N = 10;
%     n = -50:50;
%     sac = step_autocorrelation(alpha, N, n);
%     figure;
%     plot(n,sac,'-o');
%    

sac= (alpha/N) * (N-abs(n)) .* heaviside(N-abs(n));
