function tests = test_struct_name_value_search
% TEST_STRUCT_NAME_VALUE_SEARCH - test the vlt.db.struct_name_value_search function
%
    tests = functiontests(localfunctions);
end % test_struct_name_value_search

function setupOnce(testCase)
    % Create a sample struct for testing
    testCase.TestData.SampleStruct = struct('name', {'a', 'b', 'c', 'b'}, 'value', {1, 2, 3, 4});
end

function test_basic_search(testCase)
    % Test a basic successful search
    [v, i] = vlt.db.struct_name_value_search(testCase.TestData.SampleStruct, 'b');
    testCase.verifyEqual(v, 2, 'Value should be the first match');
    testCase.verifyEqual(i, 2, 'Index should be the first match');
end

function test_no_match_no_error(testCase)
    % Test for a non-existent item when makeerror is false
    [v, i] = vlt.db.struct_name_value_search(testCase.TestData.SampleStruct, 'd', false);
    testCase.verifyEmpty(v, 'Value should be empty for no match');
    testCase.verifyEmpty(i, 'Index should be empty for no match');
end

function test_no_match_with_error(testCase)
    % Test that an error is thrown for a non-existent item when makeerror is true
    testCase.verifyError(@() vlt.db.struct_name_value_search(testCase.TestData.SampleStruct, 'd', true), ...
        'vlt:db:struct_name_value_search:NotFound', ...
        'An error should be thrown when no match is found and makeerror is true');
end

function test_multiple_matches(testCase)
    % Test that the first match is returned when multiple matches exist
    [v, i] = vlt.db.struct_name_value_search(testCase.TestData.SampleStruct, 'b');
    testCase.verifyEqual(v, 2, 'Value should be from the first match');
    testCase.verifyEqual(i, 2, 'Index should point to the first match');
end