function features = spikewaves2pca(waves, N, range)
% SPIKEWAVES2PCA - Compute first N principle components of spike waveforms
%
%  FEATURES = SPIKEWAVES2PCA(WAVES, N, [RANGE])
%
%  Creates a set of "features" of the spike waveform WAVES by
%  calculating the values of the first N principle components.
%
%  Inputs:
%  WAVES: A NumSamples x NumChannels x NumSpikes list of spike
%   waveforms. 
%  N:  the number of principle components to include
%  Optional input:
%  RANGE: A 2 element vector with the START and STOP range to examine
%
%  Outputs:
%  FEATURES:   An N x NumSpikes list of features. 
%    

if nargin>2,
	waves = waves(range(1):range(2),:,:);
end;

waves_reshaped = reshape(waves,size(waves,1)*size(waves,2),size(waves,3))';

% Identify rows with NaNs (which pca will drop with 'Rows','complete')
valid_rows = ~any(isnan(waves_reshaped), 2);

% Initialize features with NaNs
features = NaN(size(waves_reshaped, 1), N);

if any(valid_rows)
    % Compute PCA only on valid data
    [coeff, score] = safe_pca(waves_reshaped(valid_rows, :), 'Rows', 'complete');

    % Map scores back to their original positions
    % score might have fewer columns than N if rank is low, but usually N is small
    cols_to_assign = min(N, size(score, 2));
    features(valid_rows, 1:cols_to_assign) = score(:, 1:cols_to_assign);
end

features = features';
