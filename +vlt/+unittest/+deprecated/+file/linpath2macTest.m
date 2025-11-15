classdef linpath2macTest < matlab.unittest.TestCase

    methods (Test)

        function test_linpath2mac_conversion(testCase)
            linux_path = '/home/user/my/file.txt';
            expected_mac_path = ':home:user:my:file.txt';
            actual_mac_path = linpath2mac(linux_path);
            testCase.verifyEqual(actual_mac_path, expected_mac_path, 'The linux path was not correctly converted to a mac path.');
        end

    end

end
