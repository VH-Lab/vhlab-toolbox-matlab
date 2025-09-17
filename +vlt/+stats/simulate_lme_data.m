function simTbl = simulate_lme_data(lme_base, tbl_base, effect_size, category_name, category_level, y_name, ~)
% SIMULATE_LME_DATA - (Helper) Generates data using the 'gaussian' (parametric) method.
%
%   Methodology:
%   This function simulates new data based on the idealized assumption that
%   both the random effects and the residual errors come from normal (Gaussian)
%   distributions. The parameters for these distributions (variances) are
%   estimated from the baseline model fit on the original data.
%
%   Process:
%   1.  Extracts the fixed intercept, random effect standard deviation, and
%       residual standard deviation from the `lme_base` model.
%   2.  Simulates random effects by drawing one value for each group from
%       N(0, sigma_random).
%   3.  Simulates residual errors by drawing one value for each observation
%       from N(0, sigma_resid).
%   4.  Constructs the simulated response Y_sim = Intercept + RandomEffect + Residual.
%   5.  "Injects" the `effect_size` by adding it to all rows belonging to
%       the `category_level`.
%
%   Assumptions:
%   -   The random effects and residuals in the true population are normally
%       distributed.
%
%   Pros/Cons:
%   +   Statistically efficient and powerful if the normality assumption is correct.
%   -   Can produce inaccurate power estimates if the true error distributions
%       are skewed, heavy-tailed, or otherwise non-normal.
%
    beta_base = lme_base.fixedEffects;
    sigma_resid = sqrt(lme_base.MSE);
    D = lme_base.covarianceParameters{1};
    sigma_random = sqrt(D(1,1));
    group_var_name = lme_base.RandomEffectInfo.GroupingVariableName{1};
    groups = tbl_base.(group_var_name);
    [unique_groups, ~, group_idx] = unique(groups);
    num_groups = length(unique_groups);
    num_obs = height(tbl_base);
    random_effects_per_group = randn(num_groups, 1) * sigma_random;
    random_effects = random_effects_per_group(group_idx);
    residual_error = randn(num_obs, 1) * sigma_resid;
    fixed_effects = ones(num_obs, 1) * beta_base(1);
    is_target_category = tbl_base.(category_name) == category_level;
    fixed_effects(is_target_category) = fixed_effects(is_target_category) + effect_size;
    Y_sim = fixed_effects + random_effects + residual_error;
    simTbl = tbl_base;
    simTbl.(y_name) = Y_sim;
end
