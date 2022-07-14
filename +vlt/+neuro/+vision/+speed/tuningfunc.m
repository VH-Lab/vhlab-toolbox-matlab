function R = tuningfunc(SF,TF,P)
% vlt.neuro.vision.speed.tuningfunc - produce responses given a speed tuning function
%
%  R = vlt.neuro.vision.speed.tuningfunc(SF,TF,P)
%
%  Produce the responses at given spatial (SF) and temporal (TF) frequencies
%  given parameters for a speed tuning curve. 
%
%  Inputs:
%    SF is an array of spatial frequency values
%    TF is an array of temporal frequency values
%    P is an array with parameters:
%    ---------------------------------------------
%    | A         | Peak response of the neuron   |
%    |           |                               |
%    | zeta      | Skew of the temporal          |
%    |           | frequency tuning curve        |
%    |           |                               |
%    | xi        | Speed parameter               |
%    |           |                               |
%    | sigma_sf  | Tuning width of the neuron    |
%    |           | for spatial frequency         |
%    |           |                               |
%    | sigma_tf  | Tuning width of the neuron    |
%    |           | for temporal frequency        |
%    |           |                               |
%    | sf0       | Preferred spatial frequency   |
%    |           | averaged across temporal      |
%    |           | frequencies                   |
%    |           |                               |
%    | tf0       | Preferred temporal frequency  |
%    |           | averaged across spatial       |
%    |           | frequencies                   |
%    ---------------------------------------------
%
%  Outputs:
%    R is an array of calculated responses
%
%  Example:
%    [SF,TF] = meshgrid([0.05 0.08 0.1 0.2 0.4 0.8 1.2],[0.5 1 2 4 8 16 32]);
%    % Pick some parameters
%    A = 1;
%    zeta = 0;
%    xi = 0;
%    sigma_sf = 0.2; % Cycles per degree
%    sigma_tf = 4; % Cycles per second; this is the fall off
%    sf0 = 0.1;
%    tf0 = 4;
%    % Now calculate the responses
%    R = speed.tuningfunc(SF,TF,[A zeta xi sigma_sf sigma_tf sf0 tf0]);
%    % Now plot the responses
%    figure;
%    speed.plottuning(SF,TF,R);
%
%  See: Priebe et al. 2006
%
[m,n] = size(SF);
        
A = P(1);
zeta = P(2);
xi = P(3);
sigma_sf = P(4);
sigma_tf = P(5);
sf0 = P(6);
tf0 = P(7);
        
SF = SF(:);
TF = TF(:); % Make them column vectors
        
logtfpsf = xi * (log(SF)-log(sf0)) + log(tf0);
        
R = A * exp( (-(log(SF)-log(sf0)).^2) / (2*sigma_sf*sigma_sf) ) .* ...
	( exp( -(log(TF)-logtfpsf).^2 ./ (2.*(sigma_tf+zeta*(log(TF)-logtfpsf)).^2) ) - exp(-1/(zeta.^2)));
        
R = reshape(R,m,n); % Return the same shape as input
