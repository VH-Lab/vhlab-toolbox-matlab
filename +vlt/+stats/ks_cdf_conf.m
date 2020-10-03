function [Xvalues,sampleCDF1,minCDF,maxCDF,pvalue] = KS_CDF_CONF(x1, alpha)
%KS_CDF_CONF Kolmogorov-Smirnov confidence interval for a data set.
%   [Xvalues,sampleCDF,minCDF,maxCDF] = vlt.stats.ks_cdf_conf(X1,ALPHA)
%   performs a Kolmogorov-Smirnov (K-S) test to determine the confidence
%   interval for independent random samples X1.
%   ALPHA is the desired significance level (default = 0.05); 
%   observations, indicated by NaNs (Not-a-Number), are ignored.
%
%   The asymptotic P-value becomes very accurate for large sample sizes, and
%   is believed to be reasonably accurate for sample sizes N1 and N2 such 
%   that (N1*N2)/(N1 + N2) >= 4.
%
%   Created by SDV, based on KSTEST2 by the MathWorks
%
%   See also KSTEST, KSTEST2, CDFPLOT.


 
if nargin < 2
    error('At least 2 inputs are required.');
end

%
% Ensure each sample is a VECTOR.
%

if ~isvector(x1) 
    error('The sample X1 must be a vector.');
end

%
% Remove missing observations indicated by NaN's, and 
% ensure that valid observations remain.
%

x1  =  x1(~isnan(x1));
x1  =  x1(:);

if isempty(x1)
   error('Sample vector X1 contains no data.');
end


%
% Ensure the significance level, ALPHA, is a scalar 
% between 0 and 1 and set default if necessary.
%

if nargin>1 & ~isempty(alpha)
   if ~isscalar(alpha) || (alpha <= 0 || alpha >= 1)
      error('Significance level ALPHA must be a scalar between 0 and 1.'); 
   end
else
   alpha  =  0.05;
end


%
% Calculate F1(x) and F2(x), the empirical (i.e., sample) CDFs.
%

binEdges    =  [-inf ; sort([x1]) ; inf];

binCounts1  =  histc (x1 , binEdges, 1);

sumCounts1  =  cumsum(binCounts1)./sum(binCounts1);

sampleCDF1  =  sumCounts1(1:end-1);
Xvalues = binEdges(1:end-1);
Xvalues(1) = Xvalues(2) - 1;

%
% Compute the test statistic of interest.
%

% find the deltaCDF that will give us the appropriate pValue equal to
% alpha:

KSstatistic = 1;  % the difference between the CDFs
lastlowervalue = 0;
lastuppervalue = 1;

pvalue = Inf;
n1     =  length(x1);
n2     =  length(x1);
n      =  n1 * n2 /(n1 + n2);

kk = 1;

while kk<5000 & ( abs(pvalue-alpha)>0.00001),  % do a binary search
    
    lambda =  max((sqrt(n) + 0.12 + 0.11/sqrt(n)) * KSstatistic , 0);
    j       =  (1:101)';
    pValue  =  2 * sum((-1).^(j-1).*exp(-2*lambda*lambda*j.^2));
    pValue  =  min(max(pValue, 0), 1);
    
    pvalue = pValue;

    if pvalue>alpha, % if difference is too big, lower difference
        lastlowervalue = KSstatistic;
        KSstatistic = mean([KSstatistic lastuppervalue]);
    elseif pvalue<alpha, % if difference is too small, increase it
        lastuppervalue = KSstatistic;
        KSstatistic = mean([KSstatistic lastlowervalue]);
    end;
	kk = kk + 1;
end;

minCDF = sampleCDF1 - KSstatistic;
minCDF = max(minCDF, 0*minCDF); 
maxCDF = sampleCDF1 + KSstatistic;
maxCDF = min(maxCDF, 0*maxCDF + 1); 
