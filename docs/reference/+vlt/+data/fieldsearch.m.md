# vlt.data.fieldsearch

```
  FIELDSEARCH - Search a structure to determine if it matches a search structure
 
  B = vlt.data.fieldsearch(A, SEARCHSTRUCT)
 
  Determines if a structure A matches the search structure SEARCHSTRUCT.
 
  SEARCHSTRUCT should be a structure array with the following fields:
 
  Field:                     | Description
  ----------------------------------------------------------------------------
  field                      | A character string of the field of A to examine
  operation                  | The operation to perform. This operation determines 
                             |   values of fields 'param1' and 'param2'.
      -----------------------|
      |   'regexp'               - are there any regular expression matches between 
      |                            the field value and 'param1'?
      |   'exact_string'         - is the field value an exact string match for 'param1'?
      |   'exact_string_anycase' - is the field value an exact string match for 'param1' (case insensitive)?
      |   'contains_string'      - is the field value a char array that contains 'param1'?
      |   'exact_number'         - is the field value exactly 'param1' (same size and values)?
      |   'lessthan'             - is the field value less than 'param1' (and comparable size)
      |   'lessthaneq'           - is the field value less than or equal to 'param1' (and comparable size)
      |   'greaterthan'          - is the field value greater than 'param1' (and comparable size)
      |   'greaterthaneq'        - is the field value greater than or equal to 'param1' (and comparable size)
      |   'hassize'              - does the field value have the size as indicated in 'param1' [x y z ...]
      |   'hasmember'            - does the field value have the member indicated in 'param1' ?
      |   'hasfield'             - is the field present? (no role for 'param1' or 'param2')
      |   'partial_struct'       - is the field value a structure that has all the fields of 'param1' with the same values?
      |                            (note that it may have additional fields not found in the structure in param1)
      |   'hasanysubfield_contains_string' - Is the field value an array of structs or cell array of structs
      |                          such that any has a field named 'param1' with a string that contains the string
      |                          in 'param2'? If 'param1' is a cell list, then 'param2' can be a cell list of contained
      |                          strings to be matched.
      |   'hasanysubfield_exact_string' - Is the field value an array of structs or cell array of structs
      |                          such that any has a field named 'param1' with a string that exactly matches the string
      |                          in 'param2'? If 'param1' is a cell list, then 'param2' can be a cell list of contained
      |                          strings to be matched.
      |   'or'                   - are the searchstruct elements specified in 'param1' OR 'param2' true?
      |   '~'                    - NOT of any operator, such as ~regexp, negates the outcome of the search
      -----------------------|
  param1                     | Search parameter 1. Meaning depends on 'operation' (see above).
  param2                     | Search parameter 2. Meaning depends on 'operation' (see above).
 
  A 'comparable' size means the 2 variables can be compared. [1 2 3]>=1 is comparable. [1 2 3]>=[0 0 0] is comparable. 
  [1 2 3]>[1 2] is an error.
  
 
  Examples: 
      A = struct('a','string_test','b',[1 2 3])
      b1=vlt.data.fieldsearch(A,struct('field','a','operation','contains_string','param1','test','param2',''))
      b2=vlt.data.fieldsearch(A,struct('field','b','operation','greaterthaneq','param1',1,'param2',''))
  
      B = struct('values',A);
      b3=vlt.data.fieldsearch(B,struct('field','values','operation','hasanysubfield_contains_string','param1','a','param2','string_test'))
 
      b4=vlt.data.fieldsearch(A,struct('field','','operation','or', ...
          'param1', struct('field','b','operation','hasfield','param1','','param2',''), ...
          'param2', struct('field','c','operation','hasfield','param1','','param2','') ))

```
