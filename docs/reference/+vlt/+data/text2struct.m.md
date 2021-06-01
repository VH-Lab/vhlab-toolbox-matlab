# vlt.data.text2struct

  TEXT2STRUCT - Convert a text string to a structure
 
    S = vlt.data.text2struct(STR)
 
  Given a full, multi-line string, converts to Matlab structures.
 
  Each line of the text string STR should have a field name,
  a colon (':') and values following. If the user wishes to specify
  a substructure, provide a '<' following the name of the substructure.
 
  Multiple structures can be specified by leaving a blank line between
  structure descriptions.
 
  If there is more than 1 struct to convert, then S is a cell list of
  all of the structures described in STR.
 
  Note: At this time, this function does not handle cell lists, which is
  too bad. Someone should add this.
 
  Example input:
  eol = sprintf('\n');                   % end of line character
  str = ['type: spiketimelistel' eol ... % indicates that the field type has a value of 'spiketimelistel'
         'T: 0' eol ...                  % indicates that the field 'T' has a value of 0
         'dT: 0.0001' eol ...            % indicates that the field dT has a value of 0.0001
         'name: cell1' eol ...           % name is 'cell1'
         'spiketimelistel: <' eol ...    % a substructure called spiketimelistel
         'spiketimelist: 0.0001' eol ... % the field in the substructure
         '>' eol ...                     % indicate end of substructure
         eol ];                          % blank line ends the structure (not necessary for last structure in list)
 
  mystruct = vlt.data.text2struct(str);
 
  The function can be modified by the addition of name/value pairs:
  Name (default):                | Description          
  ---------------------------------------------------------------------
  WarnOnBadField (0)             | 0/1 Produce a warning when a field name
                                 |   that cannot be a Matlab field name
                                 |   is encountered.
  ErrorOnBadField (0)            | 0/1 Produce an error when a field name
                                 |   that cannot be a Matlab field name
                                 |   is encountered (otherwise that entry
                                 |   is ignored)
  BraceLeft ('<')                | The left brace character
  BraceRight ('>')               | The right brace character
  
    See also: CHAR2STRUCT
