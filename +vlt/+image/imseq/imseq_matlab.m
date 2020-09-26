classdef imseq_matlab < imseq
% IMSEQ_MATLAB - turn image files that can be read by Matlab's IMREAD into an IMSEQ object
%
% See the reference page.
%
% Examples:
%   ims = imseq_matlab('ngc6543a.jpg')
%   ims.imsize
%   ims.numframes
%   d = ims.frame(1,1);
%   figure; 
%   image(d);
%    
%   % suppose you have a multi-frame TIFF in myfile.tif
%   ims = imseq_matlab('myfile.tif');
%   ims.imsize, % show size
%   ims.numframes, % show frames
%   data = ims.frame(1,1:3); % read frames 1, 2, 3
%   

	properties (GetAccess=public, SetAccess=protected)
		filename   % The (full path) filename to be accessed
		info       % The file information
	end
	properties (GetAccess=protected, SetAccess=protected)
		updated    % Are our variables updated?
		nx         % Number of pixels in the X dimension
		ny         % Number of pixels in the Y dimension
		nz         % Number of pixels in the Z dimension; always 1 for this object class
		nc         % Number of channels
		nf         % Number of frames
	end

	methods
		function imseq_matlab_obj = imseq_matlab(filename)
			% IMSEQ_MATLAB - creator an image sequence object from a Matlab-readable image file
			%
			% IMSEQ_MATLAB_OBJ = IMSEQ_MATLAB(FILENAME)
			%
			% Create an image sequence object using a filename that can be read by Matlab's IMREAD
			% function. FILENAME should be the full path to the image file name. The file should have an
			% extension that is interpretable to IMREAD.
			%
			% See also: IMREAD

				imseq_matlab_obj.info = [];
				imseq_matlab_obj.updated = false;
				imseq_matlab_obj.setfilename(filename);
		end

		function imseq_matlab_obj = setfilename(imseq_matlab_obj, filename)
			% SETFILENAME - Set or reset the filename of an IMSEQ_MATLAB_OBJ
			%
			% IMSEQ_MATLAB_OBJ = SETFILENAME(IMSEQ_MATLAB_OBJ, FILENAME)
			%
			% Sets the filename.	
			%
				imseq_matlab_obj.updated = false;
				imseq_matlab_obj.filename = filename;
		end

		function imseq_matlab_obj = update(imseq_matlab_obj)
			% UPDATE - re-read parameters of the image file with IMFINFO
			%
			% IMSEQ_MATLAB_OBJ = UPDATE(IMSEQ_MATLAB_OBJ)
			%
			% Updates the internal variables of the IMSEQ_MATLAB_OBJ.
			% Calls IMFINFO.
			%
				imseq_matlab_obj.info = imfinfo(imseq_matlab_obj.filename);
				imseq_matlab_obj.nf = numel(imseq_matlab_obj.info); 
				imseq_matlab_obj.nx = imseq_matlab_obj.info(1).Width;
				imseq_matlab_obj.ny = imseq_matlab_obj.info(1).Height;
				imseq_matlab_obj.nz = 1;
				if isfield(imseq_matlab_obj.info(1),'NumberOfSamples'),
					imseq_matlab_obj.nc = imseq_matlab_obj.info(1).NumberOfSamples;
				else,
					imseq_matlab_obj.nc = 1;
				end;
			
				imseq_matlab_obj.updated = true;
		end
	
		function sz = imsize(imseq_matlab_obj)
			% IMSIZE - return the size of images that are delivered by an IMSEQ_MATLAB object
			%
			% SZ = IMSIZE(IMSEQ_MATLAB_OBJ)
			%
			% Returns the size of the image g. SZ = [ NX NY NZ NC ]
			% where
			%   NX - number of pixels in first dimension
			%   NY - number of pixels in second dimension
			%   NZ - number of pixels in third dimension (will always be 1)
			%   NC - number of 'channels' in each image (will comprise 3rd dimension)
			%
				if ~imseq_matlab_obj.updated,
					imseq_matlab_obj.update();
				end

				sz = [ imseq_matlab_obj.nx ...
					imseq_matlab_obj.ny ...
					imseq_matlab_obj.nz ...
					imseq_matlab_obj.nc ];
		end

		function e = numepochs(imseq_matlab_obj)
			% NUMEPOCHS - number of sequence epochs available for IMSEQ_MATLAB object
			%
			% E = NUMEPOCHS(IMSEQ_MATLAB_OBJ)
			%
			% Returns the number of recording epoch sequences for an IMSEQ_MATLAB object.
			%
			% An epoch is a complete recording of a sequence of images.
			% 
			% In the filename-based class IMSEQ_MATLAB, this always returns 1 (a single epoch).
				e = 1;
		end

		function nf = numframes(imseq_matlab_obj, epoch)
			% NUMFRAMES - number of frames in a given image sequence epoch
			%
			% NF = NUMFRAMES(IMSEQ_MATLAB_OBJ, EPOCH)
			%
			% Returns the number of image frames NF in the image sequence IMSEQ_MATLAB_OBJ
			% recording epoch EPOCH.  In this class, EPOCH is always taken to be 1. 

				if nargin<2,
					epoch = 1;
				end

				if ~imseq_matlab_obj.updated,
					imseq_matlab_obj.update();
				end

				nf = imseq_matlab_obj.nf;
		end

		function f = frame(imseq_matlab_obj, epoch, framenumber)
			% FRAME - return a frame from an IMSEQ object
			%
			% F = FRAME(IMSEQ_MATLAB_OBJ, EPOCH, FRAMENUMBER)
			%
			% Return the image at frame FRAMENUMBER from epoch EPOCH from the IMSEQ object
			% IMSEQ_MATLAB_OBJ. FRAME will have dimensions [NX NY NZ C] where NX is the number of pixels of
			% each image in the X dimension, NY is the number of pixels of each image in the Y dimension,
			% NZ is the number of pixels of each image in the Z dimension, and C is the number of channels.
			%
			% FRAMENUMBER may also be an array of frames (e.g., [1 2 3]). Frames will be concatenated on the
			% 3rd dimension if the channel dimension is 1; otherwise frames will be concatenated on the 4th dimension.
			%
			
				if ~imseq_matlab_obj.updated,
					imseq_matlab_obj.update();
				end

				if epoch~=1,
					error(['Only know how to deal with 1 epoch right now.']);
				end;

				f = [];

				for floop = framenumber,

					if eqlen(framenumber,1),
						f_here = imread(imseq_matlab_obj.filename);
					else,
						f_here = imread(imseq_matlab_obj.filename,'Info',imseq_matlab_obj.info,'Index',floop);
					end

					if ~isempty(imseq_matlab_obj.currentchannel),
						f_here = squeeze(f(:,:,currentchannel));
					end

					sz = size(f_here);
					f = cat(numel(sz)+1,f,f_here);
				end
		end

		function imseq_matlab_obj = setselectedchannel(imseq_matlab_obj, channel)
			% SETSELECTEDCHANNEL - set a selected channel for reading from an image sequence object
			%
			% IMSEQ_MATLAB_OBJ = SETSELECTEDCHANNEL(IMSEQ_MATLAB_OBJ, CHANNEL)
			%
			% Sets the selected channel to be returned by FRAME. Use CHANNEL=[] to return all channels.
			%
				imseq_matlab_obj.currentchannel = channel;
		end
	end
end % imseq_matlab


