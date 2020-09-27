function writevhlvheaderfile(headerstruct, filename)
% WRITEVHLVHEADERFILE - Write a VHLV header file
%
%   WRITEVHLVHEADERFILE(HEADERSTRUCT, FILENAME)
%
%  Writes a header file for the VH LabView Multichannel
%  binary file format. Should have an extension of '.vlh'.
%
%  It expects HEADERSTRUCT to be the name of a Matlab structure.
%  The expected fields are 'ChannelString', which indicates the
%  channel names that were acquired in the LabView system, 'NumChans', the number
%  of channels that were acquired, 'SamplingRate', the sampling rate of each
%  channel in Hz, and 'SamplesPerChunk', which indicates how many samples were
%  written to disk in each burst of recording, 'precision', which indicates the
%  binary data type ('double','single','int16', for example), and 'Scale', which
%  indicates any scale factor that should be applied to the data upon reading. 
 
fn = fieldnames(headerstruct);

fid = fopen(filename,'wt');

if fid<0,
	error(['Could not open ' filename ' for writing.']);
end;

for i=1:length(fn),
	data = getfield(headerstruct, fn{i});
	if ischar(data),
		fprintf(fid,[fn{i} ':\t' data '\n']);
	else,
		fprintf(fid,[fn{i} ':\t' mat2str(data) '\n']);
	end;
end;

fclose(fid);
