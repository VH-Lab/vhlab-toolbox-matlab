classdef test_flattenstruct < matlab.unittest.TestCase
    % TEST_FLATTENSTRUCT - test the vlt.data.flattenstruct function

    properties
    end

    methods (Test)

        function test_simple_flatten(testCase)
            % create a nested struct and flatten it
            s = struct('a', 1, 'b', struct('c', 2, 'd', 3));
            f = vlt.data.flattenstruct(s);

            % verify that the struct is flattened
            testCase.verifyTrue(isfield(f, 'a'));
            testCase.verifyTrue(isfield(f, 'b__c'));
            testCase.verifyTrue(isfield(f, 'b__d'));

            % verify the values
            testCase.verifyEqual(f.a, 1);
            testCase.verifyEqual(f.b__c, 2);
            testCase.verifyEqual(f.b__d, 3);
        end

        function test_struct_array_flatten(testCase)
            % create a struct array and flatten it
            s(1).a = 1;
            s(1).b = struct('c', 2, 'd', 3);
            s(2).a = 4;
            s(2).b = struct('c', 5, 'd', 6);

            f = vlt.data.flattenstruct(s);

            % verify the size
            testCase.verifyEqual(size(f), [1 2]);

            % verify fields
            testCase.verifyTrue(isfield(f, 'a'));
            testCase.verifyTrue(isfield(f, 'b__c'));
            testCase.verifyTrue(isfield(f, 'b__d'));

            % verify values
            testCase.verifyEqual([f.a], [1 4]);
            testCase.verifyEqual([f.b__c], [2 5]);
            testCase.verifyEqual([f.b__d], [3 6]);
        end

        function test_prefix(testCase)
            s = struct('a', 1, 'b', struct('c', 2));
            f = vlt.data.flattenstruct(s, 'myprefix__');

            testCase.verifyTrue(isfield(f, 'myprefix__a'));
            testCase.verifyTrue(isfield(f, 'myprefix__b__c'));
            testCase.verifyEqual(f.myprefix__a, 1);
            testCase.verifyEqual(f.myprefix__b__c, 2);
        end

        function test_boolean_values(testCase)
            s = struct('a', true, 'b', struct('c', false, 'd', 1)); % mixed logical and double
            f = vlt.data.flattenstruct(s);

            % verify that the struct is flattened
            testCase.verifyTrue(isfield(f, 'a'));
            testCase.verifyTrue(isfield(f, 'b__c'));
            testCase.verifyTrue(isfield(f, 'b__d'));

            % verify the values, casting to logical for comparison
            testCase.verifyTrue(logical(f.a));
            testCase.verifyFalse(logical(f.b__c));
            testCase.verifyTrue(logical(f.b__d));
        end

        function test_deeply_nested(testCase)
            s = struct('a', 1, 'b', struct('c', 2, 'd', struct('e', 3)));
            f = vlt.data.flattenstruct(s);

            testCase.verifyTrue(isfield(f, 'a'));
            testCase.verifyTrue(isfield(f, 'b__c'));
            testCase.verifyTrue(isfield(f, 'b__d__e'));

            testCase.verifyEqual(f.a, 1);
            testCase.verifyEqual(f.b__c, 2);
            testCase.verifyEqual(f.b__d__e, 3);
        end

        function test_non_congruent_struct_array(testCase)
             s(1).a = 1;
             s(1).b = struct('c', 2);
             s(2).a = 4;
             s(2).b = struct('d', 6); % different field

             testCase.verifyError(@() vlt.data.flattenstruct(s), '');
        end

        function test_empty_struct(testCase)
            s = struct();
            f = vlt.data.flattenstruct(s);
            testCase.verifyTrue(isempty(fieldnames(f)));
        end

    end
end
