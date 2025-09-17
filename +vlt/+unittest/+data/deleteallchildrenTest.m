classdef deleteallchildrenTest < matlab.unittest.TestCase
    methods (Test)
        function testDeleteAxesChildren(testCase)
            f = figure;
            testCase.addTeardown(@() close(f));
            plot(1:10);
            hold on;
            plot(10:-1:1);
            vlt.data.deleteallchildren(gca);
            testCase.verifyEmpty(get(gca, 'Children'));
        end
    end
end
