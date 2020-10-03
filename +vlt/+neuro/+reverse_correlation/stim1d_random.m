function stim=stim1d_random(x, t, values, dist)

% vlt.neuro.reverse_correlation.stim1d_random -- Creates a 1-D (space) random stimulus for model computation
%
%   STIM=vlt.neuro.reverse_correlation.stim1d_motion(X, T, VALUES, DISTRIBUTION)
%
%   Creates a discrete 1-D (in space) random stimulus that can be fed to
%   a 1-d spatial model
% 
%       X should be a vector indicating the spatial positions to create, in degrees
%          (example: 0:0.1:10 creates 100 positions in increments of 0.1 degrees)
%       T should be the time values to compute (stim is assumed to be constant in each bin)
%          (example: 0:0.01:2 simulates 2 seconds in 0.01s steps, or a 100Hz monitor)
%       VALUES should be an array list of brightness values that the stimulus can take
%       DISTRIBUTION should be an array list of probabilities that the brightness
%           will assume each value in VALUE.
%
%    One can imagine that the units of the returned stimulus is brightness.
%
%    Each row of the returned stimulus represents the stimulus at 1 value
%    of time; time is represented across the columns.
%       
%    Example: stim = vlt.neuro.reverse_correlation.stim1d_random([0:0.1:10],[0:0.1:300],[1 0 -1],[0.1 0.8 0.1]);
%

 % generate random data
probs = cumsum(dist(:))';
probs = probs ./ probs(end);
phs = ones(length(x),1) * probs;
pls = [ zeros(length(x),1) phs(:,1:end-1)];

stim = zeros(length(t),length(x));

for ti = 1:length(t),
	f = rand(length(x),1) * ones(1,length(dist));
	[I,J] = find(f>pls&f<=phs);
	[y,is] = sort(I);
	stim(ti,1:length(x)) = values(J(is));
end;
