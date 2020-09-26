function [Re,taue,Rm,taum,err,fit] = seriesresfit(T,data,Iinj);
% EXP_FIT Exponential fit
%
%  [Re,taue,Rm,taum,err,fit] = vlt.fit.exp_fit(T,DATA,Iinj)
%
%  Finds the best fit to 
%    V(t)/Iinj = Re(1-exp(-t/taue))+Rm(1-exp(-t/taum))
%  where T is an increasing vector of timevalues, Re is electrode 
%  resistance, taue is electrode time constant, Rm is membrane
%  resistance, and taum is membrane time constant.
%

 % initial conditions
 %xo = [b tau k]
 xo = [ 100e6 0.001 100e6 0.050 ];
 options=foptions; options(1)=0; options(2)=1e-6;options(14)=800;
 [x] = fmins('vlt.fit.seriesresfit_err',xo,options,[],T,data/Iinj);
 if x(4)<x(2),
	 Re=x(3);taue=x(4);taum=x(2);Rm=x(1);
 else,
	 Re=x(1);taue=x(2);taum=x(4);Rm=x(3);
 end;

 [err,fit]=vlt.fit.seriesresfit_err(x,T,data);
