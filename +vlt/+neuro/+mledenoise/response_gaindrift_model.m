function r = response_gaindrift_model(t, dt, stimlist, SPs, g_params, s_i_parameters)
% RESPONSE_GAINDRIFT_MODEL - Computes the response of the gain drift model
%
%  R=vlt.neuroscience.mledenoise.response_gaindrift_model(STIM_TIMES, STIM_DURATION, STIMLIST,...
%      SINPARAMS, G_PARAMS, S_I_PARAMS);
%
%   This function assumes that the response to a neural spike train in response to stimuli
%   s_i can be written as
%
%   r(t) = g(t) * s_i(t)
%
%   where r(t) is the actual response observed as a function of time, g(t) is an unknown
%   slow background gain modulation of the cortex, and s_i(t) is the unknown mean response
%   to each stimulus.
%
%   This function computes the response to a specific model, where the stimuli are presented
%   in order STIMLIST at times STIM_TIMES and have stim duration STIM_DURATION. 
%   It is further assumed that SINPARAMS are parameters of a 4 sinusoidal fit to the data
%   that describes the slow drift in gain g. 
%
%   S_I_PARAMS is the mean response to stimulus type i, which can occur more than once in
%   the STIMLIST.
%
%   G_PARAMS is a 4 element vector that describes the weighting of the 4 sinusoids.  If 
%   G_PARAMS has a 5th element, it is assumed to be a constant offset for g(t).
%
%   R is returned at the STIM_TIMES.  If R is less than or equal to 0, R is set to eps.

g = g_params(1)*(sin(SPs(2)*t + SPs(3))) + g_params(2)*(sin(SPs(5)*t + SPs(6))) + ...
                g_params(3)*(sin(SPs(8)*t + SPs(9))) + g_params(4)*(sin(SPs(11)*t + SPs(12)));

if length(g_params)>4,
	g = g + g_params(5);
end; % constant offset in some forms

stim_responses_predicted = s_i_parameters(stimlist);

r = g(:).*stim_responses_predicted(:)+eps;
r(r<=0) = eps;

