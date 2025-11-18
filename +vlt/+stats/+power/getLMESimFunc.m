function func_handle = getLMESimFunc(method, options)
% GETLMESIMFUNC - Selects the correct simulation function handle.
%   This helper function acts as a router. Based on the user's 'Method'
%   selection ('gaussian', 'shuffle', etc.) and other options, it returns a
%   function handle to the appropriate simulation function. This allows the
%   main loop in `lme_power_effectsize` to call the selected simulation
%   method using a consistent syntax.

    arguments
        method (1,1) string
        options.ShufflePredictor {mustBeTextScalar} = ''
        options.InteractionFields cell = {}
    end

    if ~isempty(options.ShufflePredictor)
        % If a predictor to shuffle is specified, it overrides the 'method'
        func_handle = @(lme_base, tbl_base, effect_size, primary_category, category_to_test, y_name, group_name) ...
            vlt.stats.power.simulate_lme_data_shuffle_predictor(...
                lme_base, tbl_base, effect_size, primary_category, category_to_test, y_name, group_name, ...
                'ShufflePredictor', options.ShufflePredictor, 'InteractionFields', options.InteractionFields);
        return;
    end

    switch lower(method)
        case 'gaussian'
            func_handle = @vlt.stats.power.simulate_lme_data;
        case 'shuffle'
            func_handle = @vlt.stats.power.simulate_lme_data_shuffled;
        case 'hierarchical'
            func_handle = @vlt.stats.power.simulate_lme_data_hierarchical;
    end
end
