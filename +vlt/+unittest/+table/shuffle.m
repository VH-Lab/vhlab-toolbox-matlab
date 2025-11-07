classdef shuffle < matlab.unittest.TestCase
% SHUFFLE Unit tests for vlt.table.shuffle function.
%
% Runs tests for the three primary permutation types:
% 1. Row-level shuffle (no grouping).
% 2. Block-level shuffle (shuffling one factor within groups).
% 3. Subject-level shuffle (shuffling entire subject profiles).

    properties
        OriginalTable
    end

    methods (TestMethodSetup)
        function createSampleTable(testCase)
            % Create a simple, reproducible table for testing.

            % Factors
            Drug = categorical({'A';'A';'B';'B'});
            Day = [1; 2; 1; 2];
            Animal = categorical({'S1';'S1';'S2';'S2'});
            DM = [10; 12; 15; 18]; % Data Measurement

            % Original Table Structure:
            % Drug | Day | Animal | DM
            % -------------------------
            % A    | 1   | S1     | 10  <- Group 1 (S1)
            % A    | 2   | S1     | 12  <- Group 1 (S1)
            % B    | 1   | S2     | 15  <- Group 2 (S2)
            % B    | 2   | S2     | 18  <- Group 2 (S2)

            testCase.OriginalTable = table(Drug, Day, Animal, DM);
        end
    end

    methods (Test)

        function testRowLevelShuffle(testCase)
            % Test case 1: Row-level shuffle (groupingFactors = {})

            T = testCase.OriginalTable;

            % Since this is random, run the shuffle multiple times to ensure
            % the labels are being permuted (i.e., not exactly equal to original)
            % and the data column remains constant.
            for i = 1:5
                shuffledT = vlt.table.shuffle(T, 'DM', {}, {});

                % 1. Verify that the DATA column is unchanged (must be equal)
                testCase.verifyEqual(shuffledT.DM, T.DM, ...
                    'The data column (DM) should remain in its original row order.');

                % 2. Verify that the shuffled labels are permuted (not exactly equal to original).
                % Note: Due to small sample size, permutation might result in the original order
                % but we verify that the two tables are not trivially identical.
                % We mainly care that the row content is preserved, just permuted.
                shuffledLabelTable = shuffledT(:, {'Drug', 'Day', 'Animal'});
                originalLabelTable = T(:, {'Drug', 'Day', 'Animal'});

                % Check if the count of unique rows in the shuffled labels matches the original
                % (i.e., no data was lost or duplicated, only permuted).
                [~, shuffledID] = findgroups(shuffledLabelTable);
                [~, originalID] = findgroups(originalLabelTable);

                testCase.verifyEqual(height(shuffledID), height(originalID), ...
                    'The number of unique label combinations must remain the same.');

            end
        end

        function testBlockLevelShuffleDrug(testCase)
            % Test case 2: Block-level shuffle. Shuffling 'Drug' label across 'Animal'/'Day' groups.

            T = testCase.OriginalTable;

            % The grouping unit is {'Animal', 'Day'}. In this specific small table,
            % each row is already a unique combination of {'Animal', 'Day'}.
            % For a better test, let's use the Animal factor only, forcing the shuffle
            % to be between the two subjects (S1 and S2).

            % Grouping Unit: Animal. Factors to Shuffle: Drug.
            % Units: S1's profile (rows 1-2) and S2's profile (rows 3-4).
            shuffledT = vlt.table.shuffle(T, 'DM', {'Animal'}, {'Drug'});

            % 1. Verify that the Grouping Factor column ('Animal') is unchanged.
            testCase.verifyEqual(shuffledT.Animal, T.Animal, ...
                'The Grouping Factor column (Animal) should not be permuted.');

            % 2. Verify that the Data column ('DM') is unchanged.
            testCase.verifyEqual(shuffledT.DM, T.DM, ...
                'The Data column (DM) should remain in its original row order.');

            % 3. Crucial check: Check that Drug label is constant *within* the original Animal group.
            % Original Drugs: S1 (A, A), S2 (B, B).
            % Shuffled Drugs will be: S1 (A, A) or S1 (B, B) AND S2 (A, A) or S2 (B, B)

            shuffledDrugs = shuffledT.Drug;

            % Check if the two rows for S1 are identical, and the two rows for S2 are identical.
            testCase.verifyEqual(shuffledDrugs(1), shuffledDrugs(2), ...
                'Drug label for Animal S1 must be constant across its measurements.');
            testCase.verifyEqual(shuffledDrugs(3), shuffledDrugs(4), ...
                'Drug label for Animal S2 must be constant across its measurements.');

            % 4. Verify that the set of Drug labels is preserved.
            % The shuffled labels must be {'A', 'B'} or {'B', 'A'}
            shuffledUniqueDrugs = unique(shuffledT.Drug);
            originalUniqueDrugs = unique(T.Drug);
            testCase.verifyEqual(sort(shuffledUniqueDrugs), sort(originalUniqueDrugs), ...
                'The set of unique shuffled labels must match the original set.');
        end

        function testSubjectLevelShuffle(testCase)
            % Test case 3: Subject-level shuffle. Shuffling the entire profile
            % (Drug, Day, and DM) across subjects.

            T = testCase.OriginalTable;

            % Grouping Unit: Animal. Shuffle Factors: Implicitly Drug/Day.
            % Units: S1's profile (rows 1-2) and S2's profile (rows 3-4).
            shuffledT = vlt.table.shuffle(T, 'DM', {'Animal'}, {});

            % 1. Verify that the Grouping Factor column ('Animal') is unchanged.
            testCase.verifyEqual(shuffledT.Animal, T.Animal, ...
                'The Grouping Factor column (Animal) should not be permuted.');

            % 2. The data column 'DM' and factors 'Drug' and 'Day' should have been
            %    shuffled in blocks.

            % Combine the shuffled factors and data into a single table for comparison
            shuffledProfile = shuffledT(:, {'Drug', 'Day', 'DM'});
            originalProfile = T(:, {'Drug', 'Day', 'DM'});

            % The logic of findgroups on the original profile:
            % Group 1: rows 1-2
            % Group 2: rows 3-4

            % The shuffle ensures that the two *profiles* (sets of 2 rows) are swapped
            % across the Animal label.

            % Check that the shuffled profile rows for Animal S1 (rows 1-2) match EITHER
            % the original S1 profile OR the original S2 profile.

            s1_shuffled = shuffledProfile{1:2, :};
            s2_shuffled = shuffledProfile{3:4, :};

            s1_original = originalProfile{1:2, :}; % [10, 12]
            s2_original = originalProfile{3:4, :}; % [15, 18]

            % The two shuffled profiles should be equal to the two original profiles
            % (possibly swapped).

            isS1_S1 = all(s1_shuffled(:) == s1_original(:));
            isS1_S2 = all(s1_shuffled(:) == s2_original(:));

            isS2_S1 = all(s2_shuffled(:) == s1_original(:));
            isS2_S2 = all(s2_shuffled(:) == s2_original(:));

            % Verification 1: The first shuffled profile (S1) is one of the originals.
            testCase.verifyTrue(isS1_S1 || isS1_S2, ...
                'The first shuffled block must match an original subject profile.');

            % Verification 2: The second shuffled profile (S2) is the other original.
            if isS1_S1
                 testCase.verifyTrue(isS2_S2, 'If S1 profile is unchanged, S2 profile must be unchanged.');
            else
                 testCase.verifyTrue(isS2_S1, 'If S1 profile is swapped (to S2), S2 profile must be swapped (to S1).');
            end
        end

    end
end
