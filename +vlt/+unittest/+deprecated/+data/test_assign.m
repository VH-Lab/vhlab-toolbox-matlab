classdef test_assign < matlab.unittest.TestCase
    % TEST_ASSIGN - tests for the deprecated assign function
    %
    %

    properties
        vltroot
        datapath
    end

    methods (TestMethodSetup)
        function setup_path(testCase)
            % find the path to the VLT repository
            [pathstr, ~, ~] = fileparts(mfilename('fullpath'));
            testCase.vltroot = fileparts(fileparts(fileparts(fileparts(fileparts(pathstr)))));
            testCase.datapath = fullfile(testCase.vltroot, 'datastructures');
            addpath(testCase.datapath);
        end
    end

    methods (TestMethodTeardown)
        function teardown_path(testCase)
            rmpath(testCase.datapath);
        end
    end

    methods (Test)

        function test_assign_name_value_pairs(testCase)
            % define some variables
            a = 1;
            b = [ 1 2 3 ];
            c = 'mytest';

            % now call assign to change them
            assign('a', 5, 'b', [4 5]);

            % and verify they are changed
            testCase.verifyEqual(a, 5);
            testCase.verifyEqual(b, [4 5]);
            testCase.verifyEqual(c, 'mytest'); % verify c is untouched
        end % test_assign_name_value_pairs

        function test_assign_structure(testCase)
            % define some variables
            a = 1;
            b = [ 1 2 3 ];
            c = 'mytest';

            myStruct.a = 'new_a';
            myStruct.b = {'new_b'};

            % now call assign to change them
            assign(myStruct);

            % and verify they are changed
            testCase.verifyEqual(a, 'new_a');
            testCase.verifyEqual(b, {'new_b'});
            testCase.verifyEqual(c, 'mytest'); % verify c is untouched
        end % test_assign_structure

        function test_assign_cell(testCase)
            % define some variables
            a = 1;
            b = [ 1 2 3 ];
            c = 'mytest';

            myCell = {'a', 'new_a_cell', 'b', {'new_b_cell'}};

            % now call assign to change them
            assign(myCell);

            % and verify they are changed
            testCase.verifyEqual(a, 'new_a_cell');
            testCase.verifyEqual(b, {'new_b_cell'});
            testCase.verifyEqual(c, 'mytest'); % verify c is untouched
        end % test_assign_cell

    end; % methods (Test)

end