function p_value = posthoc_coef_test(lme_model, ref_group_struct, test_group_struct)
% VLT.STATS.POSTHOC_COEF_TEST - Performs an F-test for a post-hoc comparison on an LME model.
%
%   P = VLT.STATS.POSTHOC_COEF_TEST(LME_MODEL, REF_GROUP_STRUCT, TEST_GROUP_STRUCT)
%
%   This function calculates the p-value for a specific post-hoc contrast in a
%   fitted Linear Mixed-Effects model (LME_MODEL). It constructs a contrast
%   vector to compare a reference group (REF_GROUP_STRUCT) against a test
%   group (TEST_GROUP_STRUCT) and uses an F-test (`coefTest`) to determine the
%   significance of the difference.
%
%   This is a crucial helper for multi-factor power analysis, where we need to
%   evaluate the significance of a specific interaction or group comparison
%   that isn't directly provided in the model's standard coefficient table.
%
%   Arguments:
%     lme_model (LinearMixedModel): The fitted LME model object from `fitlme`.
%
%     ref_group_struct (struct): A scalar struct defining the reference group.
%       Field names must match factor names in the model, and values must match
%       factor levels.
%
%     test_group_struct (struct): A scalar struct defining the test group to
%       compare against the reference.
%
%   Returns:
%     p_value (double): The p-value from the F-test of the contrast.
%
%   See also: FITLME, COEFTEST, VLT.STATS.POWER.LME_POWER_EFFECTSIZE

    % Get the design matrix for the fixed effects
    X = lme_model.designMatrix('fixed');

    % Get the names of the coefficients in the model
    coef_names = lme_model.CoefficientNames;

    % Find the row in the design matrix corresponding to the reference group
    ref_row_idx = find_row_for_group(lme_model.Variables, ref_group_struct);

    % Find the row for the test group
    test_row_idx = find_row_for_group(lme_model.Variables, test_group_struct);

    if isempty(ref_row_idx) || isempty(test_row_idx)
        warning('vlt:stats:posthoc_coef_test:groupNotFound', ...
            'Could not find a data row matching the ref or test group; returning p=1.');
        p_value = 1;
        return;
    end

    % The contrast vector is the difference between the design matrix rows
    % for the test group and the reference group. We only need one instance.
    contrast_vector = X(test_row_idx(1), :) - X(ref_row_idx(1), :);

    % Perform the F-test
    [~, p_value] = coefTest(lme_model, contrast_vector);

end

function row_idx = find_row_for_group(tbl, group_struct)
    % Helper to find the first row index in a table that matches all criteria
    % in a group definition struct.

    fields = fieldnames(group_struct);

    % Start with a logical vector of all true
    matching_rows = true(height(tbl), 1);

    for i = 1:numel(fields)
        field = fields{i};
        value = group_struct.(field);

        table_col_data = tbl.(field);

        % Accumulate the logical AND across all fields
        matching_rows = matching_rows & (table_col_data == value);
    end

    % Find the first index that is true
    row_idx = find(matching_rows, 1, 'first');
end
