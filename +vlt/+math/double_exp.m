function g = double_exp(t, tau1, tau2)

% DOUBLE_EXP - Double exponential
%
%  G = DOUBLE_EXP(T, TAU1, TAU2)
%
%    Returns ((TAU1*TAU2)/(TAU1-TAU2)) * (EXP(-T/TAU1)-EXP(-T/TAU2))
%
%    Roughly speaking, if TAU1 and TAU2 are very different, then
%    TAU1 is an onset time constant and TAU2 is an offset constant
%
%    Time to peak is (TAU1*TAU2/(TAU1-TAU2))*LOG(TAU1/TAU2)
%
 
g = ((tau1*tau2)/(tau1 - tau2))*(exp(-t/tau1)-exp(-t/tau2));
