function status = copy_Intan_RHD2000_blocks(filename_in, b1, b2, filename_out)
% COPY_INTAN_RHD2000_BLOCKS - Concatenate multiple RHD blocks together
%
% STATUS = COPY_INTAN_RHD2000_BLOCKS(FILENAME_IN, B1, B2, FILENAME_OUT)
%
% Copies data blocks from B1 to B2 from the RHD 2000 file 
% FILENAME_IN and writes it to the file FILENAME_OUT.  The first block is numbered
% 1.
%
% This is useful for trimming files down to certain blocks.  Check out
% INTAN_RHD2000_BLOCKINFO to understand the relationship between data blocks and
% samples (short version: data blocks are not samples, they are regular collections
% of samples).
%
% STATUS should always return 0 if there was no error.
%
% See also: READ_INTAN_RHD2000_DATAFILE, READ_INTAN_RHD2000_HEADER, INTAN_RHD2000_BLOCKINFO
%

chunk_size = 100; % read at most 100 blocks per step, so we don't run out of memory

status = 0;
h = read_Intan_RHD2000_header(filename_in);

fid_i = fopen(filename_in,'r');
fid_o = fopen(filename_out,'w');
if fid_o<0,
	error(['Could not open the file ' filename_out ' for writing.']);
end;

[block_info,bytes_per_block,bytes_present,num_data_blocks] = Intan_RHD2000_blockinfo(filename_in, h);

header_data = fread(fid_i,h.fileinfo.headersize,'uint8');
try,
	fwrite(fid_o,header_data,'uint8');
catch,
	fclose(fid_i);
	fclose(fid_o);
	error(['Error writing header data to file ' filename_out '.']);
end;


block_starts = b1:100:b2;
if block_starts(end)==b2,
	block_starts(end) = [];
end; % trim the last one if it is not a real start

block_ends = block_starts + (chunk_size-1);
block_ends(end) = b2;

if any(block_ends>num_data_blocks),
	error(['Requested block out of the range 1..' int2str(num_data_blocks) '.']);
end;

for b = 1:length(block_starts),
	fseek(fid_i,h.fileinfo.headersize+(block_starts(b)-1)*bytes_per_block,'bof');
	numblocks = block_ends(b) - block_starts(b) + 1;
	data = fread(fid_i,numblocks*bytes_per_block','uint8');
	try,
		fwrite(fid_o,data,'uint8');
	catch,
		fclose(fid_i);
		fclose(fid_o);
		error(['Error writing to file ' filename_out '.']);
	end;
end;

fclose(fid_i);
fclose(fid_o);

