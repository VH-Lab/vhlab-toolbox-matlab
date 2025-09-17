function run_data_tests()
% RUN_DATA_TESTS - Run all tests for the vlt.data package
%
    test_dir = '+vlt/+test/+data/';
    test_files = dir([test_dir 'test_*.m']);

    for i = 1:length(test_files)
        test_file = test_files(i).name;
        test_name = strrep(test_file, '.m', '');
        disp(['Running test: ' test_name]);
        try
            run([test_dir test_file]);
        catch e
            disp(['Error in test: ' test_name]);
            disp(e.message);
        end
    end
end
