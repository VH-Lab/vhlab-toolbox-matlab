function [T,D,tot_sam,tot_time] = readvhlvdatafile(myfilename, headerstruct, channelnums, t0, t1)
% READVHLVDATAFILE - Read LabView data from the VH Lab format
%
%  [T,D,TOTAL_SAMPLES,TOTAL_TIME] = READVHLVDATAFILE(FILENAME, HEADERSTRUCT, CHANNELNUMS, T0, T1)
%
%  This function reads data from the multichannel VHLab LabView binary
%  data file format. FILENAME is the name of the file to open, 
%  HEADERSTRUCT is the header structure as returned from 
%  READVHLVHEADERFILE, CHANNELNUMS are the channel numbers to read, where
%  0 is the first channel in the list that was acquired in LabView, 1 is
%  the second channel, etc.  See the HEADERSTRUCT to learn the mapping between
%  the channel list and the inputs of the device (such as ai0, ai1, ... ports
%  on the National Instruments card). If HEADERSTRUCT is empty, then a file with
%  the same name but with extension .vlh is opened as the header file.
%  T0 is the time relative to the beginning of the recording to start reading
%  from, and T1 is the time relative to the beginning of the recording to read to.
%
%  TOTAL_SAMPLES is the estimated number of total samples in the file.
%  TOTAL_TIME is the estimated time length of the file.
%
%  The data can be stored in 2 different binary formats. If the 'Multiplexed'
%  field of HEADERSTRUCT is not provided or is 0, then the data are assumed to
%  to be stored in binary chunks with headerstruct.SamplesPerChunk samples of channel 1
%  stored, followed by headerstruct.SamplesPerChunk samples of channel 2 stored, etc.
%  If headerstruct.Multiplexed is 1, then the samples are perfectly multiplexed so that
%  sample 1 is the first sample of channel 1, sample 2 is the first sample of channel 2, 
%  and so on.
%
%  Example:
%     myheader = readvhlvheaderfile('vhlvanaloginput.vlh');
%
%     % read from 0 to 5 seconds on the first channel acquired
%     [T,D] = readvhlvdatafile('vhlvanaloginput.vld',myheader,1,0,5);
%     figure;
%     plot(T,D);
%     xlabel('Time(s)');
%     ylabel('Volts');  % or mV or microV, whatever the units were
%     

multiplexed = 0;

if isempty(headerstruct),
	[mypath,myname,myext] = fileparts(myfilename);
	headerstruct=readvhlvheaderfile(fullfile(mypath,[myname '.vlh']));
end;

if any(channelnums<1) | any(channelnums>headerstruct.NumChans),
	error(['Requested channel numbers must be between 1 and NumChans, which for this header file is ' int2str(headerstruct.NumChans) '.']);
end;

if t0<0, error(['t0 cannot be negative.']); end;
if t1<0, error(['t1 cannot be negative.']); end;

s0 = round(1+t0*headerstruct.SamplingRate); % samples run from 1...N, sample 1 occurs at t==0
s1 = round(1+t1*headerstruct.SamplingRate);

chunkstart = 1+floor(s0/headerstruct.SamplesPerChunk);
samplesinstartingchunk = mod(s0, headerstruct.SamplesPerChunk);
if samplesinstartingchunk==0, % if the mod is exactly 0, we actually want the last sample of the previous chunk
	chunkstart = chunkstart -1;
	samplesinstartingchunk = headerstruct.SamplesPerChunk;
end;

chunkstop = 1+floor(s1/headerstruct.SamplesPerChunk);
samplesinstoppingchunk = mod(s1, headerstruct.SamplesPerChunk);
if samplesinstoppingchunk==0, % if the mod is exactly 0, we actually want the last sample of the previous chunk
	chunkstop = chunkstop - 1;
	samplesinstoppingchunk = headerstruct.SamplesPerChunk;
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
		case {'int16','int32'}
			output_precision = 'single';
	end;
end;

if isfield(headerstruct,'Multiplexed'),
	multiplexed = headerstruct.Multiplexed;
