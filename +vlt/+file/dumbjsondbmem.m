classdef dumbjsondbmem < vlt.file.dumbjsondb
	% vlt.file.dumbjsondbmem - a very simple and slow JSON-based database with associated binary files, with database kept in memory
	%
	% DUMBJSONDBMEM implements a very simple JSON-based document database. Each document is
	% represented as a JSON file. Each document also has an associated binary file that can
	% be read/written. The search capabilities of DUMBJSONDBMEM are very rudimentory, and every
	% document is read in for examination. Therefore, searching DUMBJSONDBMEM will be very slow.
	% Furthermore, as all of the documents are stored in a single directory, the database size
	% will be limited to the number of files that are permitted in a single directory by the
	% file system divided by 3 (there is a .JSON file, a binary file, and a metadata file for
	% each document). 
	%
	% Example: Create and test a DUMBJSONDBMEM object in the current directory.
	%     % create a new db
	%     db = vlt.file.dumbjsondbmem('new',[pwd filesep 'mydb.json']);
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
		cache_key % A key to vlt.cache for the document data stored in memory
	end % properties

	methods
		function dumbjsondbmem_obj = dumbjsondbmem(varargin)
			% DUMBJSONDBMEM - create a DUMBJSONDBMEM object
			%
			% DUMBJSONDBMEM_OBJ = vlt.data.dumbjsondbmem(COMMAND, ...)
			%
			% Create a vlt.data.dumbjsondbmem object via one of several routes.
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
				if numel(varargin)>1,
					if strcmpi(varargin{1},'New'),
						serial_date_number = convertTo(datetime('now','TimeZone','UTCLeapSeconds'),'datenum');
						random_number = rand + randi([-32727 32727],1);
						id = [num2hex(serial_date_number) '_' num2hex(random_number)];

						dumbjsondbmem_obj.cache_key = ['dumbjsondbmem-' id];
					end;
				end;
				dumbjsondbmem_obj = dumbjsondbmem_obj@dumbjsondb(varargin);
		end % dumbjsondb()

		function doc = loadfromdisk(dumbjsondbmem_obj)
			% LOADFROMDISK - load all the JSON documents from disk into memory
			%
			% DOC = LOADFROMDISK(DUMBJSONDBMEM_OBJ)
			%
			% Load all of the documents from the database into the cell array DOC.
			%
			%
				doc = vlt.data.emptystruct('doc_unique_id','versions');

				docids = dumbjsondb_obj.alldocids();

				for i=1:numel(docids),
					v_here = dumbjsondb_obj.docversions(docids{i});
					doc_entry.doc_uniqe_id = doc_unique_id;
					doc_entry.versions = {};
					for j=1:numel(v_here),
						[doc_here, version_here] = dumbjsondb_obj.read(docids{i},v_here(j));
						doc_entry.versions{version_here} = doc_here;
						doc(end+1) = doc_entry;
					end;
				end
		end; % loadfromdisk()

		function docs = documents(dumbjsondbmem_obj)
			% DOCUMENTS - load documents from the cache
			%
			%
			%
				vlt.globals;
				cache = vlt_globals.cache;
				doc_table = cache.lookup(dumbjsondbmem_obj.cache_key,'dumbjsondbmem_documents');
				if ~isempty(doc_table),
					docs = doc_table(1).data.documents;
				else,
					docs = dumbjsondbmem_obj.loadfromdisk();
					dumbjsondbmem_obj.documents2cache(docs);
				end;

		end; % documents

		function documents2cache(dumbjsondbmem_obj, documents)
			% DOCUMENTS2CACHE - send documents to the cache
			%
			%
				vlt.globals;
				cache = vlt_globals.cache;
				priority = 1; % greater than normal priority
				cache.add(dumbjsondbmem_obj.cache_key, 'dumbjsondbmem_documents',documents,priority);
		end; % documents2cache 


		function dumbjsondbmem_obj = add(dumbjsondbmem_obj, doc_object, varargin)
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
				[dumbjsondbmem_obj,addAction] = add@vlt.file.dumbjsondb(dumbjsondbmem_obj, doc_object, varargin{:});
				
				if addAction.wrote,
					docs = dumbjsondbmem_obj.documents();
					index = strcmp(addAction.doc_unique_id,{docs});
					if ~isempty(index),
						docs(index).versions{addAction.doc_version} = addAction.doc_object_json;
					else,
						newstruct.doc_unique_id = addAction.doc_unique_id;
						newstruct.versions = {};
						newstruct.versions{addAction.doc_version} = addAction.doc_object_json;
						docs(end+1) = newstruct;
					end;
					dumbjsondbmem_obj.documents2cache(docs);
				end;
		end % add()

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
				vlt.data.assign(scope{:});

				documents = dumbjsondbmem_obj.documents();

				for i=1:numel(documents),
					if strcmp(version,'latest'),
						vers = numel(documents{i});
					elseif strcmp(version,'all'),
						vers = 1:numel(documents{i});
					else,
						vers = version;
					end;
					for version_here=vers,
						b = vlt.file.dumbjsondb.ismatch(documents{i}{version_here}, searchParams);
						if b,
							docs{end+1} = doc_here;
							doc_versions(end+1) = version_here;
						end; 
					end;
				end;
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

				% pass to superclass to remove actual file
				dumbjsondbmem_obj = remove@vlt.file.dumbjsondb(dumbjsondbmem_obj, doc_unique_id, version);

				% now see how we have to edit the record in memory

				documents = dumbjsondbmem_obj.documents();

				index = find(strcmp(doc_unique_id,{documents.doc_unique_id}));
				if isempty(index),
					return; % nothing to do
				end;

				if strcmp(lower(version),'all'),
					documents = documents([1:index-1 index+1:end]);
				else, % specific versions listed
					versions_here = ~(cellfun(@isempty,documents(index).versions));
					versions_left = setdiff(versions_here,version);
					if numel(versions_left)==0, % all versions removed
						documents = documents([1:index-1 index+1:end]);
					else,
						documents(index).versions = documents(index).versions(versions_left);
					end;
				end;
				dumbjsondbmem_obj.documents2cache(documents); 
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

	end; % public methods

end % classdef dumbjsondb
