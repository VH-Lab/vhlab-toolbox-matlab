function p_val = posthoc_coef_test(lme, ref_group, test_group)
% POSTHOC_COEF_TEST - Performs a post-hoc contrast test on an LME model.
%
%   p_val = vlt.stats.power.posthoc_coef_test(lme, ref_group, test_group)
%
%   Calculates the p-value for a specific post-hoc comparison on a fitted
%   Linear Mixed-Effects model (`lme`).
%
%   The function constructs a contrast vector (H) that represents the
%   difference between the `test_group` and the `ref_group`. It then uses
%   MATLAB's `coefTest` to perform an F-test and return the resulting p-value.
%
%   The `ref_group` and `test_group` are structs that define the specific
%   levels of the factors to be compared.
%

    fields = fieldnames(ref_group);
    coeff_names = lme.CoefficientNames;

    % Create the contrast vector H. It will have one element for each
    % coefficient in the model.
    H = zeros(1, numel(coeff_names));

    % --- Build the contrast for the TEST group ---
    % For each factor in our test group, find the corresponding coefficient
    % in the model and set its value in the contrast vector to 1.
    for i = 1:numel(fields)
        field = fields{i};
        value = test_group.(field);

        % Construct the coefficient name (e.g., 'Condition_Hunting XPro')
        coeff_str = [field '_' value];

        idx = find(strcmp(coeff_names, coeff_str));
        if ~isempty(idx)
            H(idx) = 1;
        end
    end

    % --- Build the contrast for the REFERENCE group ---
    % For each factor in our reference group, find the corresponding coefficient
    % and set its value in the contrast vector to -1.
    for i = 1:numel(fields)
        field = fields{i};
        value = ref_group.(field);

        % Construct the coefficient name
        coeff_str = [field '_' value];

        idx = find(strcmp(coeff_names, coeff_str));
        if ~isempty(idx)
            H(idx) = H(idx) - 1; % Subtract from H
        end
    end

    % Perform the F-test for the contrast H.
    [~, ~, p_val] = coefTest(lme, H);

end
