function data = testfile_freadnskip;
% TESTFILE_FREADNSKIP - Demonstrates how to use FREAD with SKIP to read in arbitrary data
%
%  DATA = TESTFILE_FREADNSKIP;
%
%  Opens the file 'testfile_uint16.bin' for reading, and then reads in 2 
%  unsigned 16 bit integers, skips 5, and repeats, for 10 bouts.
%  
%  To read the code, use 'type testfile_freadnskip'
%

fid = fopen('testfile_uint16.bin');

if fid<0,
	error(['Could not open file testfile_uint16.bin']);
end;
 
 % job: read 2 uint16's, then skip 5, read 2 more, etc

datatype = 'uint16';
samples_per_bout = 2;
bouts = 10;

bytes_to_skip = 2 * 5;
number_to_read = samples_per_bout * bouts;

precision_string = [int2str(samples_per_bout) '*' datatype '=>' datatype],

data = fread(fid,number_to_read,precision_string,bytes_to_skip);

fclose(fid);
