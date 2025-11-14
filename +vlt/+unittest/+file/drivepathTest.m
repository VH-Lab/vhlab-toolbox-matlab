classdef drivepathTest < matlab.unittest.TestCase
    methods(Test)
        function test_drivepath_output(testCase)
            % Test the output of drivepath based on the current OS

            p = vlt.file.drivepath();

            switch computer
                case 'GLNXA66'
                    expected = '/media';
                case 'MACI64'
                    expected = '/Volumes';
                case 'PCWIN64'
                    expected = '';
                otherwise
                    expected = ''; % Default case
            end

            testCase.verifyEqual(p, expected, ['Failed on ' computer]);
        end
    end
end
