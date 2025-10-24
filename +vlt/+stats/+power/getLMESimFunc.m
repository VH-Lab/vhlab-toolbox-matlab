function func_handle = getLMESimFunc(method)
% GETLMESIMFUNC - Selects the correct simulation function handle.
%   This helper function acts as a router. Based on the user's 'Method'
%   selection ('gaussian', 'shuffle', or 'hierarchical'), it returns a
%   function handle to the appropriate simulation function. This allows the
%   main loop in `lme_power_effectsize` to call the selected simulation
%   method using a consistent syntax via `feval`.
    switch lower(method)
        case 'gaussian'
            func_handle = @vlt.stats.power.simulate_lme_data;
        case 'shuffle'
            func_handle = @vlt.stats.power.simulate_lme_data_shuffled;
        case 'hierarchical'
            func_handle = @vlt.stats.power.simulate_lme_data_hierarchical;
    end
end
