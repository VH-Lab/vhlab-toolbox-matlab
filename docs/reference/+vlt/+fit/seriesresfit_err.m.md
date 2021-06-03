# vlt.fit.seriesresfit_err

```
   SERIESRESFIT_ERR Series resistance error fit
 
        ERR=vlt.fit.seriesresfit_err(P,T,DATA)
        P = [ Re taue Rm taum ]
          returns mean squared error of V=Re[1-exp(-t/taue)]+Rm[1-exp(-t/taum)]
        where T is a vector of timevalues to evaluate.

```
