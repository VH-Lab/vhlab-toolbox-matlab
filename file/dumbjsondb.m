classdef dumbjsondb 
	% DUMBJSONDB - a very simple and slow JSON-based database with optional binary files


	properties (SetAccess=protected, GetAccess=public)
		paramfilename            % The full pathname of the parameter file
		dirname                  % The directory name where files are stored (same directory as parameter file)
		unique_object_id_field   % The field of each object that indicates the unique ID for each database entry
		hasbinaryfilefield       % The field of each object that indicates whether the entry has a binary file ('' for none)
		versionfield             % The field of each object that indicates the version ('' for none)
	end % properties

	methods
		function dumbjsondb_obj = dumbjsondb(varargin)
			% DUMBJSONDB - create a DUMBJSONDB object
			%
			% DUMBJSONDB_OBJ = DUMBJSONDB(COMMAND, ...)
			%
			% Create a DUMBJSONDB object via one of several routes.
			%
			% COMMAND options            | Description
			% ----------------------------------------------------------------------------------------
			% 'Load'                     | Second argument should be full path filename of the saved parameter file
			% 'New'                      | Second argument should be full path filename of the saved parameter file, 
			%                            |   arguments 3..N should be name/value pairs that override the default parameters
			% (None)                     | Creates an empty object.
				command = 'none';

				% default parameters

				paramfilename = '';
				dirname = '.dumbjsondb';
				unique_object_id_field = 'id';
				hasbinaryfilefield = 'hasbinaryfile';
				versionfield = '';

				if nargin>0,
					command = varargin{1};
				end;

				switch lower(command),
					case 'new',
						paramfilename = varargin{2};
						if nargin>2,
							try,
								assign(varargin{3:end});
							catch,
								error(['Extra arguments must come in name/value pairs (paramname and then value; see help namevaluepair).']);
							end
						end
						p = properties(dumbjsondb_obj);
						for i=1:numel(p),
							eval(['dumbjsondb_obj. ' p{i} ' = eval([p{i}]);']);
						end
						writeparameters(dumbjsondb_obj);
					case 'load',
						openfile = varargin{2};
						dumbjsondb_obj = loadparameters(dumbjsondb_obj, openfile);
					case '',
						p = properties(dumbjsondb_obj);
						for i=1:numel(p),
							eval(['dumbjsondb_obj. ' p{i} ' = eval([p{i}]);']);
						end
					otherwise,
						error(['Invalid command: ' command]); 
				end
		end % dumbjsondb()

		function b = writeparameters(dumbjsondb_obj)
			% WRITEPARAMETERS - write the parameters file and create the document directory
			%
			% B = WRITEPARAMETERS(DUMBJSONDB_OBJ)
			%
			% Writes the parameter file in json format and attempts to create the directory for the
			% database files.
			%
				if isempty(dumbjsondb_obj.paramfilename), % dont do anything if it is empty
					return;
				end; 

				% Step 1) make the path directory if needed
				[filepath] = path(dumbjsondb_obj);
				if ~exist(filepath,'dir'),
					try,
						mkdir(filepath);
					catch,
						error(['Could not create directory ' filepath '.']);
					end;
				end

				% Step 2) now can write the parameter file
				p = properties(dumbjsondb_obj);
				s.paramfilename = '';
				for i=1:numel(p),
					s=setfield(s,p{i},getfield(dumbjsondb_obj,p{i}));
				end;
				s = rmfield(s,'paramfilename'); % redundant and potentially error-prone if path moved
				je = jsonencode(s);
				str2text(dumbjsondb_obj.paramfilename,je);

				% Step 3) attempt to create the directory
				thedir = [filepath filesep dumbjsondb_obj.dirname];
				if ~exist(thedir),
					try,
						mkdir([thedir]);
					catch,
						error(['Could not create directory ' thedir '.']);
					end
				end
		end % writeparameters()

		function dumbjsondb_obj = loadparameters(dumbjsondb_obj, filename)
			% LOADPARAMETERS - load parameters from the parameters file and set values of DUMBJSONDB object
			%
			% DUMBJSONDB_OBJ = LOADPARAMETERS(DUMBJSONDB_OBJ [, FILENAME])
			%
			% Reads the parameters, either from FILENAME if it is provided, or from the DUMBJSONDB property
			% 'paramfilename'. Only parameters that exist in the current class are updated.
			%
				if nargin>1,
					dumbjsondb_obj.paramfilename = filename;
				end
				s = dumbjsondb.readparametersfile(dumbjsondb_obj.paramfilename);
				% dev note, subclasses will need to override this method
				fn = intersect(fieldnames(s),properties(dumbjsondb_obj));
				fn = setdiff(fn,'paramfilename'); % do not allow paramfilename to be set by the contents of the file
				for i=1:numel(fn),
					eval(['dumbjsondb_obj.' fn{i} ' = getfield(s,fn{i});']);
				end
		end % loadparameters()

		function dumbjsondb_obj = add(dumbjsondb_obj, doc, varargin)
			% ADD - add a document to a DUMBJSONDB
			%
			% DUMBJSONDB_OBJ = ADD(DUMBJSONDB_OBJ, DOC, ....)
			%
			% Add a document to the database DUMBJSONDB_OBJ.
			%
			% DOC should be a Matlab object. It will be encoded to a JSON
			% representation and saved.
			%
			% This function also accepts name/value pairs that modify the adding behavior:
			% Parameter (default)           | Description
			% ---------------------------------------------------------------------------
			% 'Overwrite' (1)               | Use 1 to overwrite current version
			%                               |   0 to return an error instead of overwriting
			%                               |   2 to add the document as a new version
				Overwrite = 1;
				assign(varargin{:});

				if Overwrite==2 & isempty(dumbjson_obj.versionfield),
					error(['Use of Overwrite==2 not permitted without version field.']);
				end
				
				[doc_unique_id, docversion, docbinaryfile] = docstats(dumbjsondb_obj, doc)
				% does file already exist?
				[p,f] = dumbjsondb_obj.resolvedocfilename(doc_unique_id, docversion);

				can_we_write = 0;
				if isempty(f), % 
					can_we_write = 1;
				else,
					if Overwrite==1, %write away, whether it exists or not
						can_we_write = 1;
					elseif Overwrite==0, % do not overwrite
						versstring = [];
						if ~isempty(version),
							versstring = [' and version ' num2str(docversion) ' '];
						end
						error(['Document with document id ' doc_unique_id ' versstring ' already exists, overwrite was not requested.']);
					elseif Overwrite==2, % increment version
						[vf,v] = dumbjsondb_obj.versionfiles(doc_unique_id);
						docversion = max(v) + 1;
						eval(['doc.' dumbjsondb_obj.versionfield '=docversion;']);
						can_we_write = 1;
						f = dumbjsondb.uniqueid2filename(doc_unique_id, docversion);
					else,
						error(['Unknown Overwrite mode: ' num2str(Overwrite) '.']);
					end
				end

				if can_we_write,
					js = jsonencodenan(doc);
					str2text([p f], js);
					if docbinaryfile, % just touch the file and leave it blank
						fb = dumbjsondb.uniqueid2binaryfilename(doc_unique_id, docversion);
						fid=fopen([p f],'w');
						fclose(fid);
					end
				end
		end % add()

		function doc = read(dumbjsondb_obj, doc_unique_id, version)
			% READ the JSON document corresponding to a particular document unique id
			%
			% DOC = READ(DUMBJSONDB_OBJ, DOC_UNIQUE_ID[, VERSION])
			%
			% Reads and decodes the document corresponding to the document unique id
			% DOC_UNIQUE_ID.
			%
			% If VERSION is provided, then the requested version is read. If it is not
			% provided, then the latest version is provided. VERSION can be between 0 and
			% hex2dec('FFFFF').
			%

				doc_unique_id = dumbjsondb.fixdocuniqueid(doc_unique_id);
				if nargin<3,
					version = [];
				end;

				[p,f] = dumbjsondb_obj.resolvedocfilename(doc_unique_id, version);

				if iscell(f),
					f = f{end}; % latest version
				end;

				t = textfile2char([p f]);
				doc = jsondecode(t);
		end % read()

		function doc = remove(dumbjsondb_obj, doc_unique_id, version)
			% REMOVE or delete the JSON document corresponding to a particular document unique id
			%
			% DOC = REMOVE(DUMBJSONDB_OBJ, DOC_UNIQUE_ID[, VERSION])
			%
			% Removes the document corresponding to the document unique id
			% DOC_UNIQUE_ID.
			%
			% If VERSION is provided, then the requested version is removed. If it is not
			% provided, then ALL versions are deleted.
			%
				if nargin<2,
					version = [];
				end;
				[p,f] = dumbjsondb_obj.resolvedocfilename(doc_unique_id,version);

				if ~iscell(f),
					f = {f};
				end;
				for i=1:numel(f),
					delete([p f{i}]);
					try,
						delete([p f{i} '.binary']);
					end
				end
		end % remove()

		function [p,f] = resolvedocfilename(dumbjsondb_obj, doc_unique_id, version)
			% RESOLVEDOCFILENAME Find the file name of a JSON document corresponding to a particular document unique id
			%
			% [P,F] = RESOLVEDOCFILENAME(DUMBJSONDB_OBJ, DOC_UNIQUE_ID[, VERSION])
			%
			% Resolves the document file corresponding to the document unique id
			% DOC_UNIQUE_ID and the path P.
			%
			% If VERSION is provided, then the requested version is provided. F is empty is there is
			% no such version. If VERSION is not provided, then ALL versions are provided and F will
			% be a cell array of strings.
			%
				if nargin<2,
					version = [];
				end;

				p = [dumbjsondb_obj.path() filesep dumbjsondb_obj.dirname filesep];
				if isempty(dumbjsondb_obj.versionfield),
					if nargin>2,
						if ~isempty(version),
							error(['Database does not have version control but specific version was requested.']);
						end
					end
					f = dumbjsondb.uniqueid2filename(doc_unique_id);
				else,
					if nargin>2, % specific version requested
						f = dumbjsondb.uniqueid2filename(doc_unique_id,version);
					else, % need all versions
						f = versionfiles(dumbjsondb_obj,doc_unique_id);
					end
				end;
		end % resolvedocfilename()

		function [doc_unique_id, docversion, docbinaryfile] = docstats(dumbjsondb_obj, doc)
			% DOCSTATS - document stats including document version and whether or not the document has a binary file
			%
			% [DOC_UNIQUE_ID, DOCVERSION, DOCBINARYFILE] = DOCSTATS(DUMBJSONDB_OBJ, DOC)
			%
			% Returns several pieces of information about the Matlab structure/object DOC:
			%
			% DOC_UNIQUE_ID is the document unique id (specified in the property 'document_unique_id' of
			%      DUMBJSONDB_OBJ).
			% DOCVERSION is the document version of DOC, or is empty if the 'verisionfield' property of
			%      DUMBJSONDB_OBJ is empty.
			% DOCBINARYFILE is 1 if and only if DOC has the field specified in property 'hasbinaryfilefield'
			%      and the value is 1; otherwise DOCBINARYFILE is 0.
			%
				doc_unique_id = eval(['doc.' dumbjsondb_obj.unique_object_id_field ';']);
				doc_unique_id = dumbjsondb.fixdocuniqueid(doc_unique_id);
				docversion = [];
				docbinaryfile = 0;
				if ~isempty(dumbjsondb_obj.versionfield),
					try,
						docversion = eval(['doc.' dumbjsondb_obj.versionfield ';']);
					catch,
						docversion = 0;  % assume no entry means 0
					end
				end
				if ~isempty(dumbjsondb_obj.hasbinaryfilefield),
					try,
						docbinaryfile = eval(['doc.' dumbjsondb_obj.hasbinaryfilefield ';']);
					catch,
						docbinaryfile = 0; % assume no entry means 0
					end
				end
		end %docstats()

		function [vf,v] = versionfiles(dumbjsondb_obj, doc_unique_id)
			% VERSIONFILES - return all version files for a doc unique id of a DUMBJSONDB object
			%
			% [VF,V] = VERSIONS(DUMBJSONDB_OBJ, DOC_UNIQUE_ID)
			%
			% Returns all version files VF and version numbers V (integers) that are available for the document
			% with DOC_UNIQUE_ID. If there is no version control or no versions, empty is returned.
			%
				vf = {};
				v = [];
				if isempty(dumbjsondb_obj.versionfield), 
					return;
				end;
				f = dumbjsondb.uniqueid2filename(doc_unique_id);
				p = [dumbjsondb_obj.path() filesep dumbjsondb_obj.dirname filesep];
				[fn,ext]=fileparts(f);
				newf = [fn '_v*' ext];
				d = dir(newf);
				vf = {d.name};
				if nargout>1, % only do this if requested
					for i=1:numel(d),
						hex = d(i).name(numel(f)+3:numel(f)+3+5);
						v(end+1) = hex2dec(hex);
					end
				end
		end % versionfiles()

		function p = path(dumbjsondb_obj)
			% PATH - the pathname of the paramfile for a DUMBJSONDB_OBJ
			%
			% P = PATH(DUMBJSONDB_OBJ)
			%
			% Returns the file path for the parameter file.
			%
				p = fileparts(dumbjsondb_obj.paramfilename);
		end % path()
	end % methods

	methods (Static)
		function f = uniqueid2filename(doc_unique_id, version)
			% UNIQUEID2FILENAME - return the filename for a document given its unique id
			%
			% F = UNIQUEID2FILENAME(DOC_UNIQUE_ID[, VERSION])
			%
			% Return the filename for a document given its DOC_UNIQUE_ID.  
			% The filename is the DOC_UNIQUE_ID converted to a valid file name 
			% using STRING2FILESTRING. If VERSION is present, then '_v#' is appended,
			% where '#' is the hexadecimal version with 5 digits. The file extension is '.json'.
			%
			% See also: DUMBJSONDB/UNIQUEID2BINARYFILENAME, STRING2FILESTRING
			%
				f = string2filestring(doc_unique_id);
				if nargin>1,
					if ~isempty(version),
						if version > hex2dec('FFFFF'),
							error(['Version number requested (' num2str(version) ') is larger than max: ' num2str(hex2dec('FFFFF')) '.']);
						end
						f = [f '_v' dec2hex(version,5)];
					end
				end
				f = [f '.json'];
		end % uniqueid2filename()

		function f = uniqueid2binaryfilename(doc_unique_id, version)
			% UNIQUEID2BINARYFILENAME - return the binary filename for a document given its unique id
			%
			% F = UNIQUEID2BINARYFILENAME(DOC_UNIQUE_ID[, VERSION])
			%
			% Return the filename for the associated binary file given its DOC_UNIQUE_ID, and, optionally,
			% a version. The filename is UNIQUEID2FILENAME with the added extension '.binary'.
			%
			% See also: DUMBJSONDB/UNIQUEID2FILENAME
			%
				if nargin<2,
					f = dumbjsondb.uniqueid2filename(doc_unique_id);
				else,
					f = dumbjsondb.uniqueid2filename(doc_unique_id, version);
				end;
				f = [f '.binary'];
		end % uniqueid2binaryfilename()

		function s = readparametersfile(filename)
			% READPARAMETERSFILE - read the parameters from a JSON file
			%
			% S = READPARAMETERSFILE(FILENAME)
			%
			% Read the parameters from the JSON file
			%
				if ~exist(filename,'file'),
					error(['File ' filename ' does not exist.']);
				end
				t = textfile2char(filename);
				s = jsondecode(t);
		end % readparameters

		function doc_unique_id = fixdocuniqueid(doc_unique_id)
			% FIXDOCUNIQUEID - make sure document unique id is a string
			%
			% DOC_UNIQUE_ID = FIXDOCUNIQUEID(DOC_UNIQUE_ID)
			%
			% If DOC_UNIQUE_ID is a number, it is turned into a string.
			%
				if isnumeric(doc_unique_id),
					doc_unique_id = mat2str(doc_unique_id);
				end
		end % fixdocuniqueid()

	end % methods (Static)

end % classdef dumbjsondb
