# CLASS vlt.file.fileobj

```
 vlt.file.fileobj - a Matlab binary file object; an interface to fopen, fread, fwrite, fseek, fclose, ftell
 
  This is an object interface to fopen, fread, fwrite, fseek, fclose, and ftell. Why do this?
  One could imagine one day separating the process of reading and writing a data stream from the file
  system. For example, one could write to GRIDFS by overriding these functions, and the user's code
  would never have to know.


```
## Superclasses
**handle**

## Properties

| Property | Description |
| --- | --- |
| *fullpathfilename* |  |
| *fid* |  |
| *permission* |  |
| *machineformat* | 'big-endian' or 'little-endian' |


## Methods 

| Method | Description |
| --- | --- |
| *addlistener* | ADDLISTENER  Add listener for event. |
| *delete* | delete a FILEOBJ_OBJ, closing file first if need be |
| *eq* | == (EQ)   Test handle equality. |
| *fclose* | close a FILEOBJ |
| *feof* | test to see if a FILEOBJ is at END-OF-FILE |
| *ferror* | return the last file error message for FILEOBJ |
| *fgetl* | get a line from a FILEOBJ |
| *fgets* | get a line from a FILEOBJ |
| *fileobj* | create a new binary file object |
| *fileparts* | return filename parts for the file associated with FILEOBJ |
| *findobj* | FINDOBJ   Find objects matching specified conditions. |
| *findprop* | FINDPROP   Find property of MATLAB handle object. |
| *fopen* | open a FILEOBJ |
| *fprintf* | print data to a FILEOBJ_OBJ |
| *fread* | read data from a FILEOBJ |
| *frewind* | 'rewind' a FILEOBJ back to the beginning |
| *fscanf* | scan data from a FILEOBJ_OBJ |
| *fseek* | seek to a location within a FILEOBJ |
| *ftell* | find current location within a FILEOBJ |
| *fwrite* | write data to a FILEOBJ |
| *ge* | >= (GE)   Greater than or equal relation for handles. |
| *gt* | > (GT)   Greater than relation for handles. |
| *isvalid* | ISVALID   Test handle validity. |
| *le* | <= (LE)   Less than or equal relation for handles. |
| *listener* | LISTENER  Add listener for event without binding the listener to the source object. |
| *lt* | < (LT)   Less than relation for handles. |
| *ne* | ~= (NE)   Not equal relation for handles. |
| *notify* | NOTIFY   Notify listeners of event. |
| *setproperties* | set the properties of a FILEOBJ |


### Methods help 

**addlistener** - *ADDLISTENER  Add listener for event.*

```
el = ADDLISTENER(hSource, Eventname, callbackFcn) creates a listener
    for the event named Eventname.  The source of the event is the handle 
    object hSource.  If hSource is an array of source handles, the listener
    responds to the named event on any handle in the array.  callbackFcn
    is a function handle that is invoked when the event is triggered.
 
    el = ADDLISTENER(hSource, PropName, Eventname, Callback) adds a 
    listener for a property event.  Eventname must be one of
    'PreGet', 'PostGet', 'PreSet', or 'PostSet'. Eventname can be
    a string scalar or character vector.  PropName must be a single 
    property name specified as string scalar or character vector, or a 
    collection of property names specified as a cell array of character 
    vectors or a string array, or as an array of one or more 
    meta.property objects.  The properties must belong to the class of 
    hSource.  If hSource is scalar, PropName can include dynamic 
    properties.
    
    For all forms, addlistener returns an event.listener.  To remove a
    listener, delete the object returned by addlistener.  For example,
    delete(el) calls the handle class delete method to remove the listener
    and delete it from the workspace.
 
    ADDLISTENER binds the listener's lifecycle to the object that is the 
    source of the event.  Unless you explicitly delete the listener, it is
    destroyed only when the source object is destroyed.  To control the
    lifecycle of the listener independently from the event source object, 
    use listener or the event.listener constructor to create the listener.
 
    See also LISTENER, EVENT.LISTENER, VLT.FILE.FILEOBJ, NOTIFY, DELETE, META.PROPERTY, EVENTS

Help for vlt.file.fileobj/addlistener is inherited from superclass handle

    Documentation for vlt.file.fileobj/addlistener
       doc handle/addlistener
```

---

