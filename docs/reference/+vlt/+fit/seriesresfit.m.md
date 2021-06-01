# vlt.fit.seriesresfit

  EXP_FIT Exponential fit
 
   [Re,taue,Rm,taum,err,fit] = vlt.fit.exp_fit(T,DATA,Iinj)
 
   Finds the best fit to 
     V(t)/Iinj = Re(1-exp(-t/taue))+Rm(1-exp(-t/taum))
   where T is an increasing vector of timevalues, Re is electrode 
   resistance, taue is electrode time constant, Rm is membrane
   resistance, and taum is membrane time constant.
