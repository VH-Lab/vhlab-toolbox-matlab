classdef imseq < handle 
	% IMSEQ - an image class that delivers frames from recording epochs of image sequences
	%
	%

	properties (GetAccess=public, SetAccess=protected)
		currentchannel % The 'channel' of the image that is currently selected
	end

	methods
		function obj = imseq()
			% IMSEQ - create a new IMSEQ object
			%
			% IMS = IMSEQ()
			%
			% Creates an IMSEQ object. IMSEQ is an abstract class, so a specific
			% subclass is usually used instead.
			%
		end

		function sz = imsize(imseq_obj)
			% IMSIZE - return the size of images that are delivered by an IMSEQ object
			%
			% SZ = IMSIZE(IMSEQ_OBJ)
			%
			% Returns the size of the image g. SZ = [ NX NY NZ NC ]
			% where
			%   NX - number of pixels in first dimension
			%   NY - number of pixels in second dimension
			%   NZ - number of pixels in third dimension
			%   NC - number of 'channels' in each image (will comprise 4th dimension)
			%
			% IMSEQ is an abstract class so empty is always returned for SZ.

			sz = []; 
		end

		function e = numepochs(imseq_obj)
			% NUMEPOCHS - number of sequence epochs available for IMSEQ
			%
			% E = NUMEPOCHS(IMSEQ_OBJ)
			%
			% Returns the number of recording epoch sequences for an IMSEQ object.
			%
			% An epoch is a complete recording of a sequence of images.
			% 
			% In the abstract class IMSEQ, this always returns 0.
			e = 0;
		end

		function nf = numframes(imseq_obj, epoch)
			% NUMFRAMES - number of frames in a given image sequence epoch
			%
			% NF = NUMFRAMES(IMSEQ_OBJ, EPOCH)
			%
			% Returns the number of image frames NF in the image sequence IMSEQ_OBJ
			% recording epoch EPOCH.
			%
			% In the abstract class, NF is always 0.
			%
			% If EPOCH is not provided, EPOCH is taken to be 1.
			if nargin<2,
				epoch = 1;
			end
			nf = 0;
		end

		function f = frame(imseq_obj, epoch, framenumber)
			% FRAME - return a frame from an IMSEQ object
			%
			% F = FRAME(IMSEQ_OBJ, EPOCH, FRAMENUMBER)
			%
			% Return the image at frame FRAMENUMBER from epoch EPOCH from the IMSEQ object
			% IMSEQ_OBJ. FRAME will have dimensions [NX NY NZ C] where NX is the number of pixels of
			% each image in the X dimension, NY is the number of pixels of each image in the Y dimension,
			% NZ is the number of pixels of each image in the Z dimension, and C is the number of channels.
			%
			% FRAMENUMBER may also be an array of frames (e.g., [1 2 3]).
			%
			% In the abstract class, f is always empty.
			
			f = [];
		end

		function imseq_obj = setselectedchannel(imseq_obj, channel)
			% SETSELECTEDCHANNEL - set a selected channel for reading from an image sequence object
			%
			% IMSEQ_OBJ = SETSELECTEDCHANNEL(IMSEQ_OBJ, CHANNEL)
			%
			% Sets the selected channel to be returned by FRAME. Use CHANNEL=[] to return all channels.
			%
				imseq_obj.currentchannel = channel;

		end

	end
end % imseq
