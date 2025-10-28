function simTbl = simulate_lme_data_shuffled(lme_base, tbl_base, effect_size, category_name, category_level, y_name, ~)
% SIMULATE_LME_DATA_SHUFFLED - (Helper) Generates data using the 'shuffle' method.
%
%   Methodology:
%   This is a non-parametric method that simulates data under the null
%   hypothesis by shuffling the model's residuals. It makes no assumption
%   about the shape of the error distribution, instead using the empirical
%   distribution of the errors observed in the data.
%
%   Process:
%   1.  Calculates the composite residuals from the baseline model (Residual =
%       Observed_Y - Grand_Mean). This residual combines the random effect
%       and the individual error term.
%   2.  Pools all residuals together and shuffles them randomly.
%   3.  Creates a simulated null dataset by adding the shuffled residuals back
%       to the grand mean. This breaks any relationship between predictors
%       and the outcome.
%   4.  Injects the `effect_size` to create the alternative hypothesis dataset.
%
%   Assumptions:
%   -   Assumes "exchangeability" of the composite residuals across the entire
%       dataset. This means it assumes any error could have occurred for any
%       observation, regardless of its group membership.
%
%   Pros/Cons:
%   +   Robust to violations of normality.
%   -   The exchangeability assumption is strong and often inappropriate for
%       mixed models, as it ignores the dependency within groups. This can
%       make it less accurate than the hierarchical method.
%
    beta = lme_base.fixedEffects;
    fixed_prediction = beta(1);
    y_observed = tbl_base.(y_name);
    num_obs = height(tbl_base);
    residuals = y_observed - fixed_prediction;
    shuffled_residuals = residuals(randperm(num_obs));
    Y_sim_null = fixed_prediction + shuffled_residuals;
    Y_sim = Y_sim_null;
    is_target_category = vlt.stats.power.find_group_indices(tbl_base, category_level, category_name);
    Y_sim(is_target_category) = Y_sim(is_target_category) + effect_size;
    simTbl = tbl_base;
    simTbl.(y_name) = Y_sim;
end
