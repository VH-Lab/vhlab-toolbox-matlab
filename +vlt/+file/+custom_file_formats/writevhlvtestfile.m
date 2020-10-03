function writevhlvtestfile(filename, num_channels)
% WRITEVLHVTESTFILE - Write a test data file in VHLV format.
%  
% vlt.file.custom_file_formats.writevhlvtestfile(FILENAME)
%
% Write a test file that is 10 channels long, in Multiplex format.
% Channel 1 has values 1:1.2 in steps of 0.001; channel 2 is the same
% except that it runs from 2:2.2; channel 3 runs from 3:3.2, and so on.
%
% vlt.file.custom_file_formats.writevhlvtestfile(FILENAME, NUM_CHANNELS)
%
%  If NUM_CHANNELS is given, then the number of channels written
%  is NUM_CHANNELS.
%         
   
if nargin==1, 
	num_channels = 10;
end;

newheaderstruct.ChannelString = ['channels 1:' int2str(num_channels)];
newheaderstruct.NumChans = num_channels;
newheaderstruct.SamplingRate = 100;
newheaderstruct.SamplesPerChunk = 100;
newheaderstruct.Scale = (num_channels+1);
newheaderstruct.precision = 'int16';
newheaderstruct.Multiplexed = 1;


switch newheaderstruct.precision,
        case 'int16',
                output_maxint = 2^15 - 1;
        case 'int32',
                output_maxint = 2^31 - 1;
end;

[mypath,myname,myext] = fileparts(filename);
myoutputfile = fullfile(mypath,[myname '.vld']);

vlt.file.custom_file_formats.writevhlvheaderfile(newheaderstruct,fullfile(mypath,[myname '.vlh']));

% write 2 chunks
chunk_total = 2;

fid_out = fopen(myoutputfile,'w','ieee-be');

if fid_out<1,
	error(['Could not open file ' myoutputfile ' for writing.']);
end;

for c=1:chunk_total,
	D=repmat((1:num_channels)',1,100)+(c-1)*(0.1)+...
			repmat(0:0.001:0.099,num_channels,1);
	Dout = int16(D*output_maxint/newheaderstruct.Scale);
	fwrite(fid_out,Dout,'int16',0,'ieee-be');
end;

fclose(fid_out);

