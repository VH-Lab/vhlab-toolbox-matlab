classdef dumbjsondb
	% DUMBJSONDB - a very simple and slow JSON-based database with associated binary files
	%
	% DUMBJSONDB implements a very simple JSON-based document database. Each document is
	% represented as a JSON file. Each document also has an associated binary file that can
	% be read/written. The search capabilities of DUMBJSONDB are very rudimentory, and every
	% document is read in for examination. Therefore, searching DUMBJSONDB will be very slow.
	% Furthermore, as all of the documents are stored in a single directory, the database size
	% will be limited to the number of files that are permitted in a single directory by the
	% file system divided by 3 (there is a .JSON file, a binary file, and a metadata file for
	% each document). 
	%
	% Example: Create and test a DUMBJSONDB object in the current directory.
	%     % create a new db
	%     db = dumbjsondb('new',[pwd filesep 'mydb.json']);
	%
	%     % add some new entries
	%     for i=1:5,
	%         a.id = 2000+i;
	%         a.value = i;
        %         db.add(a);
	%     end;
	%     
	%     % read latest version of all the entries
	%     ids = db.alldocids;
	%     for i=1:numel(ids), 
	%          db.read(ids{i}), % display the entry
	%     end
	%
	%     % search for a document
	%     [docs,doc_versions] = db.search({},{'value',5})
	%     % search for a document that doesn't exist because '5' is a string
	%     [docs,doc_versions] = db.search({},{'value','5'})
	%     % use the struct version of search
	%     [docs,doc_versions] = db.search({},struct('field','value','operation','greaterthan','param1',1,'param2',[]))
	%      
	%     % remove an entry
	%     db.remove(2002);
	%
	%     % update 2005 to new version, saving old version
	%     a.value = 20;
	%     db.add(a,'Overwrite',2); % will automatically update version number
	%
	%     % read first and latest version of all the entries
	%     ids = db.alldocids;
	%     for i=1:numel(ids), 
	%          disp(['0th version:']);
	%          db.read(ids{i},0), % display the 0th version
	%          disp(['Latest version:']);
	%          db.read(ids{i}), % display the entry
	%     end
	%
	%     % add binary information to binary file
	%     [fid,key] = db.openbinaryfile(2005);
	%     if fid>0,
	%          fwrite(fid,'this is a test','char');
	%          [fid] = db.closebinaryfile(fid, key, 2005);
	%     end
	%     % read the binary file
	%     [fid, key] = db.openbinaryfile(2005);
	%     if fid>0,
	%          fseek(fid,0,'bof'); % go to beginning of file
	%          output=char(fread(fid,14,'char'))',
	%          [fid] = db.closebinaryfile(fid, key, 2005);
	%     end
	%
	%     % remove all entries
	%     db.clear('Yes');
	
	properties (SetAccess=protected, GetAccess=public)
		paramfilename            % The full pathname of the parameter file
		dirname                  % The directory name where files are stored (same directory as parameter file)
		unique_object_id_field   % The field of each object that indicates the unique ID for each database entry
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
			% (None)                     | Creates an empty object.
			%
			% This file also accepts additional name/value pairs for arguments 3..end. 
			% Parameter (default)           | Description
			% ----------------------------------------------------------------------------------------
			% dirname ('.dumbjsondb')       | The directory name, relative to the parameter file
			% unique_object_id_field ('id') | The field name in the database for the unique object identifier 
			%
			% See also: DUMBJSONDB, DUMBJSONDB/READ, DUMBJSONDB/REMOVE, DUMBJSONDB/DOCVERSIONS, DUMBJSONDB/ALLDOCIDS
			%
				command = 'none';

				% default parameters

				paramfilename = '';
				dirname = '.dumbjsondb';
				unique_object_id_field = 'id';

				if nargin>0,
					command = varargin{1};
				end;

				switch lower(command),
					case 'new', % create a new object
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
					case 'load',  % load object from file
						openfile = varargin{2};
						dumbjsondb_obj = loadparameters(dumbjsondb_obj, openfile);
					case '',
						p = properties(dumbjsondb_obj);
						for i=1:numel(p),
							eval(['dumbjsondb_obj. ' p{i} ' = eval([p{i}]);']);
						end
					otherwise,
						error(['Invalid command: ' command]); 
				end;
		end % dumbjsondb()

		function dumbjsondb_obj = add(dumbjsondb_obj, doc_object, varargin)
			% ADD - add a document to a DUMBJSONDB
			%
			% DUMBJSONDB_OBJ = ADD(DUMBJSONDB_OBJ, DOC_OBJECT, ....)
			%
			% Add a document to the database DUMBJSONDB_OBJ.
			%
			% DOC_OBJECT should be a Matlab object. It will be encoded to a JSON
			% representation and saved.
			%
			% This function also accepts name/value pairs that modify the adding behavior:
			% Parameter (default)           | Description
			% ---------------------------------------------------------------------------
			% 'Overwrite' (1)               | Use 1 to overwrite current version
			%                               |   0 to return an error instead of overwriting
			%                               |   2 to add the document as a new version
			% 'doc_version' (latest)        | Use a specific number to write a specific version
			%
			% See also: DUMBJSONDB, DUMBJSONDB/READ, DUMBJSONDB/REMOVE, DUMBJSONDB/DOCVERSIONS, DUMBJSONDB/ALLDOCIDS
			%
				Overwrite = 1;
				[doc_unique_id] = docstats(dumbjsondb_obj, doc_object);
				doc_version = dumbjsondb_obj.latestdocversion(doc_unique_id);
				assign(varargin{:});

				% does file already exist?
				p = dumbjsondb_obj.documentpath();
				f = dumbjsondb.uniqueid2filename(doc_unique_id, doc_version);

				fileexist = exist([p f],'file');

				we_know_we_have_latest_version = []; % we will assign this below

				can_we_write = 0;
				if ~fileexist, % we are writing for the first time
					we_know_we_have_latest_version = 1;
					can_we_write = 1;
				else, 
					if Overwrite==1, %write away, whether it exists or not
						can_we_write = 1;
						we_know_we_have_latest_version = 1;
					elseif Overwrite==0, % do not overwrite
						versstring = [];
						if ~isempty(version),
							versstring = [' and version ' num2str(doc_version) ' '];
						end
						error(['Document with document id ' doc_unique_id ' versstring ' already exists, overwrite was not permitted by user request.']);
					elseif Overwrite==2, % increment version
						v = dumbjsondb_obj.docversions(doc_unique_id);
						doc_version = max(v) + 1;
						can_we_write = 1;
						we_know_we_have_latest_version = 1;
					else,
						error(['Unknown Overwrite mode: ' num2str(Overwrite) '.']);
					end
				end

				if can_we_write,
					writeobject(dumbjsondb_obj, doc_object, doc_unique_id, doc_version);
				end
		end % add()

		function [document, doc_version] = read(dumbjsondb_obj, doc_unique_id, doc_version)
			% READ the JSON document corresponding to a particular document unique id
			%
			% [DOCUMENT, VERSION] = READ(DUMBJSONDB_OBJ, DOC_UNIQUE_ID[, VERSION])
			%
			% Reads and decodes the document corresponding to the document unique id
			% DOC_UNIQUE_ID.
			%
			% If VERSION is provided, then the requested version is read. If it is not
			% provided, then the latest version is provided. VERSION can be between 0 and
			% hex2dec('FFFFF').
			%
			% DOCUMENT is the Matlab object generated by the decoded JSON file. VERSION is the
			% actual version that was read. If there is no such document, then DOCUMENT and VERSION
			% will be empty ([]).
			%
			% See also: DUMBJSONDB, DUMBJSONDB/ADD, DUMBJSONDB/REMOVE, DUMBJSONDB/DOCVERSIONS, DUMBJSONDB/ALLDOCIDS
			%
				doc_unique_id = dumbjsondb.fixdocuniqueid(doc_unique_id); % make sure it is a string
				if nargin<3,
					doc_version = [];
				end;

				if isempty(doc_version), % read latest
					v = dumbjsondb_obj.docversions(doc_unique_id);
					doc_version = max(v);
					[document,doc_version] = dumbjsondb_obj.read(doc_unique_id,doc_version);
				else, % read specific version
					p = dumbjsondb_obj.documentpath();
					f = dumbjsondb.uniqueid2filename(doc_unique_id, doc_version);
					if exist([p f],'file'),
						t = textfile2char([p f]); % dev note: should this go in separate function? maybe
						document = jsondecode(t);
					else,
						document = []; % no such document
					end;
				end
		end % read()

		function [fid, key, doc_version] = openbinaryfile(dumbjsondb_obj, doc_unique_id, doc_version)
			% OPENBINARYFILE - return the FID for the binary file associated with a DUMBJSONDB document
			%
			% [FID, KEY, DOC_VERSION] = OPENBINARYFILE(DUMBJSONDB_OBJ, DOC_UNIQUE_ID[, DOC_VERSION])
			%
			% Attempts to obtain the lock and open the binary file associated with
			% DOC_UNIQUE_ID and DOC_VERSION for reading/writing. If DOC_VERSION is not present,
			% then the lastest version is used. All the binary files are in 'big-endian' format and 
			% are opened as such by OPENBINARYFILE. 
			%
			% If there is no such file, an error is generated. If the file is locked by another program,
			% then FID is -1.
			%
			% File lock is achieved using CHECKOUT_LOCK_FILE. The lock file must be closed and deleted
			% after FID is closed so that other programs can use the file. This service is performed by
			% CLOSEBINARYFILE.
			%
			% KEY is a random key that is needed to close the file (releases the lock).
			%
			% Example:
			%      [fid, key]=mydb.openbinaryfile(doc_unique_id);
			%      if fid>0,
			%          try, 
			%              % do something, e.g., fwrite(fid,'my data','char'); 
			%              [fid] = mydb.closebinaryfile(fid, key, doc_unique_id);
			%          catch, 
			%              [fid] = mydb.closebinaryfile(fid, key, doc_unique_id);
			%              error(['Could not do what I wanted to do.'])
			%          end
			%      end
			%      
			%
			% See also: DUMBJSONDB/CLOSEBINARYFILE, DUMBJSONDB/READ, CHECKOUT_LOCK_FILE, FREAD, FWRITE

				fid = -1;
				lockfid = -1;
				key = -1;
				doc_unique_id = dumbjsondb.fixdocuniqueid(doc_unique_id); % make sure it is a string
				if nargin<3,
					doc_version = [];
				end;
				[document, doc_version] = dumbjsondb_obj.read(doc_unique_id, doc_version);

				% otherwise, we need to open one
					
				f = dumbjsondb.uniqueid2binaryfilename(doc_unique_id, doc_version);
				p = dumbjsondb_obj.documentpath();

				lockfilename = [p f '-lock'];
				lockfid = checkout_lock_file(lockfilename);
				if lockfid > 0,
					key = ndi_unique_id;
					fwrite(lockfid,key,'char',0,'ieee-le');
					fclose(lockfid);  % we have it, don't need to keep it open
					%disp(['about to open file ' [p f] ' with permissions a+']);
					fid = fopen([p f], 'a+', 'ieee-le'); % open in read/write mode, impose little-endian for cross-platform compatibility
					if fid > 0, % we are okay
					else % need to close and delete the lock file before reporting error
						fid = -1;
						if exist(lockfilename,'file'),
							delete(lockfilename);
						end;
					end;
				else, % we can't obtain the lock but it's not an error, we have to try again later
					fid = -1;
				end;
		end % openbinaryfile()

		function fid = closebinaryfile(dumbjsondb_obj, fid, key, doc_unique_id, doc_version)
			% CLOSEBINARYFILE - close and unlock the binary file associated with a DUMBJSONDB document
			%
			% [FID] = CLOSEBINARYFILE(DUMBJSONDB_OBJ, FID, KEY, DOC_UNIQUE_ID, [DOC_VERSION])
			%
			% Closes the binary file associated with DUMBJSONDB that has file identifier FID,
			% DOC_UNIQUE_ID and DOC_VERSION. If DOC_VERSION is not provided, the lastest will be used.
			% This function closes the file and deletes the lock file. KEY is the key that is returned
			% by OPENBINARYFILE, and is needed to release the lock on the binary file.
			%
			% FID is set to -1 on exit.
			%
			% See also: DUMBJSONDB/OPENBINARYFILE, CHECKOUT_LOCK_FILE
			%
				% if the file is open, close it

				if fid>0,
					[fname,perm] = fopen(fid);

					if numel(fname)>numel('.binary'),
						if ~strcmpi(fname(end-6:end),'.binary'),
							error(['This does not appear to be a DUMBJSONDB binary file: ' fname ]);
						end
					elseif isempty(fname),
						% nothing to do, already closed;
					else,
						fclose(fid);
						fid = -1;
					end
				end;

				% if the lock file exists, delete it 

				doc_unique_id = dumbjsondb.fixdocuniqueid(doc_unique_id); % make sure it is a string

				if nargin<5,
					doc_version = [];
				end;
				[document, doc_version] = dumbjsondb_obj.read(doc_unique_id, doc_version);

				f = dumbjsondb.uniqueid2binaryfilename(doc_unique_id, doc_version);
				p = dumbjsondb_obj.documentpath();

				lockfilename = [p f '-lock'];
				if exist(lockfilename,'file'),
					lockfid = fopen(lockfilename,'r','ieee-le');
					if lockfid<0,
						% failed to open lock file, just stop
						return;
					end;
					keystring = fgets(lockfid);
					fclose(lockfid);
					if strcmp(keystring,key),
						delete(lockfilename);
					end;
				end;
		end % closebinaryfile

		function [docs, doc_versions] = search(dumbjsondb_obj, scope, searchParams)
			% SEARCH - perform a search of DUMBJSONDB documents
			%
			% [DOCS, DOC_VERSIONS] = SEARCH(DUMBJSONDB_OBJ, SCOPE, SEARCHPARAMS)
			%
			% Performs a search of DUMBJSONDB_OBJ to find matching documents.
			%
			% SCOPE is a cell array of name/value pairs that modify the search
			% scope:
			% SCOPE parameter (default)    : Description
			% ----------------------------------------------------------------------
			% version ('latest')           : Which versions should be searched? Can be
			%                              :   a specific number, 'latest', or 'all'
			%
			% SEARCHPARAMS should be either be {'PARAM1', VALUE1, 'PARAM2', VALUE2, ... }
			%  or a search structure appropriate for FIELDSEARCH.
			%
			% The document parameters PARAM1, PARAM2 are examined for matches.
			% If VALUEN is a string, then a regular expression
			% is evaluated to determine the match. If valueN is not a string, then the
			% the items must match exactly.
			%
			% DOCS is a cell array of JSON-decoded documents. DOC_VERSIONS is an array of
			% the corresponding document versions.
			%
			% Case is not considered.
			%
			% Examples:
			%      indexes = search(mydb, 'type','nsd_spikedata');
			%      indexes = search(mydb, 'type','nsd_spike(*.)');
			%
			% See also: REGEXPI

				docs = {};
				doc_versions = [];

				version = 'latest';
				assign(scope{:});

				docids = dumbjsondb_obj.alldocids();

				for i=1:numel(docids),
					if strcmpi(version,'latest'),
						v_here = dumbjsondb_obj.docversions(docids{i});
						v_here = max(v_here);
					elseif strcmpi(version,'all'),
						v_here = dumbjsondb_obj.docversions(docids{i});
					else
						v_here = version;
					end;

					for j=1:numel(v_here),
						[doc_here, version_here] = dumbjsondb_obj.read(docids{i},v_here(j));
						b = dumbjsondb.ismatch(doc_here, searchParams);
						if b,
							docs{end+1} = doc_here;
							doc_versions(end+1) = version_here;
						end; 
					end;
				end
		end % search()

		function dumbjsondb_obj = remove(dumbjsondb_obj, doc_unique_id, version)
			% REMOVE or delete the JSON document corresponding to a particular document unique id
			%
			% DUMBJSONDB_OBJ = REMOVE(DUMBJSONDB_OBJ, DOC_UNIQUE_ID, VERSION)
			%
			% Removes the document corresponding to the document unique id
			% DOC_UNIQUE_ID and version VERSION.
			%
			% If VERSION is provided, then the requested version is removed. If it is not
			% provided, or is equal to the string 'all', then ALL versions are deleted.
			%
			% See also: DUMBJSONDB/CLEAR
			%
				if nargin<3,
					version = 'all';
				elseif isempty(version),
					version = 'all';
				end;

				if strcmp(lower(version),'all'),
					v = dumbjsondb_obj.docversions(doc_unique_id);
					version = v;
				end;

				% delete the versions requested

				p = dumbjsondb_obj.documentpath();

				for i=1:numel(version),
					vfname = dumbjsondb.uniqueid2filename(doc_unique_id,version(i));
					bfname = dumbjsondb.uniqueid2binaryfilename(doc_unique_id,version(i));

					% delete the object file
					if exist([p vfname],'file'),
						delete([p vfname]);
					end
					% delete any binary data
					if exist([p bfname],'file'),
						delete([p bfname]);
					end
				end
				if strcmp(version,'all'),
					operation = 'Deleted all versions';
				else,
					operation = 'Deleted version';
				end;

				updatedocmetadata(dumbjsondb_obj, operation, [], doc_unique_id, version);
		end % remove()

		function clear(dumbjsondb_obj, areyousure)
			% CLEAR - remove/delete all records from a DUBMJSONDB
			% 
			% CLEAR(DUMBJSONDB_OBJ, [AREYOUSURE])
			%
			% Removes all documents from the DUMBJSONDB object.
			% 
			% Use with care. If AREYOUSURE is 'yes' then the
			% function will proceed. Otherwise, it will not.
			%
			% See also: DUMBJSONDB/REMOVE

				if nargin<2,
					areyousure = 'no';
				end;
				if strcmpi(areyousure,'Yes')
					ids = dumbjsondb_obj.alldocids;
					for i=1:numel(ids), 
						dumbjsondb_obj.remove(ids{i}); % remove the entry
					end
				else,
					disp(['Not clearing because user did not indicate he/she is sure.']);
				end;
		end % clear

		function doc_unique_id = alldocids(dumbjsondb_obj)
			% ALLDOCIDS - return all doc unique id numbers for a DUMBJSONDB
			%
			% DOC_UNIQUE_ID = ALLDOCIDS(DUMBJSONDB_OBJ)
			%
			% Return a cell array of all document unique ID(s) (char strings) for the
			% DUMBJSONDB object DUMBJSONDB_OBJ.
			%
				doc_unique_id = {};
				d = dir([dumbjsondb_obj.documentpath() 'Object_id_*.txt']);
				for i=1:numel(d),
					mystr = sscanf(d(i).name,'Object_id_%s');
					if ~isempty(mystr),
						doc_unique_id{end+1} = mystr(1:end-4); % drop '.txt'
					end;
				end
		end % alldocids()

		function v = docversions(dumbjsondb_obj, doc_unique_id)
			% DOCVERSIONS - find all document versions for a DUMBJSONDB
			%
			% V = DOCVERSIONS(DUMBJSONDB_OBJ, DOC_UNIQUE_ID)
			%
			% Return all version numbers for a given DUMBJSONDB and a
			% DOC_UNIQUE_ID.
			%
			% Documents without version control that exist have version 0.
			%
			% V will be an array of integers with all version numbers. If there are no
			% documents that match DOC_UNIQUE_ID, then empty is returned.
			% 
				v = [];
				fname = dumbjsondb.uniqueid2filename(doc_unique_id,0);
				fnamesearch = strrep(fname, '00000', '*');
				fnamescanf  = strrep(fname, '00000', '%s');
				p = dumbjsondb_obj.documentpath();
				d = dir([p fnamesearch]);
				for i=1:numel(d),
					mystr = sscanf(d(i).name, fnamescanf);
					if ~isempty(mystr),
						v_string = mystr(1:end-5); % drop extension
						v(end+1) = hex2dec(v_string);
					end
				end
		end % docversions()

		function [L,v] = latestdocversion(dumbjsondb_obj, doc_unique_id)
			% LATESTDOCVERSION - return most recent documnet version number
			%
			% [L, V] = LATESTDOCVERSION(DUMBJSONDB_OBJ, DOC_UNIQUE_ID)
			%
			% Return the latest version (L) of the document with the document unique ID equal to 
			% DOC_UNIQUE_ID. A full array of available version numbers V is also returned.
			% If there are no versions, L is empty.
			%
			% See also: DUMBJSONDB/DOCVERSIONS
			%
				v = dumbjsondb_obj.docversions(doc_unique_id);
				if ~isempty(v),
					L = max(v);
				else,
					L = [];
				end;
		end % latestdocversion()

		function [doc_unique_id] = docstats(dumbjsondb_obj, document_obj)
			% DOCSTATS - document stats including document version and whether or not the document has a binary file
			%
			% [DOC_UNIQUE_ID, DOCBINARYFILE] = DOCSTATS(DUMBJSONDB_OBJ, DOCUMENT_OBJ)
			%
			% Returns several pieces of information about the Matlab structure/object DOCUMENT_OBJ:
			%
			% DOC_UNIQUE_ID is the document unique id (specified in the property 'document_unique_id' of
			%      DUMBJSONDB_OBJ).
			% DOCBINARYFILE is 1 if and only if DOC has the field specified in property 'hasbinaryfilefield'
			%      and the value is 1; otherwise DOCBINARYFILE is 0.
			%
				doc_unique_id = eval(['document_obj.' dumbjsondb_obj.unique_object_id_field ';']);
				doc_unique_id = dumbjsondb.fixdocuniqueid(doc_unique_id);
		end %docstats()

	end; % public methods

	methods (Access=protected) % only available to subclasses

		function writeobject(dumbjsondb_obj, doc_object, doc_unique_id, doc_version)
			% WRITEOBJECT - write an object to the database, called by add (also overwrites)
			%
			% WRITEOBJECT(DUMBJSONDB_OBJ, DOC_OBJECT, DOC_UNIQUE_ID, DOC_VERSION)
			%
			% Writes the object data for DOC_OBJECT to disk. DOC_UNIQUE_ID and DOC_VERSION specify
			% the document unique id and document version, respectively. Overwrites any existing files.
			%
				doc_unique_id = dumbjsondb.fixdocuniqueid(doc_unique_id);
				
				% Write a) doc file 
				%       b) meta data (if necessary)
				%       c) create a blank binary file
				
				% a) the doc file
				p = dumbjsondb_obj.documentpath();
                if ~exist(p,'dir'), 
                    mkdir(p);
                end;
				docfile = dumbjsondb.uniqueid2filename(doc_unique_id, doc_version);
				dumbjsondb.docobject2file(doc_object, [p docfile]);

				% b) the meta data file

				dumbjsondb_obj.updatedocmetadata('Added new version', doc_object, doc_unique_id, doc_version);

				% c) the binary file

				% just touch the file and leave it blank
				fb = dumbjsondb.uniqueid2binaryfilename(doc_unique_id, doc_version);
				fid=fopen([p fb],'w');
				fclose(fid);

		end % writeobject()

		function updatedocmetadata(dumbjsondb_obj, operation, document, doc_unique_id, doc_version)
			% UPDATEDOCMETADATA - Update the metadata file(s) given that we just wrote or removed a document
			%
			% UPDATEDOCMETADATA(DUMBJSONDB_OBJ, OPERATION, DOCUMENT, DOC_UNIQUE_ID, DOC_VERSION)
			%
			% Updates the metadata file(s) given that we just wrote or removed a document from the database.
			% DOCUMENT is the Matlab object that was just written (can be empty if removed), DOC_UNIQUE_ID 
			% is the document unique ID, DOC_VERSION is the version that was just manupulated.
			% OPERATION can be one of the following entries:
			% Value                 | Description
			% -------------------------------------------------------------------------------------------
			% 'Added new version'   | Write a new metadata file with the latest version
			% 'Overwrote version'   | Update the metadata file with the latest version
			% 'Deleted version'     | Write a new metadata file that contains correct latest version number
			% 'Deleted all versions'| Remove the metadata file
			%
			% In the future, it is expected that subclass databases may override this function to store more
			% types of metadata to ease or speed searching.
			%
				p = dumbjsondb_obj.documentpath();
				metafile = [p dumbjsondb.uniqueid2metafilename(doc_unique_id)];

				switch(lower(operation)),
					case lower('Added new version'),
						% we need to write or update the metadata file with the latest version
						str2text(metafile,mat2str(doc_version));
					case lower('Overwrote version'),
						% we don't need to do anything, but subclasses might
					case lower('Deleted version'), % need to add the max version
						v = dumbjsondb_obj.docversions(doc_unique_id);
						if numel(v)>0, % we have a version
							str2text(metafile,mat2str(max(v)));
						else,
							if exist(metafile,'file'),
								delete(metafile);
							end;
						end;
					case lower('Deleted all versions'), 
						% if we know we deleted all versions, then we need to delete the metadata file
						if exist(metafile,'file'),
							delete(metafile);
						end;
					otherwise, 
						error(['Unknown request.']);
				end

		end % updatedocmetadata

		function [p] = documentpath(dumbjsondb_obj)
			% DOCUMENTPATH - return the document path for a DUMBJSONDB
			%
			% P = DOCUMENTPATH(DUMBJSONDB_OBJ)
			%
			% Return the the full directory path to a DUMBJSONDB object. Ends in a 
			% file separator.
			%
				p = [dumbjsondb_obj.path() filesep dumbjsondb_obj.dirname filesep];
		end % documentpath()

		function p = path(dumbjsondb_obj)
			% PATH - the pathname of the paramfile for a DUMBJSONDB_OBJ
			%
			% P = PATH(DUMBJSONDB_OBJ)
			%
			% Returns the file path for the parameter file.
			%
				p = fileparts(dumbjsondb_obj.paramfilename);
		end % path()

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

	end % methods protected

	methods (Static=true, Access=protected)

		function docobject2file(doc_object, filename)
			% DOCOBJECT2FILE - write a document object to a file
			%
			% DOCOBJECT2FILE(DOC_OBJECT, FILENAME)
			%
			% Encodes and writes the DOCOBJECT to FILENAME.
			%
			% In DUMBJSONDB class, this simply encodes the Matlab object
			% DOCOBJECT in JSON using JSONENCODENAN.
			%
				% encode the document 
				js = jsonencodenan(doc_object);
				try,
					str2text([filename], js);
				catch,
					error(['Could not write to file ' [filename ] '; ' lasterr '.']);
				end
		end % docobject2file()

		function doc_object = file2docobject(filename)
			% FILE2DOCOBJECT - read a document object from a file
			%
			% DOC_OBJECT = FILE2DOCOBJECT(FILENAME)
			%
			% Reads the contents of FILENAME and decodes the object.
			% FILENAME should be a full path file name.
			%
			% In DUMBJSONDB class, this simply reads the file as text and
			% decodes it using JSONDECODE. If FILENAME does not exist, then
			% DOC_OBJECT is empty ([]).
			%
				if exist(filename,'file')
					t = textfile2char([p f]); 
					doc_object = jsondecode(t);
				else,
					doc_object = [];
				end
		end % file2docobject
			
		function f = uniqueid2filenameprefix(doc_unique_id)
			% UNIQUEID2FILENAMEPREFIX - return the beginning of the file name for document data/metadata
			%
			% F = UNIQUEID2FILENAMEPREFIX(DOC_UNIQUE_ID)
			%
			% Return the beginning filename for a document given its DOC_UNIQUE_ID.  
			% The filename contains the the DOC_UNIQUE_ID converted to a valid file name 
			% using STRING2FILESTRING.
			%
			% F is therefore ['Object_id_' CONVERTED_DOC_UNIQUE_ID]
			%
			% See also: DUMBJSONDB/UNIQUEID2FILENAME, DUMBJSONDB/UNIQUEID2BINARYFILENAME, ...
			%    DUMBJSONDB/UNIQUEID2METAFILENAME, STRING2FILESTRING
			%
				doc_unique_id = dumbjsondb.fixdocuniqueid(doc_unique_id);
				f = string2filestring(doc_unique_id);
				f = ['Object_id_' f];
		end % uniqueid2filenameprefix

		function f = uniqueid2metafilename(doc_unique_id)
			% UNIQUEID2METAFILENAME - return the meta file name for a document in DUMBJSONDB
			%
			% F = UNIQUE2METAFILENAME(DOC_UNIQUE_ID)
			%
			% Return the meta filename for a document given its DOC_UNIQUE_ID.  
			% The filename contains the the DOC_UNIQUE_ID converted to a valid file name 
			% using STRING2FILESTRING. The file extension is '.txt'.
			%
			% F is therefore ['Object_id_' CONVERTED_DOC_UNIQUE_ID '.txt' ];
			%
			% See also: DUMBJSONDB/UNIQUEID2FILENAME, DUMBJSONDB/UNIQUEID2BINARYFILENAME, DUMBJSONDB/UNIQUEID2FILENAMEPREFIX
			%
				f = [dumbjsondb.uniqueid2filenameprefix(doc_unique_id) '.txt'];
		end % uniqueid2metafilename()

		function f = uniqueid2filename(doc_unique_id, version)
			% UNIQUEID2FILENAME - return the filename for a document given its unique id
			%
			% F = UNIQUEID2FILENAME(DOC_UNIQUE_ID[, VERSION])
			%
			% Return the filename for a document given its DOC_UNIQUE_ID.  
			% The filename contains the the DOC_UNIQUE_ID converted to a valid file name 
			% using STRING2FILESTRING and the VERSION number  '_v#' is appended, where
			% '#' is the hexadecimal VERSION with 5 digits. The file extension is '.json'.
			%
			% F is therefore ['Object_id_' HEXSTRING_DOC_UNIQUE_ID '_v#####.json'];
			%
			% If VERSION is not specified, it is assumed to be 0.
			%
			% See also: DUMBJSONDB/UNIQUEID2FILENAME, DUMBJSONDB/UNIQUEID2METAFILENAME, DUMBJSONDB/UNIQUEID2FILENAMEPREFIX
			%
				f = dumbjsondb.uniqueid2filenameprefix(doc_unique_id);
				if nargin<2,
					version = 0;
				end;
				if isempty(version),
					version = 0;
				end;
				if version > hex2dec('FFFFF'),
					error(['Version number requested (' num2str(version) ') is larger than max: ' num2str(hex2dec('FFFFF')) '.']);
				end
				f = [f '_v' dec2hex(version,5) '.json'];
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
		end; % readparameters

		function doc_unique_id = fixdocuniqueid(doc_unique_id)
			% FIXDOCUNIQUEID - make sure document unique id is a string
			%
			% DOC_UNIQUE_ID = FIXDOCUNIQUEID(DOC_UNIQUE_ID)
			%
			% If DOC_UNIQUE_ID is a number, it is turned into a string.
			%
				if isnumeric(doc_unique_id),
					doc_unique_id = mat2str(doc_unique_id);
				end;
		end; % fixdocuniqueid()

		function b = ismatch(document, searchParams)
			% ISMATCH - is a document a match for the search parameters?
			%
			% B = ISMATCH(DOCUMENT, SEARCHPARAMS)
			%
			% Examines the fields of DOCUMENT to determine if there is a match.
				if isstruct(searchParams),
					b = fieldsearch(struct(document),searchParams);
					return;
				end;
				b = 1;
				for i=1:2:numel(searchParams),
					hasit = 0;
					try,
						value = eval(['document.' searchParams{i} ';']);
						hasit = 1;
					end;
					
					if hasit,
						% keep checking for matches
						if ischar(searchParams{i+1}), % it is a regular expression
							if ischar(value),
								test = regexpi(value, searchParams{i+1}, 'forceCellOutput');
								if isempty(test{1}), % we do not have a match
									b = 0;
								end;
							else, % value isn't even a string
								b = 0;
							end;
						else, % we need an exact match
							if ~eqlen(value,searchParams{i+1}),
								b = 0;
							end;
						end;
					else, % we don't even have the field
						b = 0;
					end;
					if ~b,
						break;
					end;
                                end;
		end % ismatch()

	end; % methods (Static, protected)

end % classdef dumbjsondb
