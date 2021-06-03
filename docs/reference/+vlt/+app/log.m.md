# CLASS vlt.app.log

```
  vlt.app.log: A logger for system and/or error messages by a Matlab application or package
 
  vlt.app.log is an API and implementation for writing messages to a log file. 
  This is useful for monitoring program operation, debugging, and helping end-users diagonose
  problems. It also allows the program not to write all messages to the command line, which can
  be confusing for end-users (or even developers).
 
  vlt.app.log Properties:
    system_logfile - A character string with the full path to the system log file
    error_logfile - A character string with the full path to the error log file
    debug_logfile - A character string with the full path to the debug log file
    system_verbosity - A double number that indicates whether or not a system message should be written.
                     If a message priority exceeds verbosity, it will be written to the log
    error_verbosity - A double number that indicates whether or not an error message should be written.
                     If a message priority exceeds verbosity, it will be written to the log
    debug_verbosity - A double number that indicates whether or not a debugging message should be written.
                     If a message priority exceeds verbosity, it will be written to the log
    log_name - The name to preprend to each log message as '[log_name] '.
    log_error_behavior - A string that indicates what the log should do if it cannot write a message to the 
                         log file. Valid values are 'Error', 'Warning', 'Nothing'
 
  vlt.all.log Methods:
    log - create a log object
    msg - write a message to the log
    seterrorbehavior - set the error behavior of a LOG object
    touch - create the log files if they don't exist


```
## Superclasses
**handle**

## Properties

| Property | Description |
| --- | --- |
| *system_logfile* | A character string with the full path to the system log file |
| *error_logfile* | A character string with the full path to the error log file |
| *debug_logfile* | A character string with the full path to the debug log file |
| *system_verbosity* | A double number that indicates whether or not a system message should be written. |
| *error_verbosity* | A double number that indicates whether or not an error message should be written. |
| *debug_verbosity* | A double number that indicates whether or not a debugging message should be written. |
| *log_name* | The name to preprend to each log message as '[log_name] '. |
| *log_error_behavior* | A string that indicates what the object should do if it cannot write a message to the file |


## Methods 

| Method | Description |
| --- | --- |
| *addlistener* | ADDLISTENER  Add listener for event. |
| *delete* | DELETE   Delete a handle object. |
| *eq* | == (EQ)   Test handle equality. |
| *findobj* | FINDOBJ   Find objects matching specified conditions. |
| *findprop* | FINDPROP   Find property of MATLAB handle object. |
| *ge* | >= (GE)   Greater than or equal relation for handles. |
| *gt* | > (GT)   Greater than relation for handles. |
| *isvalid* | ISVALID   Test handle validity. |
| *le* | <= (LE)   Less than or equal relation for handles. |
| *listener* | LISTENER  Add listener for event without binding the listener to the source object. |
| *log* | create a vlt.app.log for writing system, debugging, error information to log files |
| *lt* | < (LT)   Less than relation for handles. |
| *msg* | write a log message to the log |
| *ne* | ~= (NE)   Not equal relation for handles. |
| *notify* | NOTIFY   Notify listeners of event. |
| *seterrorbehavior* | set the error behavior of a LOG object |
| *touch* | create all log files if they do not already exist |


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
 
    See also LISTENER, EVENT.LISTENER, VLT.APP.LOG, NOTIFY, DELETE, META.PROPERTY, EVENTS

Help for vlt.app.log/addlistener is inherited from superclass HANDLE

    Documentation for vlt.app.log/addlistener
       doc handle.addlistener
```

---

**delete** - *DELETE   Delete a handle object.*

```
DELETE(H) deletes all handle objects in array H. After the delete 
    function call, H is an array of invalid objects.
 
    See also VLT.APP.LOG, VLT.APP.LOG/ISVALID, CLEAR

Help for vlt.app.log/delete is inherited from superclass HANDLE

    Documentation for vlt.app.log/delete
       doc handle.delete
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
 
    See also VLT.APP.LOG, VLT.APP.LOG/GE, VLT.APP.LOG/GT, VLT.APP.LOG/LE, VLT.APP.LOG/LT, VLT.APP.LOG/NE

Help for vlt.app.log/eq is inherited from superclass HANDLE

    Documentation for vlt.app.log/eq
       doc handle.eq
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
 
    See also FINDOBJ, VLT.APP.LOG

Help for vlt.app.log/findobj is inherited from superclass HANDLE

    Documentation for vlt.app.log/findobj
       doc handle.findobj
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
 
    See also VLT.APP.LOG, VLT.APP.LOG/FINDOBJ, DYNAMICPROPS, META.PROPERTY

Help for vlt.app.log/findprop is inherited from superclass HANDLE

    Documentation for vlt.app.log/findprop
       doc handle.findprop
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
 
    See also VLT.APP.LOG, VLT.APP.LOG/EQ, VLT.APP.LOG/GT, VLT.APP.LOG/LE, VLT.APP.LOG/LT, VLT.APP.LOG/NE

