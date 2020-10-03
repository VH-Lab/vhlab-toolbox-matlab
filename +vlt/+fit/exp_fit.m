function [tau,b,k,err,fit] = exp_fit(T,data);
% EXP_FIT Exponential fit
%
%  [TAU,B,k,err,fit] = vlt.fit.exp_fit(T,DATA)
%
%  Finds the best fit to the exponential function
%    y(t) = b + k*(1-exp(-T/tau))
%  where T is an increasing vector of timevalues, b is a constant offset, k
%  is a scalar, and tau is the exponential time constant.
%

 % initial conditions
 %xo = [b tau k]
 xo = [ data(1,end) 0.05 1];
 options=foptions; options(1)=0; options(2)=1e-6;
 [x] = fmins('vlt.fit.exp_fit_err',xo,options,[],T,data);
 tau=x(2);b=x(1);k=x(3);
 [err,fit]=vlt.fit.exp_fit_err(x,T,data);
