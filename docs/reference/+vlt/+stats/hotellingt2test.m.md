# vlt.stats.hotellingt2test

```
  vlt.stats.hotellingt2test - Hotelling T^2 test for multivariate samples
 
   [H,P] = vlt.stats.hotellingt2test(X,MU)
   [H,P] = vlt.stats.hotellingt2test(X,MU,ALPHA)
 
   Performs Hotelling's T^2 test on multivariate samples X to determine
   if the data have mean MU.  X should be a NxP matrix with N observations
   of P-dimensional data, and the mean MU to be tested should be 1xP.
   ALPHA, the significance level, is 0.05 by default.
 
   H is 1 if the null hypothesis (that the mean of X is equal to MU) can be
   rejected at significance level ALPHA.  P is the actual P value.
 
   The code is based on HotellingT2.m by A. Trujillo-Ortiz and
   R. Hernandez-Walls.  That software is available at TheMathWorks
   free file exchange site.

```