**delete** - *delete a FILEOBJ_OBJ, closing file first if need be*

```
DELETE(FILEOBJ_OBJ)
 
  Deletes the handle FILEOBJ_OBJ. If the file (FILEOBJ_OBJ.fid) is open,
  it is closed first.
 
  See also: HANDLE/DELETE, FILEOBJ/FCLOSE
```

---

**eq** - *== (EQ)   Test handle equality.*

```
Handles are equal if they are handles for the same object.
 
    H1 == H2 performs element-wise comparisons between handle arrays H1 and
    H2.  H1 and H2 must be of the same dimensions unless one is a scalar.
    The result is a logical array of the same dimensions, where each
    element is an element-wise equality result.
 
    If one of H1 or H2 is scalar, scalar expansion is performed and the 
    result will match the dimensions of the array that is not scalar.
 
    TF = EQ(H1, H2) stores the result in a logical array of the same 
    dimensions.
 
    See also VLT.FILE.FILEOBJ, VLT.FILE.FILEOBJ/GE, VLT.FILE.FILEOBJ/GT, VLT.FILE.FILEOBJ/LE, VLT.FILE.FILEOBJ/LT, VLT.FILE.FILEOBJ/NE

Help for vlt.file.fileobj/eq is inherited from superclass handle
```

---

**fclose** - *close a FILEOBJ*

```
FILEOBJ_OBJ = FCLOSE(FILEOBJ_OBJ)
 
  Close a file associated with a FILEOBJ.
 
  Attempt to close the file and then set FILEOBJ_OBJ.fid to -1.
```

---

**feof** - *test to see if a FILEOBJ is at END-OF-FILE*

```
B = FEOF(FILEOBJ_OBJ)
 
  Returns 1 if FILEOBJ_OBJ is at its end of file, 0 otherwise.
 
  See also: FSEEK, FILEOBJ/FSEEK, FTELL
```

---

**ferror** - *return the last file error message for FILEOBJ*

```
[MESSAGE, ERRORNUM] = FERROR(FILEOBJ_OBJ, COMMAND)
 
  Return the most recent file error MESSAGE and ERRORNUM for
  the file associated with FERROR.
```

---

**fgetl** - *get a line from a FILEOBJ*

```
TLINE = FGETL(FILEOBJ_OBJ)
 
  Returns the next line (not including NEWLINE character) just like FGETL.
 
  See also: FGETL
```

---

**fgets** - *get a line from a FILEOBJ*

```
TLINE = FGETS(FILEOBJ_OBJ, [NCHAR])
 
  Returns the next line (including NEWLINE character) just like FGETS.
 
  See also: FGETS
```

---

**fileobj** - *create a new binary file object*

```
FILEOBJ_OBJ = FILEOBJ(...)
 
  Creates an empty FILEOBJ object. If FILENAME is provided,
  then the filename is stored.

    Documentation for vlt.file.fileobj/fileobj
       doc vlt.file.fileobj
```

---

**fileparts** - *return filename parts for the file associated with FILEOBJ*

```
[PATHSTR,NAME,EXT] = FILEPARTS(FILEOBJ_OBJ)
 
  Returns FILEPARTS of the 'fullpathfilename' field of FILEOBJ.
```

---

**findobj** - *FINDOBJ   Find objects matching specified conditions.*

```
The FINDOBJ method of the HANDLE class follows the same syntax as the 
    MATLAB FINDOBJ command, except that the first argument must be an array
    of handles to objects.
 
    HM = FINDOBJ(H, <conditions>) searches the handle object array H and 
    returns an array of handle objects matching the specified conditions.
    Only the public members of the objects of H are considered when 
    evaluating the conditions.
 
    See also FINDOBJ, VLT.FILE.FILEOBJ

Help for vlt.file.fileobj/findobj is inherited from superclass handle

    Documentation for vlt.file.fileobj/findobj
       doc handle/findobj
```

---

**findprop** - *FINDPROP   Find property of MATLAB handle object.*

```
p = FINDPROP(H,PROPNAME) finds and returns the META.PROPERTY object
    associated with property name PROPNAME of scalar handle object H.
    PROPNAME can be a string scalar or character vector.  It can be the 
    name of a property defined by the class of H or a dynamic property 
    added to scalar object H.
   
    If no property named PROPNAME exists for object H, an empty 
    META.PROPERTY array is returned.
 
    See also VLT.FILE.FILEOBJ, VLT.FILE.FILEOBJ/FINDOBJ, DYNAMICPROPS, META.PROPERTY

Help for vlt.file.fileobj/findprop is inherited from superclass handle

    Documentation for vlt.file.fileobj/findprop
       doc handle/findprop
```

