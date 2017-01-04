function [waveforms, parameters] = readvhlspikewaveformfile(file_or_fid, wave_start, wave_end)
% READVHLSPIKEWAVEFORMFILE - Read spike waveforms from binary file
%
%  [WAVEFORMS, HEADER] = READVHLSPIKEWAVEFORMFILE(FID_OR_FILENAME)
%    or 
%  [WAVEFORMS, HEADER] = READVHLSPIKEWAVEFORMFILE(FID_OR_FILENAME,...
%     WAVE_START,WAVE_END)
%
%  Attempts to read spikewaves from WAVE_START to WAVE_END from the binary file
%  whose name is given as the first argument, or from the file descriptor (FID).
%  The header is parsed and returned in HEADER.
%
%  WAVE_END can be INF to indicate that waves should be read to the end of the file.
%  The waves are numbered from 1 .. MAX, so WAVE_START needs to be at least 1.
%
%  If WAVE_START and WAVE_END are not provided, then all waves are read.
%
%  If WAVE_START is less than 1, then only the header is read.
%
%  The waveforms are output in the form NUM_SAMPLESxNUM_CHANNELSxNUM_WAVEFORMS
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
	my_wave_start = 1;
	my_wave_end = Inf;
else,
	my_wave_start = wave_start;
	my_wave_end = wave_end;
end;

header_size = 512; % 512 bytes in the header

 % step 1 - read header
fseek(fid,0,'bof');
parameters.numchannels = fread(fid,1,'uint8');      % now at 1 byte
parameters.S0 = fread(fid,1,'int8');                % now at 2 bytes
parameters.S1 = fread(fid,1,'int8');                % now at 3 bytes
parameters.name = fread(fid,80,'char');             % now at 83 bytes
parameters.name = char(parameters.name(find(parameters.name)))';
parameters.ref = fread(fid,1,'uint8');              % now at 84 bytes
parameters.comment = fread(fid,80,'char');          % now at 164 bytes
parameters.comment = char(parameters.comment(find(parameters.comment)))';
parameters.samplingrate= double(fread(fid,1,'float32'));

 % step 2 - read the waveforms
 
 % each data points takes 4 bytes; the number of samples is equal to the number of channels
 %       multiplied by the number of samples taken from each channel, which is S1-S0+1
samples_per_channel = parameters.S1-parameters.S0+1;
wave_size = parameters.numchannels * samples_per_channel; 

data_size = 4; % 32 bit floats

 if my_wave_start>0,
	fseek(fid,header_size+data_size*(my_wave_start-1)*wave_size,'bof'); % move to the right place in the file
	data_size_to_read = (my_wave_end-my_wave_start+1)*wave_size;
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


