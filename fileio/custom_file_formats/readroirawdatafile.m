function [waveforms, parameters] = readroirawdatafile(file_or_fid, roi_start, roi_end)
% READROIRAWDATAFILE - Read spike waveforms from binary file
%
%    ******NOT FUNCTIONAL YET**********
%
%  [ROIDATA, HEADER] = READROIRAWDATAFILE(FID_OR_FILENAME)
%    or 
%  [ROIDATA, HEADER] = READROIRAWDATAFILE(FID_OR_FILENAME,...
%     ROI_START,ROI_END)
%
%  Attempts to read spikewaves from ROI_START to ROI_END from the binary file
%  whose name is given as the first argument, or from the file descriptor (FID).
%  The header is parsed and returned in HEADER.
%
%  ROI_END can be INF to indicate that waves should be read to the end of the file.
%  The waves are numbered from 1 .. MAX, so ROI_START needs to be at least 1.
%
%  If ROI_START and ROI_END are not provided, then all waves are read.
%
%  If ROI_START is less than 1, then only the header is read.
%
%  The ROI data is returned in a structure list ROIDATA with the following fields:
%       roi:  the roi number (integer)
%     frame:  the roi frame number (integer)
%         N:  number of points in the image that overlapped the ROI (integer)
%   indexes:  the index values of these points (if they were stored) (N integers)
%      data:  the actual data values (N doubles)
% 

this_function_opened_the_file = 0;

waveforms = [];

if ischar(file_or_fid),
	fid = fopen(file_or_fid,'r','b'); % big endian
	if fid<0,
		error(['Could not open file ' file_or_fid '.']);
	end;
	this_function_opened_the_file = 1;
else, 
	fid = file_or_fid;
end;

if nargin==1,
	my_roi_start = 1;
	my_roi_end = Inf;
else,
	my_roi_start = roi_start;
	my_roi_end = roi_end;
end;

header_size = 512; % 512 bytes in the header

 % step 1 - read header
fseek(fid,0,'bof');
parameters.name = fread(fid,80,'char');             % now at 83 bytes
parameters.name = char(parameters.name(find(parameters.name)))';
parameters.ref = fread(fid,1,'uint8');              % now at 84 bytes
parameters.comment = fread(fid,80,'char');          % now at 164 bytes
parameters.comment = char(parameters.comment(find(parameters.comment)))';
parameters.precision = double(fread(fid,1,'uint8'));
parameters.indexesincluded = fread(fid,1,'uint8);  

fseek(fid,headersize,'bof');

 % step 2 - read the roi data
 
 % each data points takes 4 bytes; the number of samples is equal to the number of channels
 %       multiplied by the number of samples taken from each channel, which is S1-S0+1
samples_per_channel = parameters.S1-parameters.S0+1;
wave_size = parameters.numchannels * samples_per_channel; 

data_size = 4; % 32 bit floats

 if my_roi_start>0,
	fseek(fid,header_size+data_size*(my_roi_start-1)*wave_size,'bof'); % move to the right place in the file
	data_size_to_read = (my_roi_end-my_roi_start+1)*wave_size;
	waveforms = fread(fid,data_size_to_read,'float32');
	waves_actually_read = length(waveforms)/(parameters.numchannels*samples_per_channel);
	if abs(waves_actually_read-round(waves_actually_read))>0.0001,
		error(['Got an odd number of samples for these spikes. Corrupted file perhaps?']);
	end;
	waveforms = reshape(waveforms,samples_per_channel,parameters.numchannels,waves_actually_read);
 end;

 % step 3 - clean up if necessary

if this_function_opened_the_file,  % if we opened the file, we should close it
	fclose(fid);
end;


