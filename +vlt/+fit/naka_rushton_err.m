function err=naka_rushton_err(p,c,data)
%  NAKA_RUSHTON_ERR Naka-Rushton function helper function for fitting
%
%       ERR=vlt.fit.naka_rushton_err(P,C,DATA)
%       P = [rm b] 
%          returns mean squared error of  p(1)*c./(p(2)+c) with data 
%       P = [rm b n]
%          returns mean squared error of p(1)*cn./(p(2)^p(3)+cn) with data 
%          where cn=c.^p(3)
%       P = [rm b n s]
%          returns mean squared error of p(1)*c^(p3)./(p(2)^(p(3)*p(4))+c^(p(3)*p(4))
%  
  
switch length(p)
 case 2,   % p = [ rm b]
  fitr=p(1)*c./(p(2)+c);
  err=0;
 case 3,   % p = [ rm b n]
  c=c.^p(3);
  fitr=p(1)*c./(p(2)^p(3)+c);  
  err=p(3)^2+p(2)^2; % exponent and c50 should be small 
 case 4, % p = [rm c50 n s]
  % getting too complicated, make the parameters explicit
  rm = p(1);
  c50 = p(2);
  n = p(3); 
  s = p(4);
  fitr = rm * c.^(n) ./ (c50^(s*n)+c.^(s*n));
  err=p(3)^2+p(2)^2; % exponent and c50 should be small 
 otherwise
  disp('Not enough parameters in vlt.fit.naka_rushton_err');
end
d = (data-repmat(fitr,size(data,1),1));
err=err+sum(sum(d.*d));
