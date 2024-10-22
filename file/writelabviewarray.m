function writelabviewarray(fname, A, datasize, machineformat)

% WRITELABVIEWARRAY - Write a LabView array into Matlab
%
%  WRITELABVIEWARRAY(FNAME, A, DATASIZE, MACHINEFORMAT)
%
%  Write values in matrix A to a LabView array file.
%
%  DATASIZE is the size of the data; the argument should be 
%  a size suitable for using in the function FWRITE (e.g.,
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

if nargin<4,  mf = 'b'; else, mf = machineformat; end;

fid = fopen(fname,'w',mf);

sz = size(A);

A = A';

if fid>0,
	count = fwrite(fid,[sz(2) sz(1)],'int');
	count = fwrite(fid,A(:),datasize); % write in all the data
	fclose(fid);
else,
	error(['Could not open file ' fname ' for writing.']);
end;


