function [Si,inds] = stepfunc(t, steps, ti, outofbounds)

% STEPFUNC - Evaluate a discrete step function at many times
%
%  [SI,INDS] = STEPFUNC(T, STEPS, TI [,OUTOFBOUNDS])
%
%   Returns the value of a step function that takes values
%       STEPS(i) between the times T(i) and T(i+1).
%       (STEPS(end) is assumed to be true between
%         T(end) and T(end)+mean(diff(T)) )
%
%   If OUTOFBOUNDS is provided, one can specify the value of
%   SI when ti is out of bounds.  Default is NaN; example
%   choices might be NaN or 0.
%
%   INDS are the index values such that
%   SI = STEPS(INDS); INDS that are out of bounds are 
%     NaN.
%
%   STEPS can have many rows; each row will be one step
%   function, and the answer will have the same number of
%   rows as STEPS; the columns of SI will be the same number as ti.
%
%   Example 1:  Evaluate a step function at a high sampling rate
%      S = [ 0 1 2 3 4 5 6 7 8 9 10]; % steps
%      t = [ 0:0.1:1 ] ; % steps each 0.1 seconds
%      ti = [ 0:0.001:1 ];
%      Si = stepfunc(t,S,ti); 
%      figure;
%      plot(ti,Si);  % plots at high temporal resolution
%      xlabel('X-axis');
%      ylabel('Value');
%
%   Example 2: Evaluate a step function at a few locations:
%      S = [ 0 1 2 3 4 5 6 7 8 9 10]; % steps
%      t = [ 0:0.1:1 ] ; % steps each 0.1 seconds
%      ti= [ 0 0.05 0.9 1.1];
%      [Si,inds] = stepfunc(t,S,ti)
%
%       gives 
%
%           Si   : [0 0 9 NaN]
%           inds : [1 1 10 NaN]
  

if nargin<4, ob = NaN; else, ob = outofbounds; end;

inds = fix(interp1([t t(end)+mean(diff(t))], 1:length(t)+1,ti,'linear',NaN));
inds(find(inds>length(steps))) = NaN;

Si = repmat(ob,size(steps,1),length(inds));

[indsofsubinds] = find(~isnan(inds));

Si(:,indsofsubinds) = steps(:,inds(indsofsubinds));

