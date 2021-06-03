# vlt.spreadsheet.spreadsheet_multiplechoice

```
  SPREADSHEET_MULTIPLECHOICE - Return answers to a multiple choice spreadsheet question
 
  ANSWERS = vlt.spreadsheet.spreadsheet_multiplechoice(SPREADSHEET, QUESTION, ...)
 
  Returns a structure with responses to a multiple choice "question"
  in the header row of a spreadsheet. The header row is assumed to be the first
  row.
 
  The structure ANSWERS has 3 fields: question (the question asked), choices
  (a cell array of strings of the choices), and results (a vector of how many choices
  of each type were made).
 
  This function can also take name/value pairs that modify its behavior:
  Parameter (default)    | Description
  --------------------------------------------------------------------
  choices ([])           | If the user wishes to provide the choices, one
                         |   can. This is useful for prescribing the order
                         |   of the choices, or for indicating the possibility of
                         |   choices that are not represented in the data. If empty,
                         |   then choices will be determined empircally by the entries
                         |   in the spreadsheet.
 
  See also: NAMEVALUEPAIRS

```
