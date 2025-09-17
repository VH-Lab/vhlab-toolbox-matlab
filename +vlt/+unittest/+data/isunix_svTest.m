classdef isunix_svTest < matlab.unittest.TestCase
    methods (Test)
        function testIsUnix(testCase)
            b = vlt.data.isunix_sv();
            testCase.verifyClass(b, 'double'); % or logical, depending on implementation
            testCase.verifyEqual(b, isunix);
        end
    end
end
