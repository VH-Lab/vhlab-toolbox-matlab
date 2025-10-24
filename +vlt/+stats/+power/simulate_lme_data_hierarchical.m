function simTbl = simulate_lme_data_hierarchical(lme_base, tbl_base, effect_size, category_name, category_level, y_name, group_name)
% SIMULATE_LME_DATA_HIERARCHICAL - (Helper) Generates data using the 'hierarchical' method.
%
%   Methodology:
%   This is a sophisticated non-parametric method that respects the nested
%   structure of a mixed-effects model. It simulates the null hypothesis by
%   shuffling the outcome variable *within* each random effect group. This
%   breaks the association between the fixed effects and the outcome, while
%   correctly preserving the dependencies among observations in the same group.
%
%   Process:
%   1.  For each group (e.g., for each manufacturer 'Mfg'), it takes all the
%       observed Y values.
%   2.  It shuffles these Y values *only within that group*.
%   3.  This is repeated independently for every group.
%   4.  The result is a simulated null dataset where the within-group data
%       structure is maintained, but the relationship between Y and the fixed
%       predictors (like 'Model_Year') is randomized.
%   5.  Injects the `effect_size` to create the alternative hypothesis dataset.
%
%   Assumptions:
%   -   Assumes "exchangeability" of observations *within* each group.
%
%   Pros/Cons:
%   +   Robust to violations of normality.
%   +   Theoretically sound for mixed models as it preserves the random-effects
%       structure. It is generally the preferred non-parametric method.
%   -   May be less effective if some groups have very few observations to shuffle.
%
    y_observed = tbl_base.(y_name);
    groups = tbl_base.(group_name);
    unique_groups = unique(groups);
    num_obs = height(tbl_base);
    Y_sim_null = zeros(num_obs, 1);
    for i = 1:length(unique_groups)
        current_group = unique_groups(i);
        is_in_group = (groups == current_group);
        y_for_this_group = y_observed(is_in_group);
        y_shuffled_for_this_group = y_for_this_group(randperm(length(y_for_this_group)));
        Y_sim_null(is_in_group) = y_shuffled_for_this_group;
    end
    Y_sim = Y_sim_null;
    is_target_category = tbl_base.(category_name) == category_level;
    Y_sim(is_target_category) = Y_sim(is_target_category) + effect_size;
    simTbl = tbl_base;
    simTbl.(y_name) = Y_sim;
end
