# CLASS vlt.file.dumbjsondb

```
  vlt.file.dumbjsondb - a very simple and slow JSON-based database with associated binary files
 
  DUMBJSONDB implements a very simple JSON-based document database. Each document is
  represented as a JSON file. Each document also has an associated binary file that can
  be read/written. The search capabilities of DUMBJSONDB are very rudimentory, and every
  document is read in for examination. Therefore, searching DUMBJSONDB will be very slow.
  Furthermore, as all of the documents are stored in a single directory, the database size
  will be limited to the number of files that are permitted in a single directory by the
  file system divided by 3 (there is a .JSON file, a binary file, and a metadata file for
  each document). 
 
  Example: Create and test a DUMBJSONDB object in the current directory.
      % create a new db
      db = vlt.file.dumbjsondb('new',[pwd filesep 'mydb.json']);
 
      % add some new entries
      for i=1:5,
          a.id = 2000+i;
          a.value = i;
          db.add(a);
      end;
      
      % read latest version of all the entries
      ids = db.alldocids;
      for i=1:numel(ids), 
           db.read(ids{i}), % display the entry
      end
 
      % search for a document
      [docs,doc_versions] = db.search({},{'value',5})
      % search for a document that doesn't exist because '5' is a string
      [docs,doc_versions] = db.search({},{'value','5'})
      % use the struct version of search
      [docs,doc_versions] = db.search({},struct('field','value','operation','greaterthan','param1',1,'param2',[]))
       
      % remove an entry
      db.remove(2002);
 
      % update 2005 to new version, saving old version
      a.value = 20;
      db.add(a,'Overwrite',2); % will automatically update version number
 
      % read first and latest version of all the entries
      ids = db.alldocids;
      for i=1:numel(ids), 
           disp(['0th version:']);
           db.read(ids{i},0), % display the 0th version
           disp(['Latest version:']);
           db.read(ids{i}), % display the entry
      end
 
      % add binary information to binary file
      [fid,key] = db.openbinaryfile(2005);
      if fid>0,
           fwrite(fid,'this is a test','char');
           [fid] = db.closebinaryfile(fid, key, 2005);
      end
      % read the binary file
      [fid, key] = db.openbinaryfile(2005);
      if fid>0,
           fseek(fid,0,'bof'); % go to beginning of file
           output=char(fread(fid,14,'char'))',
           [fid] = db.closebinaryfile(fid, key, 2005);
      end
 
      % remove all entries
      db.clear('Yes');


```
## Superclasses
*none*

## Properties

| Property | Description |
| --- | --- |
| *paramfilename* | The full pathname of the parameter file |
| *dirname* | The directory name where files are stored (same directory as parameter file) |
| *unique_object_id_field* | The field of each object that indicates the unique ID for each database entry |


## Methods 

| Method | Description |
| --- | --- |
| *add* | add a document to a DUMBJSONDB |
| *alldocids* | return all doc unique id numbers for a DUMBJSONDB |
| *clear* | remove/delete all records from a DUBMJSONDB |
| *closebinaryfile* | close and unlock the binary file associated with a DUMBJSONDB document |
| *docstats* | document stats including document version and whether or not the document has a binary file |
| *docversions* | find all document versions for a DUMBJSONDB |
| *dumbjsondb* | create a DUMBJSONDB object |
| *latestdocversion* | return most recent documnet version number |
| *openbinaryfile* | return the FID for the binary file associated with a DUMBJSONDB document |
| *read* | READ the JSON document corresponding to a particular document unique id |
| *remove* | REMOVE or delete the JSON document corresponding to a particular document unique id |
| *search* | perform a search of DUMBJSONDB documents |


### Methods help 

**add** - *add a document to a DUMBJSONDB*

```
DUMBJSONDB_OBJ = ADD(DUMBJSONDB_OBJ, DOC_OBJECT, ....)
 
  Add a document to the database DUMBJSONDB_OBJ.
 
  DOC_OBJECT should be a Matlab object. It will be encoded to a JSON
  representation and saved.
 
  This function also accepts name/value pairs that modify the adding behavior:
  Parameter (default)           | Description
  ---------------------------------------------------------------------------
  'Overwrite' (1)               | Use 1 to overwrite current version
                                |   0 to return an error instead of overwriting
                                |   2 to add the document as a new version
  'doc_version' (latest)        | Use a specific number to write a specific version
 
  See also: DUMBJSONDB, DUMBJSONDB/READ, DUMBJSONDB/REMOVE, DUMBJSONDB/DOCVERSIONS, DUMBJSONDB/ALLDOCIDS
```

