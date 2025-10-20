classdef test_deleteallchildren < matlab.unittest.TestCase
    % TEST_DELETEALLCHILDREN - tests for the vlt.data.deleteallchildren function
    %
    %

    properties
    end

    methods (Test)

        function test_deleteallchildren_simple(testCase)
            % create a figure with some children
            h = figure('Visible','off');
            c1 = uicontrol('Parent',h);
            c2 = uicontrol('Parent',h);
            c3 = uicontrol('Parent',h);

            % get the list of children
            children_before = get(h,'children');
            testCase.verifyEqual(length(children_before), 3);

            % now call deleteallchildren
            vlt.data.deleteallchildren(h);

            % and verify they are deleted
            children_after = get(h,'children');
            testCase.verifyEqual(length(children_after), 0);

            % close the figure
            close(h);
        end % test_deleteallchildren_simple

        function test_deleteallchildren_empty(testCase)
            % create a figure with no children
            h = figure('Visible','off');

            % get the list of children
            children_before = get(h,'children');
            testCase.verifyEqual(length(children_before), 0);

            % now call deleteallchildren
            vlt.data.deleteallchildren(h);

            % and verify they are deleted
            children_after = get(h,'children');
            testCase.verifyEqual(length(children_after), 0);

            % close the figure
            close(h);
        end % test_deleteallchildren_empty

        function test_deleteallchildren_invalid_handle(testCase)
            % call deleteallchildren with an invalid handle
            vlt.data.deleteallchildren(-1);
            % no error should be thrown, and nothing should happen
            testCase.verifyTrue(true);
        end % test_deleteallchildren_invalid_handle

    end; % methods (Test)

end
