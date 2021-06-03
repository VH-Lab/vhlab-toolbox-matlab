# vlt.data.mlstr2var

```
  MLSTR2VAR - creates a Matlab variable from markup language strings (STRUCT2MLSTR, CELL2MLSTR)
 
  V = vlt.data.mlstr2var(MLSTRING)
 
  Given a markup language string representation of Matlab structures or cells, this 
  function produces a Matlab variable v.
 
  Matlab STRUCT types are specified in the markup language in the following way:
  <STRUCT size=[X Y Z ...] fields={ 'fieldname1','fieldname2',...} data=
       <<value1><value2>...<valuen>>
       <<value1><value2>...<valuen>>
  /STRUCT>
 
  and Matlab CELL types are specified in the markup language in the following way:
  <CELL size=[X Y Z ...] data=
       <value1>
       <value2>
  /CELL>
 
 
  Consider also: JSONENCODE, JSONDECODE
 
  See also: vlt.data.cell2mlstr, vlt.data.struct2mlstr, JSONDECODE

```
