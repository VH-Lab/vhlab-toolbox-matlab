classdef test_structwhatvaries < matlab.unittest.TestCase
% Regression tests for issue #137, item 4: the accumulator was built with
% cat(1,descr,bothfn{j}), which appends a CHAR to a cell. When there are no
% differing or extra fieldnames, descr is still {} at that point, cat drops
% the empty, and descr becomes a char row vector instead of a cell. Appending
% a second fieldname then concatenates char-to-char and throws unless the two
% names happen to be the same length.

    methods (Test)

        function test_single_common_field_returns_cell(testCase)
            % With one common field and nothing else differing, descr is {}
            % when the first fieldname is appended. The result must stay a
            % cell rather than collapsing to char.
            s1 = struct('a', 1);
            s2 = struct('a', 2);
            descr = vlt.data.structwhatvaries({s1, s2});
            testCase.verifyClass(descr, 'cell', 'Result must be a cell, not a char array');
            testCase.verifyEqual(sort(descr(:)), {'a'});
        end

        function test_two_varying_fields_unequal_name_lengths(testCase)
            % The throwing case: two varying common fields whose names differ
            % in length, with no extra or missing fieldnames to seed descr.
            s1 = struct('a', 1, 'bb', 2);
            s2 = struct('a', 9, 'bb', 9);
            descr = vlt.data.structwhatvaries({s1, s2});
            testCase.verifyClass(descr, 'cell', 'Result must be a cell, not a char array');
            testCase.verifyEqual(sort(descr(:)), {'a'; 'bb'});
        end

        function test_no_variation(testCase)
            s1 = struct('a', 1, 'bb', 2);
            descr = vlt.data.structwhatvaries({s1, s1});
            testCase.verifyEmpty(descr, 'Identical structures should report nothing varying');
        end

        function test_extra_and_missing_fieldnames(testCase)
            % descr is seeded from setdiff here, so this path worked before;
            % keep it covered so the fix does not regress it.
            s1 = struct('a', 1, 'b', 2);
            s2 = struct('a', 1, 'c', 3);
            descr = vlt.data.structwhatvaries({s1, s2});
            testCase.verifyClass(descr, 'cell');
            testCase.verifyEqual(sort(descr(:)), {'b'; 'c'});
        end

        function test_mixed_extra_fields_and_varying_common_field(testCase)
            s1 = struct('a', 1, 'longname', 2);
            s2 = struct('a', 99, 'longname', 2, 'x', 3);
            descr = vlt.data.structwhatvaries({s1, s2});
            testCase.verifyClass(descr, 'cell');
            testCase.verifyEqual(sort(descr(:)), {'a'; 'x'});
        end

        function test_empty_list(testCase)
            descr = vlt.data.structwhatvaries({});
            testCase.verifyEmpty(descr, 'Empty cell list should return an empty result');
        end

        function test_requires_cell(testCase)
            testCase.verifyError(@() vlt.data.structwhatvaries(struct('a',1)), ?MException);
        end

        function test_all_nan_field_does_not_vary(testCase)
            % Issue #137, item 3. Comparison is ISEQUALN, so a field that is
            % NaN in every structure is constant, not varying. Under the old
            % EQLEN comparison this reported 'angle' as varying over exactly
            % one distinct value, which is what NDI-matlab#902 ran into.
            s1 = struct('angle', NaN, 'b', 1);
            s2 = struct('angle', NaN, 'b', 1);
            testCase.verifyEmpty(vlt.data.structwhatvaries({s1, s2}), ...
                'A field that is NaN in every structure must not be reported as varying');
        end

        function test_nan_inside_array_field_does_not_vary(testCase)
            s1 = struct('v', [1 NaN 3]);
            s2 = struct('v', [1 NaN 3]);
            testCase.verifyEmpty(vlt.data.structwhatvaries({s1, s2}), ...
                'Identical arrays containing NaN must not be reported as varying');
        end

        function test_nan_versus_value_varies(testCase)
            % NaN-aware does not mean NaN matches everything.
            s1 = struct('angle', NaN);
            s2 = struct('angle', 30);
            descr = vlt.data.structwhatvaries({s1, s2});
            testCase.verifyEqual(sort(descr(:)), {'angle'});
        end

        function test_char_and_double_still_compare_equal(testCase)
            % ISEQUALN compares a char against its double code point exactly
            % as == did, so switching the comparison did not change this:
            % isequaln('a',97) is true and the field is constant. An earlier
            % draft of this PR asserted the opposite and CI refuted it.
            % Pinned so the claim is not made again. Issue #137, item 3.
            s1 = struct('a', 'a');
            s2 = struct('a', 97);
            testCase.verifyEmpty(vlt.data.structwhatvaries({s1, s2}), ...
                'isequaln treats a char as its code point, as == does');
        end

    end
end
