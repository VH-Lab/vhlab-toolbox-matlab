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

fo = fopen(fo,'r','l');

 % calculate sample number

 % 3 possibilities:
 %   if X is not stored, then we can compute it
if h.X_constantinterval,
	s = point2samplelabel([x0 x1], h.X_increment, h.X_start);
	s(1) = clip(s(1),[1 h.num_samples]);
	s(2) = clip(s(2),[1 h.num_samples]);
else, % we have to go fishing for the right sample
	% this needs to be implemented much more efficiently
	s(1) = clip(-Inf,[1 h.num_samples]);
	s(2) = clip(Inf,[1 h.num_samples]);
end;

num_samples_to_read = s(2)-s(1)+1;

if nargout > 1, % only bother to read x if the calling function has asked for it; otherwise don't have to spend the time doing it
	% first, seek to beginning of X data
	fseek(fo,h.headersize,'bof');
 	% skip S0-1 samples, or s(1)-1 samples
	fseek(fo,h.sample_size*(s(1)-1),'cof');

	if h.X_stored, % we should read it from disk
		x = fread(fo, num_samples_to_read, vhsb_sampletype2matlabfwritestring(h.X_data_type, h.X_data_size), h.X_skip_bytes);
		if h.X_usescale,
			x = (x-h.X_offset)*h.X_scale;
		end;
	else, % we should create it
		x = [samplelabel2point(s(1), h.X_increment, h.X_start) : h.X_increment : samplelabel2point(s(2), h.X_increment, h.X_start) ]';
	end;
end;

 % read Y

fseek(fo,h.headersize,'bof');  % rewind back to the beginning of the data
fseek(fo,h.sample_size*(s(1)-1) + h.Y_skip_bytes,'cof'); % skip to our first sample, and then skip all the X values

y = fread(fo, prod(h.Y_dim(2:end))*num_samples_to_read, ...
	[int2str(prod(h.Y_dim(2:end))) '*' vhsb_sampletype2matlabfwritestring(h.Y_data_type, h.Y_data_size)], ...
	h.Y_skip_bytes);

if ~isempty(y),

	y = reshape(y, [h.Y_dim([2:numel(h.Y_dim)]) num_samples_to_read]);

	y = permute(y, [numel(h.Y_dim) 1:numel(h.Y_dim)-1]);

	if h.Y_usescale,
		y = (y-h.Y_offset)*h.Y_scale;
	end;

	if ~h.X_constantinterval,
		samples_valid = find(x>=x0 & x<= x1);
		x = x(samples_valid);
		y = y(samples_valid,:);
	end;
end;

