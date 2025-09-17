function results = run_data_tests()
% RUN_DATA_TESTS - Run all tests for the vlt.data package
%
    results = runtests('+vlt/+unittest/+data');
end
