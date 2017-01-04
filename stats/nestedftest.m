function [p,F] = nestedftest(SE1, number_params1, SE2, number_params2, num_datapoints)
% NESTEDFTEST - Compute Nested F test statistic for 2 nested models
%
%  [P,F] = NESTEDFTEST(SE1, P1, SE2, P2, NDATA)
%
%  Performs a Nested F test for 2 model fits to the same data, where
%  the first model is "nested" inside the second (that is, the first model
%  is a simplified version of the second, and can be obtained from the
%  second model by setting parameters in the second to particular values).
%
%  SE1: The total squared error between the first model and the data.
%  P1:  The number of parameters in the first model.
%  SE2: The total squared error between the second model and the data.
%  P2:  The number of parameters in the second model.
%  NDATA: The number of data values used to calculate SE1, SE2.
%
%  P:   The p-value of the F test.  If this is less than your alpha (say,
%       0.05) then the second model is a significantly better fit than the
%       first.
%  F:   The value of the F statistic.
%
%  See: http://en.wikipedia.org/wiki/F-test#Regression_problems
%
%  

   % it would be good to add an example


F = ((SE1-SE2)/(number_params2-number_params1))/(SE2/(num_datapoints-number_params2));

DF1 = number_params2-number_params1;
DF2 = num_datapoints-number_params2;

p = 1-fcdf(F,DF1,DF2);
