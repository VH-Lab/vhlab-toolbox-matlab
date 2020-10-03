function fid = newvhlspikewaveformfile(fid_or_filename, parameters)
% NEWVHLSPIKEWAVEFORMFILE - Create a binary file for storing spike waveforms
%
%   FID = vlt.file.custom_file_formats.newvhlspikewaveformfile(FID_OR_FILENAME, PARAMETERS)
%
%   Creates (or writes to) a binary file for storing spike waveforms.
%   Data is stored as single precision big endian binary if this function opens the file.
%
%   This function creates the header file that include the following
%   parameters:
%
%   NAME (type):                      DESCRIPTION         
%   -------------------------------------------------------------------------
%   parameters.numchannels (uint8)    : Number of channels
%   parameters.S0 (int8)              : Number of samples before spike center
%                                     :  (usually negative)
%   parameters.S1 (int8)              : Number of samples after spike center
%                                     :  (usually positive)
%   parameters.name (80xchar)         : Name (up to 80 characters)
%   parameters.ref (uint8)            : Reference number
%   parameters.comment (80xchar)      : Up to 80 characters of comment
%   parameters.samplingrate           : The sampling rate (float32)
%   (first 512 bytes are free for additional header use)
%
%  
%  The resulting FID (file identifier) can be used to write waveforms to the
%  file with the function ADDVHSPIKEWAVEFORMFILE(FID, WAVES)
%
%  NOTE: When one is done using the file, it must be closed with FCLOSE(FID).
%
 
did_this_function_open_the_fid = 0;

if ischar(fid_or_filename),
	fid = fopen(fid_or_filename,'w','b');
	if fid<0,
		error(['Could not open the file ' fid_or_filename '.']);
	end;
	did_this_function_open_the_fid = 1;
else,
	fid = fid_or_filename;
end;

 % write header
fseek(fid,0,'bof');                                        % now at 0 bytes
fwrite(fid,uint8(parameters.numchannels),'uint8');         % now at 1 byte
fwrite(fid,int8(parameters.S0),'int8');                    % now at 2 bytes
fwrite(fid,int8(parameters.S1),'int8');                    % now at 3 bytes

if length(parameters.name)>80,
	parameters.name = parameters.name(1:80);
end;
fwrite(fid,parameters.name,'char');            
fwrite(fid,zeros(1,80-length(parameters.name)),'char');    % now at 83 bytes

fwrite(fid,uint8(parameters.ref),'uint8');                 % now at 84 bytes

if length(parameters.comment)>80, 
	parameters.comment = parameters.comment(1:80);
end;

fwrite(fid,parameters.comment,'char');
fwrite(fid,zeros(1,80-length(parameters.comment)),'char'); % now at 164 bytes

fwrite(fid,single(parameters.samplingrate),'float32');      % now at 168 bytes

% about to write byte 168; we want to fill up to 512 with 0's
%  this is 512-168+1 bytes
fwrite(fid,zeros(1,512-168),'uint8');

fseek(fid,512,'bof');

if did_this_function_open_the_fid,
	fclose(fid); % close it if we opened it
end;

