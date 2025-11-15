classdef rename_mfiles_functionsTest < matlab.unittest.TestCase
    properties
        TestDir1
        TestDir2
    end

    methods (TestMethodSetup)
        function createTestDirs(testCase)
            testCase.TestDir1 = [tempname '-1'];
            testCase.TestDir2 = [tempname '-2'];
            mkdir(testCase.TestDir1);
            mkdir(testCase.TestDir2);
        end
    end

    methods (TestMethodTeardown)
        function removeTestDirs(testCase)
            rmdir(testCase.TestDir1, 's');
            rmdir(testCase.TestDir2, 's');
        end
    end

    methods (Test)
        function testFunctionNotImplementedError(testCase)
            testCase.verifyError(@() rename_mfiles_functions(testCase.TestDir1, testCase.TestDir2), ...
                '', 'Function should throw an error indicating it is not implemented.');
        end
    end
end
