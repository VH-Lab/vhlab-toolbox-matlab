function addvhlspikewaveformfile(fid_or_filename, waveforms)
%  ADDVHLSPIKEWAVEFORMFILE - Add waveforms to a VHL spike waveform file
%
%    vlt.file.custom_file_formats.addvhlspikewaveformfile(FID_OR_FILENAME, WAVEFORMS)
%
%  Add waveform data to a VHL spike waveform file.
%
%  If an open FID (file identifier) is passed, then the data is 
%  written to that file.  Note that in this case no checking is
%  performed to make sure that waveform sizes correspond to what
%  is contained in the file's header, so make sure the waveform
%  sizes are accurate.
%
%  If instead a FILENAME is passed, then the function attempts to
%  open FILENAME and checks to make sure that WAVEFORMS matches
%  the header file parameters.
%
%  WAVEFORMS should be a matrix of size:
%       NUM_SAMPLES x NUM_CHANNELS X NUM_WAVEFORMS. 
%
%  See also:  vlt.file.custom_file_formats.newvhlspikewaveformfile
%  

did_this_function_open_the_fid = 0;

if ischar(fid_or_filename),
	fid = fopen(fid_or_filename,'a','b');
	if fid<0,
		error(['Could not open the file ' fid_or_filename '.']);
	end;
	did_this_function_open_the_fid = 1;
else,
	fid = fid_or_filename;
end;

[num_samples,numchannels,num_waveforms] = size(waveforms);

  % we need the spikes waveforms to be represented in the columns of the matrix
  % this means we need to push all of the channels into 1 dimension
waveforms = single(reshape(waveforms,num_samples*numchannels,num_waveforms)); 

fseek(fid,0,'eof');  % go to the end

fwrite(fid,single(waveforms),'float32');

if (did_this_function_open_the_fid), % leave the file closed if we found it closed
	fclose(fid);
end;