---

**alldocids** - *return all doc unique id numbers for a DUMBJSONDB*

```
DOC_UNIQUE_ID = ALLDOCIDS(DUMBJSONDB_OBJ)
 
  Return a cell array of all document unique ID(s) (char strings) for the
  DUMBJSONDB object DUMBJSONDB_OBJ.
```

---

**clear** - *remove/delete all records from a DUBMJSONDB*

```
CLEAR(DUMBJSONDB_OBJ, [AREYOUSURE])
 
  Removes all documents from the DUMBJSONDB object.
  
  Use with care. If AREYOUSURE is 'yes' then the
  function will proceed. Otherwise, it will not.
 
  See also: DUMBJSONDB/REMOVE
```

---

**closebinaryfile** - *close and unlock the binary file associated with a DUMBJSONDB document*

```
[FID] = CLOSEBINARYFILE(DUMBJSONDB_OBJ, FID, KEY, DOC_UNIQUE_ID, [DOC_VERSION])
 
  Closes the binary file associated with DUMBJSONDB that has file identifier FID,
  DOC_UNIQUE_ID and DOC_VERSION. If DOC_VERSION is not provided, the lastest will be used.
  This function closes the file and deletes the lock file. KEY is the key that is returned
  by OPENBINARYFILE, and is needed to release the lock on the binary file.
 
  FID is set to -1 on exit.
 
  See also: DUMBJSONDB/OPENBINARYFILE, CHECKOUT_LOCK_FILE
 
  if the file is open, close it
```

---

**docstats** - *document stats including document version and whether or not the document has a binary file*

```
[DOC_UNIQUE_ID, DOCBINARYFILE] = DOCSTATS(DUMBJSONDB_OBJ, DOCUMENT_OBJ)
 
  Returns several pieces of information about the Matlab structure/object DOCUMENT_OBJ:
 
  DOC_UNIQUE_ID is the document unique id (specified in the property 'document_unique_id' of
       DUMBJSONDB_OBJ).
  DOCBINARYFILE is 1 if and only if DOC has the field specified in property 'hasbinaryfilefield'
       and the value is 1; otherwise DOCBINARYFILE is 0.
```

---

**docversions** - *find all document versions for a DUMBJSONDB*

```
V = DOCVERSIONS(DUMBJSONDB_OBJ, DOC_UNIQUE_ID)
 
  Return all version numbers for a given DUMBJSONDB and a
  DOC_UNIQUE_ID.
 
  Documents without version control that exist have version 0.
 
  V will be an array of integers with all version numbers. If there are no
  documents that match DOC_UNIQUE_ID, then empty is returned.
```

---

**dumbjsondb** - *create a DUMBJSONDB object*

```
DUMBJSONDB_OBJ = DUMBJSONDB(COMMAND, ...)
 
  Create a DUMBJSONDB object via one of several routes.
 
  COMMAND options            | Description
  ----------------------------------------------------------------------------------------
  'Load'                     | Second argument should be full path filename of the saved parameter file
  'New'                      | Second argument should be full path filename of the saved parameter file, 
  (None)                     | Creates an empty object.
 
  This file also accepts additional name/value pairs for arguments 3..end. 
  Parameter (default)           | Description
  ----------------------------------------------------------------------------------------
  dirname ('.dumbjsondb')       | The directory name, relative to the parameter file
  unique_object_id_field ('id') | The field name in the database for the unique object identifier 
 
  See also: DUMBJSONDB, DUMBJSONDB/READ, DUMBJSONDB/REMOVE, DUMBJSONDB/DOCVERSIONS, DUMBJSONDB/ALLDOCIDS

    Documentation for vlt.file.dumbjsondb/dumbjsondb
       doc vlt.file.dumbjsondb
```

---

**latestdocversion** - *return most recent documnet version number*

```
[L, V] = LATESTDOCVERSION(DUMBJSONDB_OBJ, DOC_UNIQUE_ID)
 
  Return the latest version (L) of the document with the document unique ID equal to 
  DOC_UNIQUE_ID. A full array of available version numbers V is also returned.
  If there are no versions, L is empty.
 
  See also: DUMBJSONDB/DOCVERSIONS
```

