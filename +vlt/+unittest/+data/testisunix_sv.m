classdef testisunix_sv < matlab.unittest.TestCase
    % testisunix_sv - tests for vlt.data.isunix_sv
    %
    %

    properties
    end

    methods (Test)

        function test_isunix_sv_runs(testCase)
            % just test that it runs and returns a logical
            output = vlt.data.isunix_sv;
            testCase.verifyClass(output, 'logical');
            testCase.verifySize(output, [1 1]);
        end

    end
end
