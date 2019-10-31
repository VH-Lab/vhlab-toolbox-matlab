function [err,fitr]=exp_fit_err(p,T,data)
%  EXP_FIT_ERR Exponential error function
%
%       ERR=EXP_FIT_ERR(P,T,DATA)
%       P = [b tau k] 
%          returns mean squared error of  y = b + k*(1-exp(-T/tau)),
%       where T is a vector of timevalues to evaluate.
  
switch length(p)
 case 3,   % p = [ b tau k]
  fitr=p(1)+p(3)*(1-exp(-T/p(2)));
  err=0;
end
d = (data-repmat(fitr,size(data,1),1));
err=err+sum(sum(d.*d));
