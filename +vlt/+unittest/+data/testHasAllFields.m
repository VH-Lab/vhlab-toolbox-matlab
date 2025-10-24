classdef testHasAllFields < matlab.unittest.TestCase

    methods(Test)

        function testHasAllFields_SimpleSuccess(testCase)
            % Test case where all fields are present, no size check
            s = struct('field1', 'a', 'field2', [1 2 3]);
            fieldNames = {'field1', 'field2'};

            [good, errormsg] = vlt.data.hasAllFields(s, fieldNames);

            testCase.verifyTrue(logical(good), 'Should return true when all fields are present.');
            testCase.verifyEmpty(errormsg, 'Error message should be empty on success.');
        end

        function testHasAllFields_SimpleFail(testCase)
            % Test case where a field is missing, no size check
            s = struct('field1', 'a');
            fieldNames = {'field1', 'field2'};

            [good, errormsg] = vlt.data.hasAllFields(s, fieldNames);

            testCase.verifyFalse(logical(good), 'Should return false when a field is missing.');
            testCase.verifyEqual(errormsg, '''field2'' not present.', 'Incorrect error message for missing field.');
        end

        function testHasAllFields_SizeCheckSuccess(testCase)
            % Test case with successful size checking
            s = struct('field1', 'a', 'field2', [1 2 3], 'field3', ones(2,2));
            fieldNames = {'field1', 'field2', 'field3'};
            fieldSizes = {[1 1], [1 3], [2 2]};

            [good, errormsg] = vlt.data.hasAllFields(s, fieldNames, fieldSizes);

            testCase.verifyTrue(logical(good), 'Should return true when fields and sizes match.');
            testCase.verifyEmpty(errormsg, 'Error message should be empty on success.');
        end

        function testHasAllFields_SizeCheckFailWrongSize(testCase)
            % Test case with a field of the wrong size
            s = struct('field1', 'a', 'field2', [1 2 3 4]); % field2 is 1x4, not 1x3
            fieldNames = {'field1', 'field2'};
            fieldSizes = {[1 1], [1 3]};

            [good, errormsg] = vlt.data.hasAllFields(s, fieldNames, fieldSizes);

            testCase.verifyFalse(logical(good), 'Should return false when a field has the wrong size.');
            expected_err = 'field2 not of expected size (got 1x4 but expected 1x3).';
            testCase.verifyEqual(errormsg, expected_err, 'Incorrect error message for wrong size.');
        end

        function testHasAllFields_SizeCheckWildcard(testCase)
            % Test case with wildcard size checking
            s = struct('field1', rand(5,10), 'field2', 'some string');
            fieldNames = {'field1', 'field2'};
            fieldSizes = {[5 -1], [-1 -1]}; % Check rows of field1, ignore columns; ignore size of field2

            [good, errormsg] = vlt.data.hasAllFields(s, fieldNames, fieldSizes);

            testCase.verifyTrue(logical(good), 'Should return true when using wildcards correctly.');
            testCase.verifyEmpty(errormsg, 'Error message should be empty on success with wildcards.');
        end

        function testHasAllFields_SizeCheckWildcardFail(testCase)
            % Test case with wildcard size checking that fails
            s = struct('field1', rand(5,10));
            fieldNames = {'field1'};
            fieldSizes = {[6 -1]}; % Expect 6 rows, but has 5

            [good, errormsg] = vlt.data.hasAllFields(s, fieldNames, fieldSizes);

            testCase.verifyFalse(logical(good), 'Should fail when wildcard dimension does not match.');
            expected_err = 'field1 not of expected size (got 5x10 but expected 6xN).';
            testCase.verifyEqual(errormsg, expected_err, 'Incorrect error message for wildcard fail.');
        end

        function testHasAllFields_EmptyFieldNames(testCase)
            % Test case with empty fieldNames cell array
            s = struct('field1', 'a');
            fieldNames = {};

            [good, errormsg] = vlt.data.hasAllFields(s, fieldNames);

            testCase.verifyTrue(logical(good), 'Should return true for empty field list.');
            testCase.verifyEmpty(errormsg, 'Error message should be empty for empty field list.');
        end

    end
end