end;

d = dir(myfilename);
tot_sam = d.bytes/(headerstruct.NumChans*unit_size);
tot_time = tot_sam / headerstruct.SamplingRate;

T = []; D = [];

% open the file, skip through to the chunk where we will start reading

fid = fopen(myfilename,'r');

if fid<0, error(['Could not open file ' myfilename '.']); end;

binary_samples_per_chunk = headerstruct.SamplesPerChunk * headerstruct.NumChans * unit_size; % 

i = chunkstart;

while i<=chunkstop,

	% read the chunk; we could save some memory by only reading the samples we need, but we assume the chunks fit in memory easily;
	% that's the point of the chunk method

	myData = [];
	myT =  [ ((i-1)*headerstruct.SamplesPerChunk):(i*headerstruct.SamplesPerChunk-1) ] / headerstruct.SamplingRate;
	if i==chunkstart,
		sample_start = samplesinstartingchunk;
	else,
		sample_start = 1; % we want to start at the beginning of this chunk
	end;

	if i==chunkstop,
		sample_stop = samplesinstoppingchunk;
	else,
		sample_stop = headerstruct.SamplesPerChunk; % we want the whole chunk here
	end;

	for c=1:length(channelnums),
		fseek(fid,(i-1)*binary_samples_per_chunk,'bof'); % skip to our chunk
		% read 1 channels worth of data
		if ~multiplexed,
			% this could be shortned to only read in the samples that are needed; instead of reading SamplesPerChunk data, one could seek to the first sample
                        %  needed and only read up to the last sample needed
			fseek(fid,(channelnums(c)-1)*headerstruct.SamplesPerChunk*unit_size,'cof');  % bytes per sample ; move to where this channel is stored

			%fseek(fid,(sample_start-1)*unit_size,'cof'); % move to the first sample to be read
			%myData_ = fread(fid,(sample_stop-sample_start+1),precision,0*(headerstruct.NumChans-1),'ieee-be');   % this reads in a whole chunk from channel c
			% then you'd just skip the trimming step below

			myData_ = fread(fid,headerstruct.SamplesPerChunk,precision,0*(headerstruct.NumChans-1),'ieee-be');   % this reads in a whole chunk from channel c
		else,
			% this could be shortned to only read in the samples that are needed
			% I think this would work
			%fseek(fid,(sample_start-1)*unit_size*headerstruct.NumChans + (channelnums(c)-1)*unit_size,'cof');
			%myData_ = fread(fid,(sample_stop-sample_start+1),precision,unit_size*(headerstruct.NumChans-1),'ieee-be');  % this reads in a whole chunk from channel c
			% you'd also need to skip the trim below


			fseek(fid,(channelnums(c)-1)*unit_size,'cof');
			
			myData_ = fread(fid,headerstruct.SamplesPerChunk,precision,unit_size*(headerstruct.NumChans-1),'ieee-be');  % this reads in a whole chunk from channel c
				
		end;
		if isfield(headerstruct,'Scale'),
			myData_ = eval([output_precision '(myData_) * headerstruct.Scale/maxint;']);
		end;
		if prod(size(myData_))==headerstruct.SamplesPerChunk*1,
			% if we got a full read
			myData_ = reshape(myData_,headerstruct.SamplesPerChunk,1);
       			myData = [myData myData_];
		else,
			if feof(fid), % if we hit the end of file
				chunkstop = -1; % define this to be the stopping point
			else, error(['I have no idea how we ended up here; we had a read error but no end of file reached.']);
			end;
		end;
	end;

	if chunkstop~=-1,  % as long as we didn't hit the edge, we are good; discard if we did hit the edge
		% now trim to just keep the data we want here

			% if reading only the data needed, then this myData trim line is not needed
		myData = myData(sample_start:sample_stop,:);

		myT = myT(sample_start:sample_stop);
	
		T = cat(2,T,myT); D = cat(1,D,myData);
		i = i + 1;
	end;

end;

fclose(fid);

