classdef testSimpleLMEMDemo < matlab.unittest.TestCase
    
    methods (Test)
        
        function testExecution(testCase)
            % SCENARIO: Run the demo. Verify it completes without error.
            
            % 1. Identify existing figures so we can close only the new one
            figsBefore = findall(0, 'Type', 'figure');
            
            % 2. Run the Demo
            % If this function errors, the test framework will catch it and fail.
            try
                % Run with single effect size and no plot for speed/headless environment
                vlt.stats.power.simpleLMEMDemo(5.0, false);
                didRun = true;
            catch ME
                didRun = false;
                testCase.verifyFail(['Demo failed with error: ' ME.message]);
            end
            
            % 3. Verify success
            testCase.verifyTrue(didRun, 'The demo function did not run to completion.');
            
            % 4. Cleanup (Close the plot created by the demo)
            figsAfter = findall(0, 'Type', 'figure');
            newFigs = setdiff(figsAfter, figsBefore);
            
            % We use addTeardown to ensure closure even if verifications fail later
            if ~isempty(newFigs)
                testCase.addTeardown(@close, newFigs);
            end
        end
        
    end
end