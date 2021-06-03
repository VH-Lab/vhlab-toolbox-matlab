# vlt.fit.naka_rushton_err

```
   NAKA_RUSHTON_ERR Naka-Rushton function helper function for fitting
 
        ERR=vlt.fit.naka_rushton_err(P,C,DATA)
        P = [rm b] 
           returns mean squared error of  p(1)*c./(p(2)+c) with data 
        P = [rm b n]
           returns mean squared error of p(1)*cn./(p(2)^p(3)+cn) with data 
           where cn=c.^p(3)
        P = [rm b n s]
           returns mean squared error of p(1)*c^(p3)./(p(2)^(p(3)*p(4))+c^(p(3)*p(4))

```
