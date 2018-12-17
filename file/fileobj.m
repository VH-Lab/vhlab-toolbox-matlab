classdef fileobj < handle
	%FILEOBJ - a Matlab binary file object; an interface to fopen, fread, fwrite, fseek, fclose, ftell
	%
	% This is an object interface to fopen, fread, fwrite, fseek, fclose, and ftell. Why do this?
	% One could imagine one day separating the process of reading and writing a data stream from the file
	% system. For example, one could write to GRIDFS by overriding these functions, and the user's code
	% would never have to know.
	%

	properties (SetAccess=protected, GetAccess=public)
		fullpathfilename; % the full path file name of the file
		fid;              % The Matlab file identifier
		permission;       % The file permission
		machineformat     % 'big-endian' or 'little-endian'
	end % properties

	methods,

		function fileobj_obj = fileobj(varargin)
			% FILEOBJ - create a new binary file object
			%
			% FILEOBJ_OBJ = FILEOBJ(...)
			%
			% Creates an empty FILEOBJ object. If FILENAME is provided,
			% then the filename is stored.
			%
				machineformat = 'b';
				permission = 'r';
				fid = -1;
				fullpathfilename = '';

				assign(varargin{:});

				fileobj_obj = fileobj_obj.setproperties('fullpathfilename',fullpathfilename,'fid',fid,...
						'permission',permission,'machineformat',machineformat);

		end % fileobj

		function fileobj_obj = setproperties(fileobj_obj, varargin)
			% SETPROPERTIES - set the properties of a FILEOBJ
			%
			% FILEOBJ_OBJ = SETPROPERTIES(FILEOBJ_OBJ, 'PROPERTY1',VALUE1, ...)
			%
			% Sets the properties of a FILEOBJ with name/value pairs.
			%
			% Properties are:
			%   fullpathfilename; % the full path file name of the file
			%   fid;              % The Matlab file identifier
			%   permission;       % The file permission
			%   machineformat     % 'big-endian' or 'little-endian'

				fn = fieldnames(fileobj_obj),
				for i=1:numel(fn),
					eval([fn{i} '=getfield(fileobj_obj,fn{i});']);
				end;

				assign(varargin{:});

				% check for accuracy would be a good idea

				fn = fieldnames(fileobj_obj);
				for i=1:numel(fn),
					eval(['fileobj_obj.' fn{i} '= ' fn{i} ';']);
				end;

		end; % setproperties

		function fileobj_obj = fopen(fileobj_obj, filename, permission, machineformat)
			% FOPEN - open a FILEOBJ 
			%
			% FILEOBJ_OBJ = FOPEN(FILEOBJ_OBJ, [FILENAME] [ , PERMISSION], [MACHINEFORMAT])
			%
			% Opens the file associated with a FILEOBJ_OBJ object. If FILENAME, PERMISSION, 
			% and MACHINEFORMAT are given, then those variables of FILEOBJ_OBJ are updated. If they
			% are not given, then the existing values in the FILEOBJ_OBJ are used.
			%
			% If the operation is successful, then FILEOBJ_OBJ.fid is greater than 3. Otherwise,
			% FILEOBJ_OBJ.fid is -1.
			%
				if fileobj_obj.fid > 0,  % if file is already open, close it first
					fileobj_obj.fclose();
				end; 

				% now work on opening

				if nargin<2,
					filename = fileobj_obj.fullfilename;
				end;
				if nargin<3,
					permission = fileobj_obj.permission;
				end;
				if nargin<4,
					machineformat = fileobj_obj.machineformat;
				end;
				
				filename = fullfilename(filename);
				fileobj_obj = setproperties('fullpathfilename',filename,...
					'permission',permission,'machineformat',machineformat);
				
				% now have the right parameters
				fileobj_obj.fid = fopen(fileobj_obj.fullpathname,fileobj_obj.permission,fileobj_obj.machineformat);

		end; %fopen

		function fileobj_obj = fclose(fileobj_obj, filename, permission, machineformat)
			% FCLOSE - close a FILEOBJ
			%
			% FILEOBJ_OBJ = FCLOSE(FILEOBJ_OBJ)
			%
			% Close a file associated with a FILEOBJ.
			%
			% Attempt to close the file and then set FILEOBJ_OBJ.fid to -1.
			%
				if fileobj_obj.fid >= 0,
					try,
						fclose(fileobj_obj.fid);
					end;
					fileobj_obj.fid = -1;
				end;
		end; %fclose()
	end;

end % classdef
