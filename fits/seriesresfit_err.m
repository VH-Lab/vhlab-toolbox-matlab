function [err,fitr]=seriesresfit_err(p,T,data)
%  SERIESRESFIT_ERR Series resistance error fit
%
%       ERR=SERIESRESFIT_ERR(P,T,DATA)
%       P = [ Re taue Rm taum ]
%         returns mean squared error of V=Re[1-exp(-t/taue)]+Rm[1-exp(-t/taum)]
%       where T is a vector of timevalues to evaluate.
  
switch length(p)
 case 4,   % p = [ Re taue Rm taum ]
  fitr=p(1)*(1-exp(-T/p(2)))+p(3)*(1-exp(-T/p(4)));
  err=0;
end
d = (data-repmat(fitr,size(data,1),1));
err=(err+sum(sum(d.*d)))/1e7; % we're working in MOhms
