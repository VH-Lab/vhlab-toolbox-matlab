function [blockinfo, bytes_per_block, bytes_present, num_data_blocks] = Intan_RHD2000_blockinfo(filename, header)
% INTAN_RHD2000_BLOCKINFO - Block information for an Intan RHD2000 file
%
%  [BLOCK_INFO, BYTES_PER_BLOCK, BYTES_PRESENT, NUMDATABLOCKS]  = ...
%         INTAN_RHD2000_BLOCKINFO(FILENAME [, HEADER])
%
% Computes the parameters of each data block of an Intan_RHD_2000 file.
%
% The Intan 2000 RHD file type is organized into a header, and then data blocks of
% samples of the various channel types that the Intan demo board can sample.
% This file, along with the HEADER, computes the structure of these data blocks that are
% needed to interpret each data block.
%
% FILENAME should be the name of an RHD2000 file (normally with extension
% '.rhd').  HEADER should be the header information structure that is returned
% by READ_INTAN_RHD2000_HEADER; if it is left blank, it will be read from the
% file.
% 
% BLOCK_INFO is a structure describing the parameters of each block.
% BYTES_PER_BLOCK is the number of bytes per data block
% BYTES_PRESENT is the number of non-header bytes in the file.
% NUMDATABLOCKS is the number of data blocks in the file.
%
% See also: READ_INTAN_RHD2000_HEADER, READ_INTAN_RHD2000_DATAFILE, CAT_INTAN_RHD2000_FILES

if nargin<2,
	header = read_Intan_RHD2000_header(filename);
elseif isempty(header),
	header = read_Intan_RHD2000_header(filename);
end;

num_amplifier_channels = length(header.amplifier_channels);
num_aux_input_channels = length(header.aux_input_channels);
num_supply_voltage_channels = length(header.supply_voltage_channels);
num_board_adc_channels = length(header.board_adc_channels);
num_board_dig_in_channels = length(header.board_dig_in_channels);
num_board_dig_out_channels = length(header.board_dig_out_channels);
num_temp_sensor_channels = header.num_temp_sensor_channels;

% Determine how many samples the data file contains.

% BLOCK PARAMETERS - these change depending upon which channels were recorded
   % initially set all block_offsets to 0, then calculate them again later

blockinfo    = struct('type','timestamp','block_offset',0,'bytes',60*4,'bytes_per_sample',4,'samples_per_block',60,'numchannels',1,...
        'interleaved',0,'precision',['60*uint32=>uint32'],'scale',1.0/header.frequency_parameters.amplifier_sample_rate,'shift',0);
if ((header.fileinfo.data_file_main_version_number == 1 && header.fileinfo.data_file_secondary_version_number >= 2) ...
        || (header.fileinfo.data_file_main_version_number > 1))
        blockinfo(1).precision = ['60*int32=>int32'];
end;
blockinfo(2) = struct('type','amp','block_offset',0,'bytes',60*2*num_amplifier_channels,...
		'bytes_per_sample',2,'samples_per_block',60,'numchannels',num_amplifier_channels,...
	        'interleaved',1,'precision','*uint16=>uint16','scale',0.195,'shift',32768);
blockinfo(3) = struct('type','aux','block_offset',0,'bytes',15*2*num_aux_input_channels,...
		'bytes_per_sample',2,'samples_per_block',15,'numchannels',num_aux_input_channels,...
	        'interleaved',1,'precision','*uint16=>uint16','scale',37.4e-6,'shift',0);
blockinfo(4) = struct('type','supply','block_offset',0,'bytes',1*2*num_supply_voltage_channels,...
		'bytes_per_sample',2,'samples_per_block',1,'numchannels',num_supply_voltage_channels,...
	        'interleaved',1,'precision','*uint16=>uint16','scale',74.8e-6,'shift',0);
blockinfo(5) = struct('type','temp','block_offset',0,'bytes',1*2*(num_temp_sensor_channels>0),...
		'bytes_per_sample',2,'samples_per_block',1,'numchannels',num_temp_sensor_channels,...
	        'interleaved',1,'precision','*int16=>int16','scale',1/100,'shift',0);
blockinfo(6) = struct('type','board_adc','block_offset',0,'bytes',60*2*num_board_adc_channels,...
		'bytes_per_sample',2,'samples_per_block',60,'numchannels',num_board_adc_channels,...
	        'interleaved',1,'precision','*uint16=>uint16','scale',152.59e-6,'shift',32768);

if header.fileinfo.eval_board_mode~=1,
        blockinfo(6).scale=50.354e-6;
        blockinfo(6).shift = 0;
end;

blockinfo(7) = struct('type','din','block_offset',0,'bytes',60*2*(num_board_dig_in_channels>0),...
		'bytes_per_sample',2,'samples_per_block',60,'numchannels',uint16(num_board_dig_in_channels>0),...
	        'interleaved',0,'precision',['60*uint16=>uint16'],'scale',1,'shift',0);
blockinfo(8) = struct('type','dout','block_offset',0,'bytes',60*2*(num_board_dig_out_channels>0),...
		'bytes_per_sample',2,'samples_per_block',60,'numchannels',uint16(num_board_dig_out_channels>0),...
	        'interleaved',0,'precision',['60*uint16=>uint16'],'scale',1,'shift',0);

block_offset = 0;
for i=1:length(blockinfo),
        blockinfo(i).block_offset = block_offset;
        block_offset = block_offset + blockinfo(i).bytes;
end;
bytes_per_block = block_offset;

% How many data blocks are in this file?
bytes_present = header.fileinfo.filesize - header.fileinfo.headersize;
num_data_blocks = bytes_present / bytes_per_block;