---

**fopen** - *open a FILEOBJ*

```
FILEOBJ_OBJ = FOPEN(FILEOBJ_OBJ, [ , PERMISSION], [MACHINEFORMAT],[FILENAME])
 
  Opens the file associated with a FILEOBJ_OBJ object. If FILENAME, PERMISSION, 
  and MACHINEFORMAT are given, then those variables of FILEOBJ_OBJ are updated. If they
  are not given, then the existing values in the FILEOBJ_OBJ are used.
 
  Note that the order of the input arguments differs from FOPEN, so that the object
  can be called in place of an FID (e.g., fid=fopen(myvariable), where myvariable is
  either a file name or a FILEOBJ object).
 
  If the operation is successful, then FILEOBJ_OBJ.fid is greater than 3. Otherwise,
  FILEOBJ_OBJ.fid is -1.
 
  See also: FOPEN, FILEOBJ/FCLOSE, FCLOSE
```

---

**fprintf** - *print data to a FILEOBJ_OBJ*

```
[COUNT] = FPRINTF(FID,FORMAT,A, ...)
 
  Call FPRINTF (see FPRINTF for inputs) for the file associated with
  FILEOBJ_OBJ.
```

---

**fread** - *read data from a FILEOBJ*

```
COUNT = FWRITE(FILEOBJ_OBJ, COUNT, [PRECISION], [SKIP], [MACHINEFORMAT])
 
  Attempts to read COUNT elements with resolution PRECISION. If PRECISION is not 
  provided, then 'char' is assumed. If SKIP is provided, then SKIP is in number of bytes, unless
  PRECISION is in bits, in which case SKIP is in bits. MACHINEFORMAT is the machine format to use.
 
  See FREAD for a full description of these input arguments.
 
  See also: FREAD
```

---

**frewind** - *'rewind' a FILEOBJ back to the beginning*

```
FREWIND(FILEOBJ_OBJ)
 
  Seeks to the beginning of the file.
 
  See also: FSEEK, FILEOBJ/FSEEK, FTELL
```

---

**fscanf** - *scan data from a FILEOBJ_OBJ*

```
[A,COUNT] = FSCANF(FID,FORMAT,[SIZEA])
 
  Call FSCANF (see FSCANF for inputs) for the file associated with
  FILEOBJ_OBJ.
```

---

**fseek** - *seek to a location within a FILEOBJ*

```
B = FSEEK(FILEOBJ_OBJ, OFFSET, REFERENCE)
 
  Seeks the file to the location OFFSET (in bytes) relative to
  REFERENCE. REFERENCE can be 
      'bof' or -1   Beginning of file
      'cof' or  0   Current position in file
      'eof' or  1   End of file
 
  B is 0 on success and -1 on failure.
 
  See also: FSEEK, FILEOBJ/FTELL
```

---

**ftell** - *find current location within a FILEOBJ*

```
LOCATION = FTELL(FILEOBJ_OBJ)
 
  Returns the current location (in bytes) relative to the beginning of the
  file. If the query fails, -1 is returned.
 
  See also: FSEEK, FILEOBJ/FSEEK, FTELL
```

---

**fwrite** - *write data to a FILEOBJ*

```
COUNT = FWRITE(FILEOBJ_OBJ, DATA, [PRECISION], [SKIP], [MACHINEFORMAT])
 
  Attempts to write DATA elements with resolution PRECISION. If PRECISION is not 
  provided, then 'char' is assumed. If SKIP is provided, then SKIP is in number of bytes, unless
  PRECISION is in bits, in which case SKIP is in bits. MACHINEFORMAT is the machine format to use.
 
  See FWRITE for a full description of these input arguments.
 
  See also: FWRITE
```

---

**ge** - *>= (GE)   Greater than or equal relation for handles.*

