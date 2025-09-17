classdef savevarTest < matlab.unittest.TestCase
    properties
        filename = 'test_savevar_file.mat';
    end

    methods (TestMethodTeardown)
        function cleanup(testCase)
            if exist(testCase.filename, 'file')
                delete(testCase.filename);
            end
        end
    end

    methods (Test)
        function testSaveAndLoad(testCase)
            my_data = [1 2 3];
            variable_name = 'my_variable_name';

            vlt.data.savevar(testCase.filename, my_data, variable_name);
            testCase.verifyTrue(exist(testCase.filename, 'file') == 2);

            loaded_data = load(testCase.filename);
            testCase.verifyTrue(isfield(loaded_data, variable_name));
            testCase.verifyEqual(loaded_data.(variable_name), my_data);
        end
    end
end
