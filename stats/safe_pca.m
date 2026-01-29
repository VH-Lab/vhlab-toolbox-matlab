function [coeff, score, latent] = safe_pca(X, varargin)
    % Find all instances of 'pca' on the path
    allPCAPaths = which('pca', '-all');
    
    % Identify the one residing in the MATLAB toolbox directory
    % (Looking for 'toolbox/stats' is the reliable signature)
    isStatsBox = contains(allPCAPaths, fullfile(matlabroot, 'toolbox', 'stats'));
    
    if ~any(isStatsBox)
        error('Statistics Toolbox PCA not found on path.');
    end
    
    % Get the folder containing the correct pca.m
    statsPCA_Path = fileparts(allPCAPaths{find(isStatsBox, 1)});
    
    % Save current directory
    oldDir = pwd;
    
    % Use a try-catch block to ensure we always return to the original directory
    try
        cd(statsPCA_Path);
        stats_pca_func = @pca; % Create handle to the function in the CURRENT folder
        cd(oldDir);
    catch ME
        cd(oldDir);
        rethrow(ME);
    end
    
    % Now call the specific function handle
    [coeff, score, latent] = stats_pca_func(X, varargin{:});
end