---

**openbinaryfile** - *return the FID for the binary file associated with a DUMBJSONDB document*

```
[FID, KEY, DOC_VERSION] = OPENBINARYFILE(DUMBJSONDB_OBJ, DOC_UNIQUE_ID[, DOC_VERSION])
 
  Attempts to obtain the lock and open the binary file associated with
  DOC_UNIQUE_ID and DOC_VERSION for reading/writing. If DOC_VERSION is not present,
  then the lastest version is used. All the binary files are in 'big-endian' format and 
  are opened as such by OPENBINARYFILE. 
 
  If there is no such file, an error is generated. If the file is locked by another program,
  then FID is -1.
 
  File lock is achieved using CHECKOUT_LOCK_FILE. The lock file must be closed and deleted
  after FID is closed so that other programs can use the file. This service is performed by
  CLOSEBINARYFILE.
 
  KEY is a random key that is needed to close the file (releases the lock).
 
  Example:
       [fid, key]=mydb.openbinaryfile(doc_unique_id);
       if fid>0,
           try, 
               % do something, e.g., fwrite(fid,'my data','char'); 
               [fid] = mydb.closebinaryfile(fid, key, doc_unique_id);
           catch, 
               [fid] = mydb.closebinaryfile(fid, key, doc_unique_id);
               error(['Could not do what I wanted to do.'])
           end
       end
       
 
  See also: DUMBJSONDB/CLOSEBINARYFILE, DUMBJSONDB/READ, CHECKOUT_LOCK_FILE, FREAD, FWRITE
```

---

**read** - *READ the JSON document corresponding to a particular document unique id*

```
[DOCUMENT, VERSION] = READ(DUMBJSONDB_OBJ, DOC_UNIQUE_ID[, VERSION])
 
  Reads and decodes the document corresponding to the document unique id
  DOC_UNIQUE_ID.
 
  If VERSION is provided, then the requested version is read. If it is not
  provided, then the latest version is provided. VERSION can be between 0 and
  hex2dec('FFFFF').
 
  DOCUMENT is the Matlab object generated by the decoded JSON file. VERSION is the
  actual version that was read. If there is no such document, then DOCUMENT and VERSION
  will be empty ([]).
 
  See also: DUMBJSONDB, DUMBJSONDB/ADD, DUMBJSONDB/REMOVE, DUMBJSONDB/DOCVERSIONS, DUMBJSONDB/ALLDOCIDS
```

---

**remove** - *REMOVE or delete the JSON document corresponding to a particular document unique id*

```
DUMBJSONDB_OBJ = REMOVE(DUMBJSONDB_OBJ, DOC_UNIQUE_ID, VERSION)
 
  Removes the document corresponding to the document unique id
  DOC_UNIQUE_ID and version VERSION.
 
  If VERSION is provided, then the requested version is removed. If it is not
  provided, or is equal to the string 'all', then ALL versions are deleted.
 
  See also: DUMBJSONDB/CLEAR
```

---

**search** - *perform a search of DUMBJSONDB documents*

```
[DOCS, DOC_VERSIONS] = SEARCH(DUMBJSONDB_OBJ, SCOPE, SEARCHPARAMS)
 
  Performs a search of DUMBJSONDB_OBJ to find matching documents.
 
  SCOPE is a cell array of name/value pairs that modify the search
  scope:
  SCOPE parameter (default)    : Description
  ----------------------------------------------------------------------
  version ('latest')           : Which versions should be searched? Can be
                               :   a specific number, 'latest', or 'all'
 
  SEARCHPARAMS should be either be {'PARAM1', VALUE1, 'PARAM2', VALUE2, ... }
   or a search structure appropriate for FIELDSEARCH.
 
  The document parameters PARAM1, PARAM2 are examined for matches.
  If VALUEN is a string, then a regular expression
  is evaluated to determine the match. If valueN is not a string, then the
  the items must match exactly.
 
  DOCS is a cell array of JSON-decoded documents. DOC_VERSIONS is an array of
  the corresponding document versions.
 
  Case is not considered.
 
  Examples:
       indexes = search(mydb, 'type','nsd_spikedata');
       indexes = search(mydb, 'type','nsd_spike(*.)');
 
  See also: REGEXPI
```

---

