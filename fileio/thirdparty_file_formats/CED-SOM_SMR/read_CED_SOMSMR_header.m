function [header] = read_CED_SOMSMR_header(filename);
% READ_INTAN_RHD2000_HEADER - Read header information from a CED SOM or SMR file
%
% HEADER = READ_CED_SOMSMR_HEADER(FILENAME)
%
% Returns a structure HEADER with all of the information fields that
% are stored in the CED SOM/SMR file FILENAME.
%
% CED stands for Cambridge Electronic Design, which makes the Spike2 data acquisition system.
% This function reads header files for the SOM/SMR file formats.
%
% This function depends on sigTOOL by Malcolm Lidierth (http://sigtool.sourceforge.net).
%
% sigTOOL is also included in the https://github.com/VH-Lab/thirdparty bundle and
% can be installed with instructions at http://code.vhlab.org.
%
% HEADER contains two substructures:
% --------------------------------------------------------------------
% fileinfo                |  Information about the file and its version
% channelinfo             |  Information about the channels acquired in the file
%
% See also: READ_CED_SOMSMR_DATAFILE, SONFILEHEADER (documents HEADER.fileinfo),
%   SONCHANLIST (documents HEADER.channelinfo)

[pathname filename2 extension] = fileparts(filename);
if strcmpi(extension,'.smr'), % little endian
	fid=fopen(filename,'r','l');
elseif strcmp(extension,'.son'), % big endian
	fid=fopen(filename,'r','b');
else,
	error(['Unknown extension for SOM/SMR file: .' extension '.']);
end;

header.fileinfo = SONFileHeader(fid);
header.channelinfo = SONChanList(fid);

fclose(fid);

