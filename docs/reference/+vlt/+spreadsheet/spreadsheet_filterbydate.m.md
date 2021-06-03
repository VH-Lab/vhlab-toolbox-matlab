# vlt.spreadsheet.spreadsheet_filterbydate

```
  SPREADSHEET - Filter a spreadsheet for fields defined by a Timestamp field
   
 
  SPREADSHEET_OUT = vlt.spreadsheet.spreadsheet_filterbydate(SPREADSHEET_IN, DATELOW, DATEHIGH, ...)
 
  Filters a spreadsheet (cell array) SPREADSHEET_IN to exclude rows that have a 'timestamp'
  field entry outside of the range DATELOW to DATEHIGH.
 
  DATELOW and DATEHIGH can be any date string that is recognized by the Matlab function
  DATENUM. (For example, 'YYYY-MM-DD' is acceptable and unambiguous.)
 
  This function can also take name/value pairs that modify its behavior.
  Parameter (default)      | Description
  -------------------------------------------------------------------------------
  FirstRowIsHeader (1)     | Is the first row a header?
  LeaveHeader (1)          | Leave the header in the filtered spreadsheet
  TimestampColumnLabel     | The label of the timestamp column
    ('Timestamp')          |
  TimestampColumnNumber    | The column of the timestamp column. If empty, will be
           ('')            |   searched for using TimestampColumnLabel.
 
  See also: DATENUM, vlt.data.namevaluepair

```
