function A = readlabviewarray(fname, datasize, machineformat)

% vlt.file.readlabviewarray - Reads a LabView array into Matlab
%
%  A = vlt.file.readlabviewarray(FNAME, DATASIZE, MACHINEFORMAT)
%
%  Reads in values from a LabView array file.
%
%  DATASIZE is the size of the data; the argument should be 
%  a size suitable for using in the function FREAD (e.g.,
%  'double', 'int', etc)
%
%  MACHINEFORMAT is the one of the following strings, as 
%  described in the FOPEN help (default is 'b'):
%    'l'     or 'l' - IEEE floating point with little-endian
%                           byte ordering
%    'ieee-be'     or 'b' - IEEE floating point with big-endian
%                           byte ordering
%    'l.l64' or 'a' - IEEE floating point with little-endian
%                           byte ordering and 64 bit long data type
%    'ieee-be.l64' or 's' - IEEE floating point with big-endian byte
%                           ordering and 64 bit long data type.
%  

if nargin<3,  mf = 'b'; else, mf = machineformat; end;

fid = fopen(fname, 'r',mf);

if fid>0,
	dims = fread(fid,2,'int');
	A = fread(fid,Inf,datasize); % read in all the data
	A = reshape(A,dims(2),dims(1))'; % and reshape it to correspond to the LabView matrix ordering
	fclose(fid);
else,
	error(['Could not open file ' fname ' for reading.']);
end;

