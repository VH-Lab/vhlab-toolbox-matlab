function N = power_index(mn, stddev, change, G, conf)
% POWER_INDEX - Compute the number of observations needed to find a change
%
%  N = POWER_INDEX(MN, STDDEV, CHANGE, G, CONF)
%
%  Uses Monte Carlo techniques to estimate number of samples needed to
%  see a change of size CHANGE from a mean of MN across G groups,
%  assuming the samples have normally distributed noise with standard
%  deviation of STDDEV, with a confidence of CONF. An ANOVA1 is used to
%  look for differences across the G groups in the simulated data.
%
%  See also: ANOVA1



 % make 10000 simulations, see in how many we observe a significant change
 % with an ANOVA1 analysis.  If we are CONF confident we will see the
 % change, then we have arrived at N.
 
N = 3;

fraction_detected = 0;
numsims = 1000;

 
 while fraction_detected < conf,
     disp(['Trying N=' int2str(N) '.']);
     passed = 0;
     for i=1:numsims,
         data = randn(N,G) * stddev + repmat(mn,N,G);
         data(:,G/2+1:end) = data(:,G/2+1:end) + change;
         p = anova1(data,[],'off');
         if p<1-conf,
             passed = passed + 1;
         end;
     end;
     fraction_detected = passed / numsims;
     disp(['....Fraction passed here is ' num2str(fraction_detected) '.']);
     N = N + 1;
 end;