```
H1 >= H2 performs element-wise comparisons between handle arrays H1 and
    H2.  H1 and H2 must be of the same dimensions unless one is a scalar.
    The result is a logical array of the same dimensions, where each
    element is an element-wise >= result.
 
    If one of H1 or H2 is scalar, scalar expansion is performed and the 
    result will match the dimensions of the array that is not scalar.
 
    TF = GE(H1, H2) stores the result in a logical array of the same 
    dimensions.
 
    See also VLT.FILE.FILEOBJ, VLT.FILE.FILEOBJ/EQ, VLT.FILE.FILEOBJ/GT, VLT.FILE.FILEOBJ/LE, VLT.FILE.FILEOBJ/LT, VLT.FILE.FILEOBJ/NE

Help for vlt.file.fileobj/ge is inherited from superclass handle
```

---

**gt** - *> (GT)   Greater than relation for handles.*

```
H1 > H2 performs element-wise comparisons between handle arrays H1 and 
    H2.  H1 and H2 must be of the same dimensions unless one is a scalar.  
    The result is a logical array of the same dimensions, where each
    element is an element-wise > result.
 
    If one of H1 or H2 is scalar, scalar expansion is performed and the 
    result will match the dimensions of the array that is not scalar.
 
    TF = GT(H1, H2) stores the result in a logical array of the same 
    dimensions.
 
    See also VLT.FILE.FILEOBJ, VLT.FILE.FILEOBJ/EQ, VLT.FILE.FILEOBJ/GE, VLT.FILE.FILEOBJ/LE, VLT.FILE.FILEOBJ/LT, VLT.FILE.FILEOBJ/NE

Help for vlt.file.fileobj/gt is inherited from superclass handle
```

---

**isvalid** - *ISVALID   Test handle validity.*

```
TF = ISVALID(H) performs an element-wise check for validity on the 
    handle elements of H.  The result is a logical array of the same 
    dimensions as H, where each element is the element-wise validity 
    result.
 
    A handle is invalid if it has been deleted or if it is an element
    of a handle array and has not yet been initialized.
 
    See also VLT.FILE.FILEOBJ, VLT.FILE.FILEOBJ/DELETE

Help for vlt.file.fileobj/isvalid is inherited from superclass handle

    Documentation for vlt.file.fileobj/isvalid
       doc handle/isvalid
```

---

**le** - *<= (LE)   Less than or equal relation for handles.*

```
Handles are equal if they are handles for the same object.  All 
    comparisons use a number associated with each handle object.  Nothing
    can be assumed about the result of a handle comparison except that the
    repeated comparison of two handles in the same MATLAB session will 
    yield the same result.  The order of handle values is purely arbitrary 
    and has no connection to the state of the handle objects being 
    compared.
 
    H1 <= H2 performs element-wise comparisons between handle arrays H1 and
    H2.  H1 and H2 must be of the same dimensions unless one is a scalar.
    The result is a logical array of the same dimensions, where each
    element is an element-wise >= result.
 
    If one of H1 or H2 is scalar, scalar expansion is performed and the 
    result will match the dimensions of the array that is not scalar.
 
    TF = LE(H1, H2) stores the result in a logical array of the same 
    dimensions.
 
    See also VLT.FILE.FILEOBJ, VLT.FILE.FILEOBJ/EQ, VLT.FILE.FILEOBJ/GE, VLT.FILE.FILEOBJ/GT, VLT.FILE.FILEOBJ/LT, VLT.FILE.FILEOBJ/NE

Help for vlt.file.fileobj/le is inherited from superclass handle
```

---

**listener** - *LISTENER  Add listener for event without binding the listener to the source object.*

