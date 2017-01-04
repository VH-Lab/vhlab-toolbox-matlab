function convertvhlvdatafile2integer(myfilename, headerstruct, outputfilename, scale, newoutputprecision)
% CONVERTVHLVDATAFILE2INTEGER - Convert a VH LabView file to binary integer format
%
%  CONVERTVHLVDATAFILE2INTEGER(OLDFILENAME, HEADERSTRUCT, OUTPUTFILENAME, SCALE, PRECISION)
%
%  This function reads data from the multichannel VHLab LabView binary
%  data file format and writes a new file with precision PRECISION,
%  where PRECISION is 'int32' or 'int16'.
%  HEADERSTRUCT is the header structure as returned from 
%  READVHLVHEADERFILE (or use empty, [], to open a file of the same name
%  as OLDFILENAME with extension 'vlh').
%  
%  OUTPUTFILENAME is the name of the new file to be written; a new header
%  file with the same name as OUTPUTFILENAME and extension
%  'vlh' will be created. The data are divided by SCALE before writing.
%
%  The output file will be saved with channel multiplexing.
%
%  Example:
%       convertvhlvdatafile2integer('vhlvanaloginput.vld',[],'vhlvanaloginput_int.vld',10,'int16');
%     

multiplexed = 0;

if isempty(headerstruct),
        [mypath,myname,myext] = fileparts(myfilename);
        headerstruct=readvhlvheaderfile(fullfile(mypath,[myname '.vlh']));
end;

if isfield(headerstruct,'precision'),
	precision = headerstruct.precision;
else,
	precision = 'double';
end;

output_precision = precision;

switch precision,
	case 'double',
		unit_size = 8;
		maxint = 1;
	case 'single',
		unit_size = 4;
		maxint = 1;
	case 'int32',
		unit_size = 4;
		maxint = 2^31-1;
	case 'int16',
		unit_size = 2;
		maxint = 2^15 - 1;
end;

if isfield(headerstruct,'Scale'),
	switch output_precision,
		case {'int16','int32'},
			output_precision = 'single';
	end;
end;

if isfield(headerstruct,'Multiplexed'),
	multiplexed = headerstruct.Multiplexed;
end;

fid = fopen(myfilename,'r');
if fid<0, error(['Could not open file ' myfilename '.']); end;

total_samples_per_chunk = headerstruct.SamplesPerChunk * headerstruct.NumChans; % 

 % now open the output file for writing


[mypath,myname,myext] = fileparts(outputfilename);

myoutputfile = fullfile(mypath,[myname '.vld']);

newheaderstruct = headerstruct;
newheaderstruct.Scale = scale;
newheaderstruct.precision = newoutputprecision;
newheaderstruct.Multiplexed = 1;
writevhlvheaderfile(newheaderstruct,fullfile(mypath,[myname '.vlh']));

switch newheaderstruct.precision,
	case 'int16',
		output_maxint = 2^15 - 1;
	case 'int32',
		output_maxint = 2^31 - 1;
end;

fid_out = fopen(myoutputfile, 'w','ieee-be');

if fid_out<1,
	fclose(fid);
	error(['Could not open file ' myoutputfile ' for writing.']);
end;

i = 0;

while ~feof(fid), % as long as there is data left to read, we will convert
	myData_ = fread(fid,total_samples_per_chunk,precision,'ieee-be');
	if numel(myData_)==total_samples_per_chunk,
		if newheaderstruct.Multiplexed & ~multiplexed,  % if input is not perfectly multiplexed
			myData_ = reshape(myData_,headerstruct.SamplesPerChunk,headerstruct.NumChans)';
			myData_ = reshape(myData_,headerstruct.SamplesPerChunk,headerstruct.NumChans);
		end;
	
		if isfield(headerstruct,'Scale'),
			myData_ = eval([output_precision '(myData_) * headerstruct.Scale/maxint;']);
		end;

		%convert to new precision, probably int16
		myData_ = eval([newheaderstruct.precision '(myData_*output_maxint/scale);']);

		count = fwrite(fid_out,myData_,newheaderstruct.precision,0,'ieee-be');

		if count~=numel(myData_),
			error(['Incomplete write of binary data to ' myoutputfile '.']);
		end;
	else,
		% ignoring incomplete chunk, no need for warning
	end;
end;

fclose(fid);
fclose(fid_out);

