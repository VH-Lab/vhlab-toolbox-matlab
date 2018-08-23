function testfile_uint16_bin
% TESTFILE_UINT16.BIN - binary file with uint16 values from 0...32000.
%
%   TESTFILE_UINT16_BIN
%
%   This is documentation for the file 'testfile_uint16.bin' that is on
%   the VHTOOLS path.  This is a binary file with uint16 values in little endian
%   format. The values start from 0 and run through 32000. It is primarily
%   useful for debugging file routines.
%
%   The code for creating the file is commented in the .m file
%   TESTFILE_UINT16_BIN.m
%
%   See also: FREAD, UINT16
%

return;

fid = fopen('testfile_uint16.bin','wb','l');
if fid<0,
	error(['Could not open file.']);
end;

A = uint16(0:32000);

fwrite(fid,A,'uint16');

fclose(fid);