Help for vlt.app.log/ge is inherited from superclass HANDLE

    Documentation for vlt.app.log/ge
       doc handle.ge
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
 
    See also VLT.APP.LOG, VLT.APP.LOG/EQ, VLT.APP.LOG/GE, VLT.APP.LOG/LE, VLT.APP.LOG/LT, VLT.APP.LOG/NE

Help for vlt.app.log/gt is inherited from superclass HANDLE

    Documentation for vlt.app.log/gt
       doc handle.gt
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
 
    See also VLT.APP.LOG, VLT.APP.LOG/DELETE

Help for vlt.app.log/isvalid is inherited from superclass HANDLE

    Documentation for vlt.app.log/isvalid
       doc handle.isvalid
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
 
    See also VLT.APP.LOG, VLT.APP.LOG/EQ, VLT.APP.LOG/GE, VLT.APP.LOG/GT, VLT.APP.LOG/LT, VLT.APP.LOG/NE

Help for vlt.app.log/le is inherited from superclass HANDLE

    Documentation for vlt.app.log/le
       doc handle.le
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
 
    See also ADDLISTENER, EVENT.LISTENER, VLT.APP.LOG, NOTIFY, DELETE, META.PROPERTY, EVENTS

Help for vlt.app.log/listener is inherited from superclass HANDLE

    Documentation for vlt.app.log/listener
       doc handle.listener
```

---

**log** - *create a vlt.app.log for writing system, debugging, error information to log files*

```
LOG_OBJ = LOG(PROPERTY1, VALUE1, ... )
 
  Creates a new vlt.app.log object with the properties initiallized with name/value pair
  arguments. If not specified, the default values of the parameters are the following:
 
  Property                  | Default_value
  ---------------------------------------------------------
  system_logfile            | [userpath filesep 'system.log']
  error_logfile             | [userpath filesep 'error.log']
  debug_logfile             | [userpath filesep 'debug.log']
  system_verbosity          | 1.0
  error_verbosity           | 1.0
  debug_verbosity           | 1.0
  log_name                  | ''
  log_error_behavior        | 'warning'
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
 
    See also VLT.APP.LOG, VLT.APP.LOG/EQ, VLT.APP.LOG/GE, VLT.APP.LOG/GT, VLT.APP.LOG/LE, VLT.APP.LOG/NE

Help for vlt.app.log/lt is inherited from superclass HANDLE

    Documentation for vlt.app.log/lt
       doc handle.lt
```

---

**msg** - *write a log message to the log*

```
B = MSG(LOG_OBJ, TYPE, PRIORITY, MESSAGE)
 
  Appends the character string MESSAGE to the appropriate log file for the matapptools.log object
  LOG_OBJ. If the message exceeds the verbosity PRIORITY  for that message type, then the message is
  written. Possible values for type are 'SYSTEM', 'ERROR', and 'DEBUG' (not case sensitive). 
  The word SYSTEM, ERROR, or DEBUG is pre-pended to the message.
 
  It is good form for MESSAGE to end with a period. A newline is added after MESSAGE.
 
  A time stamp is added to the beginning of the log message, in UTC leap seconds.
 
  B is 1 if the operation is successful, and 0 otherwise. The error behavior is determined
  by LOG_OBJ.LOG_ERROR_BEHAVIOR.
 
  Example: 
    log_obj.msg('system',1,'starting my program');
    log_obj.msg('error',1,'Could not find file C:\mydir\abc.txt.');
    log_obj.msg('debug',1,'a=5 here.');
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
 
    See also VLT.APP.LOG, VLT.APP.LOG/EQ, VLT.APP.LOG/GE, VLT.APP.LOG/GT, VLT.APP.LOG/LE, VLT.APP.LOG/LT

Help for vlt.app.log/ne is inherited from superclass HANDLE

    Documentation for vlt.app.log/ne
       doc handle.ne
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
 
    See also VLT.APP.LOG, VLT.APP.LOG/ADDLISTENER, VLT.APP.LOG/LISTENER, EVENT.EVENTDATA, EVENTS

Help for vlt.app.log/notify is inherited from superclass HANDLE

    Documentation for vlt.app.log/notify
       doc handle.notify
```

---

**seterrorbehavior** - *set the error behavior of a LOG object*

```
LOG_OBJ = SETERRORBEHAVIOR(LOG_OBJ, LOG_ERROR_BEHAVIOR)
 
  Assign LOG_ERROR_BEHAVIOR, which can be 'warning', 'error', or 'nothing'.
```

---

**touch** - *create all log files if they do not already exist*

```
TOUCH(LOG_OBJ)
 
  Creates all log files if they do not already exist. If these log files
  cannot be created, then an error is generated.
```

---

