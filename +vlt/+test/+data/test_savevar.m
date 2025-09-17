function test_savevar()
% TEST_SAVEVAR - Test for vlt.data.savevar
%
    filename = 'test_savevar_file.mat';
    my_data = [1 2 3];
    variable_name = 'my_variable_name';

    % Clean up any old test file
    if exist(filename, 'file')
        delete(filename);
    end

    % Test saving the variable
    vlt.data.savevar(filename, my_data, variable_name);
    assert(exist(filename, 'file') == 2, 'The file was not created');

    % Test loading the variable and verifying its content
    loaded_data = load(filename);
    assert(isfield(loaded_data, variable_name), 'The variable was not saved with the correct name');
    assert(isequal(loaded_data.(variable_name), my_data), 'The loaded data does not match the original');

    % Clean up the test file
    delete(filename);

    disp('All tests for vlt.data.savevar passed.');
end
