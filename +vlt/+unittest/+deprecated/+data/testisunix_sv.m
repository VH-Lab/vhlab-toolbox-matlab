classdef testisunix_sv < matlab.unittest.TestCase
    % testisunix_sv - tests for isunix_sv (deprecated)
    %
    %

    properties
    end

    methods (Test)

        function test_isunix_sv_runs(testCase)
            % just test that it runs and returns a logical
            output = isunix_sv;
            testCase.verifyClass(output, 'logical');
            testCase.verifySize(output, [1 1]);
        end

    end
end
