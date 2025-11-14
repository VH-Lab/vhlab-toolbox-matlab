classdef intanTest < matlab.unittest.TestCase
    methods (Test)
        function test_intan_readers(testCase)
            % Check if ndr.fun.ndrpath is on the path
            testCase.assumeTrue(exist('ndr.fun.ndrpath', 'file') == 2, ...
                'The function ndr.fun.ndrpath is not on the path, skipping test.');

            % Get the path to the example data
            example_data_path = fullfile(ndr.fun.ndrpath,'example_data');

            % Get a list of all .rhd files in the directory
            rhd_files = dir(fullfile(example_data_path, '*.rhd'));

            testCase.assertNotEmpty(rhd_files, 'No .rhd files found in the example_data directory.');

            % Create a temporary directory for the output
            temp_dir = tempname;
            mkdir(temp_dir);

            % Loop over each file
            for i = 1:length(rhd_files)
                filename = fullfile(example_data_path, rhd_files(i).name);

                % Run the manufacturer's code
                cd(temp_dir);
                manufacturer_output = read_Intan_RHD2000_file_var(filename);
                cd ..

                % Run our lab's code
                header = read_Intan_RHD2000_header(filename);

                % Amplifier channels
                if isfield(header, 'amplifier_channels') && ~isempty(header.amplifier_channels)
                    amp_channels = 1:numel(header.amplifier_channels);
                    [our_data,total_samples,total_time] = read_Intan_RHD2000_datafile(filename,header,'amp',amp_channels,0,Inf);
                    testCase.verifyEqual(our_data, manufacturer_output.amplifier_data', 'AbsTol', 1e-14, 'Amplifier data does not match');
                end

                % Time channel
                if isfield(manufacturer_output, 't_amplifier')
                    [our_time,total_samples,total_time] = read_Intan_RHD2000_datafile(filename,header,'time',1,0,Inf);
                    testCase.verifyEqual(our_time, manufacturer_output.t_amplifier', 'AbsTol', 1e-14, 'Time data does not match');
                end

                % Aux channels
                if isfield(header, 'aux_input_channels') && ~isempty(header.aux_input_channels)
                    aux_channels = 1:numel(header.aux_input_channels);
                    [our_data,total_samples,total_time] = read_Intan_RHD2000_datafile(filename,header,'aux',aux_channels,0,Inf);
                    testCase.verifyEqual(our_data, manufacturer_output.aux_input_data', 'AbsTol', 1e-14, 'Aux data does not match');
                end

                % Supply channels
                if isfield(header, 'supply_voltage_channels') && ~isempty(header.supply_voltage_channels)
                    supply_channels = 1:numel(header.supply_voltage_channels);
                    [our_data,total_samples,total_time] = read_Intan_RHD2000_datafile(filename,header,'supply',supply_channels,0,Inf);
                    testCase.verifyEqual(our_data, manufacturer_output.supply_voltage_data', 'AbsTol', 1e-14, 'Supply data does not match');
                end

                % Temp channels
                if isfield(manufacturer_output, 'temp_sensor_data')
                    [our_data,total_samples,total_time] = read_Intan_RHD2000_datafile(filename,header,'temp',1,0,Inf);
                    testCase.verifyEqual(our_data, manufacturer_output.temp_sensor_data', 'AbsTol', 1e-14, 'Temp data does not match');
                end

                % ADC channels
                if isfield(header, 'board_adc_channels') && ~isempty(header.board_adc_channels)
                    adc_channels = 1:numel(header.board_adc_channels);
                    [our_data,total_samples,total_time] = read_Intan_RHD2000_datafile(filename,header,'adc',adc_channels,0,Inf);
                    testCase.verifyEqual(our_data, manufacturer_output.board_adc_data', 'AbsTol', 1e-14, 'ADC data does not match');
                end

                % Din channels
                if isfield(header, 'board_dig_in_channels') && ~isempty(header.board_dig_in_channels)
                    din_channels = 1:numel(header.board_dig_in_channels);
                    [our_data,total_samples,total_time] = read_Intan_RHD2000_datafile(filename,header,'din',din_channels,0,Inf);
                    testCase.verifyEqual(double(our_data), double(manufacturer_output.board_dig_in_data'), 'AbsTol', 1e-14, 'Din data does not match');
                end

                % Dout channels
                if isfield(header, 'board_dig_out_channels') && ~isempty(header.board_dig_out_channels)
                    dout_channels = 1:numel(header.board_dig_out_channels);
                    [our_data,total_samples,total_time] = read_Intan_RHD2000_datafile(filename,header,'dout',dout_channels,0,Inf);
                    testCase.verifyEqual(double(our_data), double(manufacturer_output.board_dig_out_data'), 'AbsTol', 1e-14, 'Dout data does not match');
                end
            end

            % Clean up the temporary directory
            rmdir(temp_dir, 's');
        end
    end
end
