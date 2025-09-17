function test_flattenstruct()
% TEST_FLATTENSTRUCT - Test for vlt.data.flattenstruct
%
    % Test case 1: Simple structure
    A = struct('AA', struct('AAA', 5, 'AAB', 7), 'AB', 2);
    SF = vlt.data.flattenstruct(A, 'A__');
    assert(isfield(SF, 'A__AA__AAA'), 'Field A__AA__AAA should exist');
    assert(isfield(SF, 'A__AA__AAB'), 'Field A__AA__AAB should exist');
    assert(isfield(SF, 'A__AB'), 'Field A__AB should exist');
    assert(SF.A__AA__AAA == 5, 'SF.A__AA__AAA should be 5');
    assert(SF.A__AA__AAB == 7, 'SF.A__AA__AAB should be 7');
    assert(SF.A__AB == 2, 'SF.A__AB should be 2');

    % Test case 2: Structure array
    A(1).a = 1;
    A(1).b = struct('c',2);
    A(2).a = 3;
    A(2).b = struct('c',4);
    SF = vlt.data.flattenstruct(A);
    assert(isfield(SF, 'a'), 'Field a should exist');
    assert(isfield(SF, 'b__c'), 'Field b__c should exist');
    assert(isequal([SF.a], [1 3]), 'The values of a are not correct');
    assert(isequal([SF.b__c], [2 4]), 'The values of b__c are not correct');

    disp('All tests for vlt.data.flattenstruct passed.');
end