```
el = LISTENER(hSource, Eventname, callbackFcn) creates a listener
    for the event named Eventname.  The source of the event is the handle  
    object hSource.  If hSource is an array of source handles, the listener
    responds to the named event on any handle in the array.  callbackFcn
    is a function handle that is invoked when the event is triggered.
 
    el = LISTENER(hSource, PropName, Eventname, callback) adds a 
    listener for a property event.  Eventname must be one of  
    'PreGet', 'PostGet', 'PreSet', or 'PostSet'. Eventname can be a 
    string sclar or character vector.  PropName must be either a single 
    property name specified as a string scalar or character vector, or 
    a collection of property names specified as a cell array of character 
    vectors or a string array, or as an array of one ore more 
    meta.property objects. The properties must belong to the class of 
    hSource.  If hSource is scalar, PropName can include dynamic 
    properties.
    
    For all forms, listener returns an event.listener.  To remove a
    listener, delete the object returned by listener.  For example,
    delete(el) calls the handle class delete method to remove the listener
    and delete it from the workspace.  Calling delete(el) on the listener
    object deletes the listener, which means the event no longer causes
    the callback function to execute. 
 
    LISTENER does not bind the listener's lifecycle to the object that is
    the source of the event.  Destroying the source object does not impact
    the lifecycle of the listener object.  A listener created with LISTENER
    must be destroyed independently of the source object.  Calling 
    delete(el) explicitly destroys the listener. Redefining or clearing 
    the variable containing the listener can delete the listener if no 
    other references to it exist.  To tie the lifecycle of the listener to 
    the lifecycle of the source object, use addlistener.
 
    See also ADDLISTENER, EVENT.LISTENER, VLT.FILE.FILEOBJ, NOTIFY, DELETE, META.PROPERTY, EVENTS

Help for vlt.file.fileobj/listener is inherited from superclass handle

    Documentation for vlt.file.fileobj/listener
       doc handle/listener
```

---

**lt** - *< (LT)   Less than relation for handles.*

```
H1 < H2 performs element-wise comparisons between handle arrays H1 and
    H2.  H1 and H2 must be of the same dimensions unless one is a scalar.
    The result is a logical array of the same dimensions, where each
    element is an element-wise < result.
 
    If one of H1 or H2 is scalar, scalar expansion is performed and the 
    result will match the dimensions of the array that is not scalar.
 
    TF = LT(H1, H2) stores the result in a logical array of the same 
    dimensions.
 
    See also VLT.FILE.FILEOBJ, VLT.FILE.FILEOBJ/EQ, VLT.FILE.FILEOBJ/GE, VLT.FILE.FILEOBJ/GT, VLT.FILE.FILEOBJ/LE, VLT.FILE.FILEOBJ/NE

Help for vlt.file.fileobj/lt is inherited from superclass handle
```

---

**ne** - *~= (NE)   Not equal relation for handles.*

```
Handles are equal if they are handles for the same object and are 
    unequal otherwise.
 
    H1 ~= H2 performs element-wise comparisons between handle arrays H1 
    and H2.  H1 and H2 must be of the same dimensions unless one is a 
    scalar.  The result is a logical array of the same dimensions, where 
    each element is an element-wise equality result.
 
    If one of H1 or H2 is scalar, scalar expansion is performed and the 
    result will match the dimensions of the array that is not scalar.
 
    TF = NE(H1, H2) stores the result in a logical array of the same
    dimensions.
 
    See also VLT.FILE.FILEOBJ, VLT.FILE.FILEOBJ/EQ, VLT.FILE.FILEOBJ/GE, VLT.FILE.FILEOBJ/GT, VLT.FILE.FILEOBJ/LE, VLT.FILE.FILEOBJ/LT

Help for vlt.file.fileobj/ne is inherited from superclass handle
```

---

**notify** - *NOTIFY   Notify listeners of event.*

```
NOTIFY(H, eventname) notifies listeners added to the event named 
    eventname for handle object array H that the event is taking place. 
    eventname can be a string scalar or character vector.  
    H is the array of handles to the event source objects, and 'eventname'
    must be a character vector.
 
    NOTIFY(H,eventname,ed) provides a way of encapsulating information 
    about an event which can then be accessed by each registered listener.
    ed must belong to the EVENT.EVENTDATA class.
 
    See also VLT.FILE.FILEOBJ, VLT.FILE.FILEOBJ/ADDLISTENER, VLT.FILE.FILEOBJ/LISTENER, EVENT.EVENTDATA, EVENTS

Help for vlt.file.fileobj/notify is inherited from superclass handle

    Documentation for vlt.file.fileobj/notify
       doc handle/notify
```

---

**setproperties** - *set the properties of a FILEOBJ*

```
FILEOBJ_OBJ = SETPROPERTIES(FILEOBJ_OBJ, 'PROPERTY1',VALUE1, ...)
 
  Sets the properties of a FILEOBJ with name/value pairs.
 
  Properties are:
    fullpathfilename; % the full path file name of the file
    fid;              % The Matlab file identifier
    permission;       % The file permission
    machineformat     % big-endian ('b'), little-endian ('l'), or native ('n')
```

---

