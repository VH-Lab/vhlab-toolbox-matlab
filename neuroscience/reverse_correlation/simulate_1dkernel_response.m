function [R,t] = simulate_1dkernel_response(D, Dx,Dt, stim, stimx, stimt)

% SIMULATE_1DKERNEL_RESPONSE -- Simulate response of a linear kernel
%
%   R = SIMULATE_1DKERNEL_RESPONSE(D,DX,DT,STIM,STIMX,STIMT)
%
%   Simulates the responses of a 1D (in space) kernel D to a stimulus
%   STIM.  DX is the spatial positions of the kernel, DT is the temporal
%   positions of the kernel, STIMX is the spatial positions of the stimulus
%   and STIMT is the temporal positions of the stimulus.

  % assume kernel time resolution is as fine or finer than the stimulus time resolution
  % also assume that kernel time has uniform steps (same assumption not made of stimulus)

deltat = Dt(2) - Dt(1);
deltaspace = Dx(2)-Dx(1);

time_width = Dt(end) - Dt(1) + deltat; % this is the width represented by the kernel

Drev = D(end:-1:1,:); % the kernel Dt has positive time, but it really goes back into the past

 % add a step with value 0 to the beginning of the stimulus so we can compute
 %  the response of the kernel starting at the beginning of the stimulus

stim_with_zero_padding = [zeros(1,size(stim,2)) ; stim ];
stimt_with_padding = [stimt(1)-time_width-deltat stimt(:)'];

stim_time_requests = stimt(1)-time_width:deltat:stimt(end);
[dummy,inds] = stepfunc(stimt_with_padding,stim_with_zero_padding',stim_time_requests);

start_ind = findclosest(stim_time_requests,stimt(1));  % could compute this exactly

R = [];
for i=start_ind:length(stim_time_requests),
	R(end+1) = deltat*deltaspace*sum(sum(stim_with_zero_padding(inds(1+i-length(Dt):i),:).*Drev));
end;

t = stim_time_requests(start_ind:end);
