function test_spikewaves2pca_alignment()
    % Test script to verify that spikewaves2pca returns correct dimensions
    % even when input contains NaNs.

    NumSamples = 10;
    NumChannels = 2;
    NumSpikes = 20;
    N = 3;

    % Create dummy waves
    waves = randn(NumSamples, NumChannels, NumSpikes);

    % Introduce NaNs in some spikes
    waves(1, 1, 5) = NaN;
    waves(1, 1, 10) = NaN;

    % Test standard function
    try
        disp('Testing neuroscience/spikesorting/spikewaves2pca.m ...');
        features = spikewaves2pca(waves, N, [1 NumSamples]);

        expected_size = [N, NumSpikes];
        if isequal(size(features), expected_size)
            disp('PASS: Output dimensions are correct.');
        else
            disp(['FAIL: Expected size ' mat2str(expected_size) ', got ' mat2str(size(features))]);
        end

        if all(isnan(features(:, 5))) && all(isnan(features(:, 10)))
            disp('PASS: NaN spikes resulted in NaN features.');
        else
            disp('FAIL: NaN spikes did not result in NaN features correctly.');
        end

    catch ME
        disp(['ERROR: ' ME.message]);
    end

    % Test namespaced function
    try
        disp('Testing +vlt/+neuro/+spikesorting/spikewaves2pca.m ...');
        features = vlt.neuro.spikesorting.spikewaves2pca(waves, N, [1 NumSamples]);

        expected_size = [N, NumSpikes];
        if isequal(size(features), expected_size)
            disp('PASS: Output dimensions are correct.');
        else
            disp(['FAIL: Expected size ' mat2str(expected_size) ', got ' mat2str(size(features))]);
        end

        if all(isnan(features(:, 5))) && all(isnan(features(:, 10)))
            disp('PASS: NaN spikes resulted in NaN features.');
        else
            disp('FAIL: NaN spikes did not result in NaN features correctly.');
        end

    catch ME
        disp(['ERROR: ' ME.message]);
    end

end
