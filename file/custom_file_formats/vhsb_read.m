function [y,x] = vhsb_read(fo, x0, x1, out_of_bounds_err)
% VHSB_READ - write a VHLab series binary file
%
% [Y,X] = VHSB_READ(FO, X0, X1, OUT_OF_BOUNDS_ERR, ...)
%
% Read Y series data from a VH series binary file from closest X sample
% to value X0 to closest X sample to value X1.
%
% Inputs:
%    FO is the file description to write to; it can be a 
%         filename or an object of type FILEOBJ
%    X0 is the value of X that indicates where to start reading. Can be -Inf to 
%         indicate the beginning of the samples in the file.
%    X1 is the value of X that indicates where to stop reading. Can be Inf to indicate
%         the end of the file.
%    OUT_OF_BOUNDS_ERR indicates whether an error should be triggered if X0 or X1 are
%         more than one half-sample away from a value of X that is actually in the dataset.
%         If OUT_OF_BOUNDS_ERR is 1, then an error is triggered; otherwise, the closest sample
%         is returned but no error is given.
%         
% Outputs: 
%    X is NUMSAMPLESx1, where NUMSAMPLES is the number of samples between
%         X0 and X1.
%    Y is an NUM_SAMPLESxXxYxZx... dataset with the Y samples that
%         are associated with each value of X.
%         X(i) is the ith sample returned of X, and Y(i,:,:,...) is the ith sample returned of Y
%    

h = vhsb_readheader(fo);

 % vhsb_readheader will close the file

fo = fopen(fo,'r','ieee-le');

 % calculate sample number

 % 3 possibilities:
 %   if X is not stored, then we can compute it
if h.X_constantinterval,
	s = point2samplelabel([x0 x1], h.X_increment, h.X_start);
	s(1) = clip(s(1),[1 h.num_samples]);
else, % we have to go fishing for the right sample
	error(['The condition where X is not a series with a constant interval is not yet implemented.']);
end;

X_skip_bytes = prod(h.Y_dim) * h.Y_data_size;
Y_skip_bytes = h.X_data_size * (h.X_stored==1);
sample_size = X_skip_bytes + Y_skip_bytes;

num_samples_to_read = s(2)-s(1)+1;

if nargout > 1, % only bother to read x if the calling function has asked for it; otherwise don't have to spend the time doing it
	% first, seek to beginning of X data
	fseek(fo,h.headersize,'bof');
 	% skip S0-1 samples, or s(1)-1 samples
	fseek(fo,sample_size*(s(1)-1),'cof');

	if X_stored, % we should read it from disk
		x = fread(fo, num_samples_to_read, vhsb_sampletype2matlabfwritestring(X_data_type, X_data_size), X_skip_bytes);
		if X_usescale,
			x = (x-X_offset)*X_scale;
		end;
	else, % we should create it
		x = [samplelabel2point(s(1), h.X_increment, h.X_start) : h.X_increment : samplelabel2point(s(2), h.X_increment, h.X_start) ]';
	end;
end;

 % read Y

fseek(fo,h.headersize,'bof');  % rewind back to the beginning of the data
fseek(fo,sample_size*(s(1)-1) + Y_spike_bytes,'cof'); % skip to our first sample, and then skip all the X values

y = fread(fo, prod(h.Ydim)*num_samples_to_read, [int2str(prod(h.Ydim)) '*' vhsb_sampletype2matlabfwritestring(Y_data_type, Y_data_size)], Y_skip_bytes);

y = reshape(y, h.Ydim([2:numel(h.Y_dim) 1]));

y = permute(y, [numel(h.Y_dim) 1:numel(h.Y_dim)-1]);

if Y_usescale,
	y = (y-Y_offset)*Y_scale;
end;

