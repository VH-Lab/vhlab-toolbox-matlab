classdef test_savevar < matlab.unittest.TestCase
    % TEST_SAVEVAR - tests for the vlt.data.savevar function

    properties
        test_dir
    end

    methods (TestMethodSetup)
        function create_test_dir(testCase)
            testCase.test_dir = tempname;
            mkdir(testCase.test_dir);
        end
    end

    methods (TestMethodTeardown)
        function remove_test_dir(testCase)
            if exist(testCase.test_dir, 'dir')
                rmdir(testCase.test_dir, 's');
            end
        end
    end

    methods (Test)
        function test_savevar_basic(testCase)
            filename = fullfile(testCase.test_dir, 'testfile.mat');
            lock_filename = [filename '-lock'];

            % Ensure files don't exist initially
            testCase.verifyFalse(exist(filename, 'file') == 2);
            testCase.verifyFalse(exist(lock_filename, 'file') == 2);

            data_to_save = [1 2 3; 4 5 6];
            variable_name = 'my_test_variable';

            vlt.data.savevar(filename, data_to_save, variable_name, '-mat');

            % Verify the file was created and the lock file is gone
            testCase.verifyTrue(exist(filename, 'file') == 2);
            testCase.verifyFalse(exist(lock_filename, 'file') == 2);

            % Load the file and verify its contents
            loaded_data = load(filename);
            testCase.verifyTrue(isfield(loaded_data, variable_name));
            testCase.verifyEqual(loaded_data.(variable_name), data_to_save);
        end

    end; % methods (Test)

end
