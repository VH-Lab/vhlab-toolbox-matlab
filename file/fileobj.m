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
	end; % properties

	methods,
		function fileobj_obj = fileobj(varargin)
			% FILEOBJ - create a new binary file object
			%
			% FILEOBJ_OBJ = FILEOBJ(...)
			%
			% Creates an empty FILEOBJ object. If FILENAME is provided,
			% then the filename is stored.
			%
				machineformat = 'n'; % native machine format
				permission = 'r';
				fid = -1;
				fullpathfilename = '';

				assign(varargin{:});

				fileobj_obj = fileobj_obj.setproperties('fullpathfilename',fullpathfilename,'fid',fid,...
						'permission',permission,'machineformat',machineformat);
		end; % fileobj()

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
			%   machineformat     % big-endian ('b'), little-endian ('l'), or native ('n')

				fn = fieldnames(fileobj_obj);
				for i=1:numel(fn),
					eval([fn{i} '=getfield(fileobj_obj,fn{i});']);
				end;

				assign(varargin{:});

				% check for accuracy would be a good idea

				fn = fieldnames(fileobj_obj);
				for i=1:numel(fn),
					eval(['fileobj_obj.' fn{i} '= ' fn{i} ';']);
				end;

		end; % setproperties()

		function fileobj_obj = fopen(fileobj_obj, permission, machineformat, filename)
			% FOPEN - open a FILEOBJ 
			%
			% FILEOBJ_OBJ = FOPEN(FILEOBJ_OBJ, [ , PERMISSION], [MACHINEFORMAT],[FILENAME])
			%
			% Opens the file associated with a FILEOBJ_OBJ object. If FILENAME, PERMISSION, 
			% and MACHINEFORMAT are given, then those variables of FILEOBJ_OBJ are updated. If they
			% are not given, then the existing values in the FILEOBJ_OBJ are used.
			%
			% Note that the order of the input arguments differs from FOPEN, so that the object
			% can be called in place of an FID (e.g., fid=fopen(myvariable), where myvariable is
			% either a file name or a FILEOBJ object).
			%
			% If the operation is successful, then FILEOBJ_OBJ.fid is greater than 3. Otherwise,
			% FILEOBJ_OBJ.fid is -1.
			%
			% See also: FOPEN, FILEOBJ/FCLOSE, FCLOSE
			%
				if fileobj_obj.fid > 0,  % if file is already open, close it first
					fileobj_obj.fclose();
				end; 

				% now work on opening

				if nargin<2,
					permission = fileobj_obj.permission;
				end;
				if nargin<3,
					machineformat = fileobj_obj.machineformat;
				end;
				if nargin<4,
					filename = fileobj_obj.fullpathfilename;
				end;
			
				filename = fullfilename(filename);
				fileobj_obj = fileobj_obj.setproperties('fullpathfilename',filename,...
					'permission',permission,'machineformat',machineformat);
				
				% now have the right parameters
				fileobj_obj.fid = fopen(fileobj_obj.fullpathfilename,...
					fileobj_obj.permission,fileobj_obj.machineformat);

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

		function B = fseek(fileobj_obj, offset, reference)
			% FSEEK - seek to a location within a FILEOBJ
			%
			% B = FSEEK(FILEOBJ_OBJ, OFFSET, REFERENCE)
			%
			% Seeks the file to the location OFFSET (in bytes) relative to
			% REFERENCE. REFERENCE can be 
			%     'bof' or -1   Beginning of file
			%     'cof' or  0   Current position in file
			%     'eof' or  1   End of file
			%
			% B is 0 on success and -1 on failure.
			%
			% See also: FSEEK, FILEOBJ/FTELL
				b = -1;
				if fileobj_obj.fid >=0,
					b = fseek(fileobj_obj.fid,offset,reference);
				end;
		end; % fseek()

		function location = ftell(fileobj_obj)
			% FTELL - find current location within a FILEOBJ
			%
			% LOCATION = FTELL(FILEOBJ_OBJ)
			%
			% Returns the current location (in bytes) relative to the beginning of the
			% file. If the query fails, -1 is returned.
			%
			% See also: FSEEK, FILEOBJ/FSEEK, FTELL
				location = -1;
				if fileobj_obj.fid >=0,
					location = ftell(fileobj_obj.fid);
				end;
		end; % ftell()

		function frewind(fileobj_obj)
			% FREWIND - 'rewind' a FILEOBJ back to the beginning
			%
			% FREWIND(FILEOBJ_OBJ)
			%
			% Seeks to the beginning of the file.
			%
			% See also: FSEEK, FILEOBJ/FSEEK, FTELL
				if fileobj_obj.fid >=0,
					frewind(fileobj_obj.fid);
				end
		end; % frewind()

		function b = feof(fileobj_obj)
			% FEOF - test to see if a FILEOBJ is at END-OF-FILE
			%
			% B = FEOF(FILEOBJ_OBJ)
			%
			% Returns 1 if FILEOBJ_OBJ is at its end of file, 0 otherwise.
			%
			% See also: FSEEK, FILEOBJ/FSEEK, FTELL
				b = -1;
				if fileobj_obj.fid >=0,
					b = feof(fileobj_obj.fid);
				end;
		end; % feof

		function count = fwrite(fileobj_obj, data, precision, skip, machineformat)
			% FWRITE - write data to a FILEOBJ
			%
			% COUNT = FWRITE(FILEOBJ_OBJ, DATA, [PRECISION], [SKIP], [MACHINEFORMAT])
			%
			% Attempts to write DATA elements with resolution PRECISION. If PRECISION is not 
			% provided, then 'char' is assumed. If SKIP is provided, then SKIP is in number of bytes, unless
			% PRECISION is in bits, in which case SKIP is in bits. MACHINEFORMAT is the machine format to use.
			%
			% See FWRITE for a full description of these input arguments.
			%
			% See also: FWRITE

				if nargin<3,
					precision = 'char';
				end;
				if nargin<4,
					skip = 0;
				end;
				if nargin<5,
					machineformat = fileobj_obj.machineformat;
				end;

				count = 0;
				if fileobj_obj.fid >=0,
					count = fwrite(fileobj_obj.fid, data, precision, skip, machineformat);
				end;
		end; % fwrite

		function [data,count] = fread(fileobj_obj, count, precision, skip, machineformat)
			% FREAD - read data from a FILEOBJ
			%
			% COUNT = FWRITE(FILEOBJ_OBJ, COUNT, [PRECISION], [SKIP], [MACHINEFORMAT])
			%
			% Attempts to read COUNT elements with resolution PRECISION. If PRECISION is not 
			% provided, then 'char' is assumed. If SKIP is provided, then SKIP is in number of bytes, unless
			% PRECISION is in bits, in which case SKIP is in bits. MACHINEFORMAT is the machine format to use.
			%
			% See FREAD for a full description of these input arguments.
			%
			% See also: FREAD

				data = [];

				if nargin<3,
					precision = 'char';
				end;
				if nargin<4,
					skip = 0;
				end;
				if nargin<5,
					machineformat = fileobj_obj.machineformat;
				end;
				
				if fileobj_obj.fid >=0,
					[data,count] = fread(fileobj_obj.fid, count, precision, skip, machineformat);
				else,
					count = 0;
				end;
		end; % fread

		function tline = fgetl(fileobj_obj, nchar)
			% FGETL - get a line from a FILEOBJ
			%
			% TLINE = FGETL(FILEOBJ_OBJ)
			%
			% Returns the next line (not including NEWLINE character) just like FGETL.
			%
			% See also: FGETL
				tline = '';
				if fileobj_obj.fid >=0,
					tline = fgetl(fileobj_obj.fid);
				end;
		end; % fgetl()

		function tline = fgets(fileobj_obj, nchar)
			% FGETS - get a line from a FILEOBJ
			%
			% TLINE = FGETS(FILEOBJ_OBJ, [NCHAR])
			%
			% Returns the next line (including NEWLINE character) just like FGETS.
			%
			% See also: FGETS
				tline = '';
				if fileobj_obj.fid >=0,
					if nargin<2,
						tline = fgets(fileobj_obj.fid);
					else,
						tline = fgets(fileobj_obj.fid, nchar);
					end;
				end;
		end; % fgets()

		function [message,errnum] = ferror(fileobj_obj, command)
			% FERROR - return the last file error message for FILEOBJ
			%
			% [MESSAGE, ERRORNUM] = FERROR(FILEOBJ_OBJ, COMMAND)
			%
			% Return the most recent file error MESSAGE and ERRORNUM for
			% the file associated with FERROR.
			%
				message='';
				errnum=0;
				if fileobj_obj.fid >= 0,
					if nargin<2,
						[message,errnum]=ferror(fileobj_obj.fid);
					else,
						[message,errnum]=ferror(fileobj_obj.fid,command);
					end;
				end;
		end; % ferror

		function [a, count] = fscanf(fileobj_obj, format, sizea)
			% FSCANF - scan data from a FILEOBJ_OBJ
			%
			% [A,COUNT] = FSCANF(FID,FORMAT,[SIZEA])
			%
			% Call FSCANF (see FSCANF for inputs) for the file associated with
			% FILEOBJ_OBJ.
			%
				a = [];
				count = 0;
				if fileobj_obj.fid >= 0,
					if nargin<3,
						[a, count] = fscanf(fileobj_obj.fid,format);
					else,
						[a, count] = fscanf(fileobj_obj.fid,format,sizea);
					end;
				end;
		end; % fscanf()

		function [count] = fprintf(fileobj_obj, varargin)
			% FPRINTF - print data to a FILEOBJ_OBJ
			%
			% [COUNT] = FPRINTF(FID,FORMAT,A, ...)
			%
			% Call FPRINTF (see FPRINTF for inputs) for the file associated with
			% FILEOBJ_OBJ.
			%
				count = 0;
				if fileobj_obj.fid >= 0,
					count = fprintf(fileobj_obj.fid,varargin{:});
				end;
		end; % fprintf()

		function [pathstr,name,ext] = fileparts(fileobj_obj)
			% FILEPARTS - return filename parts for the file associated with FILEOBJ
			%
			% [PATHSTR,NAME,EXT] = FILEPARTS(FILEOBJ_OBJ)
			%
			% Returns FILEPARTS of the 'fullpathfilename' field of FILEOBJ.
			%
				[pathstr,name,ext]=fileparts(fileobj_obj.fullpathfilename);
		end % fileparts

		function delete(fileobj_obj)
			% DELETE - delete a FILEOBJ_OBJ, closing file first if need be
			%
			% DELETE(FILEOBJ_OBJ)
			%
			% Deletes the handle FILEOBJ_OBJ. If the file (FILEOBJ_OBJ.fid) is open,
			% it is closed first.
			%
			% See also: HANDLE/DELETE, FILEOBJ/FCLOSE

				fclose(fileobj_obj);
				delete@handle(fileobj_obj);
		end; % delete()
	end; % methods
end % classdef

