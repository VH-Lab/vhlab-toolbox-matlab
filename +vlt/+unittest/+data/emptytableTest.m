classdef emptytableTest < matlab.unittest.TestCase
    methods (Test)
        function testEmptyTableCreation(testCase)
            t = vlt.data.emptytable("id","string","x","double","y","double");
            testCase.verifyTrue(istable(t));
            testCase.verifyEmpty(t);
            testCase.verifyEqual(t.Properties.VariableNames, {'id', 'x', 'y'});
            testCase.verifyEqual(t.Properties.VariableTypes, {'string', 'double', 'double'});
        end
    end
end
