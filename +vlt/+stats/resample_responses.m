function data2fit = resample_responses(trialdata, mode, niter)

% vlt.stats.resample_responses - Resample responses for montecarlo simulations
%
%  NEWRESPS = vlt.stats.resample_responses(TRIALDATA, MODE, REPS)
%
%  Generates a simulated set of responses.
%
%  TRIALDATA - A matrix size NUM_STIMS x NTRIALS
%     If no data is available for a given trail, it can be coded as NaN.
%     NaN values will be ignored.
%
%  If MODE==1, then simulated samples are generated with a random number
%  generator given the measured mean and variance of each stimulus.
%
%  If MODE==2, then the data are resampled with replacement, as would
%  be appropriate for bootstrap analysis.
%
%  REPS - The number of simulated trials to generate.
%
%  Based on code by Mark Mazurek

ntrials = size(trialdata,2);
numStims = size(trialdata,1);
data2fit = nan*ones(numStims,ntrials,niter);

if (mode==1),
  % Replicate the data through simulation
  meandata = nanmean(trialdata,2);
  stddata = nanstd(trialdata')';
  for i_iter = 1:niter
    data2fit(:,:,i_iter) = normrnd(repmat(meandata,1,ntrials),...
      repmat(stddata,1,ntrials));
  end
elseif (mode==2)
  % Replicate the data through sampling with replacement
  randind = ceil(ntrials*rand(ntrials,numStims,niter));

  for i_iter = 1:niter
    myinds = (randind(:,:,i_iter)-1)*numStims+repmat(1:numStims,ntrials,1);
    data2fit(:,:,i_iter) = trialdata(myinds)';
  end
end
