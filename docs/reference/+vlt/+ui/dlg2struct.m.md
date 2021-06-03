# vlt.ui.dlg2struct

```
  DLG2STRUCT - Have a user fill in a structure with values
 
    S = vlt.ui.dlg2struct(WINDOWNAME, FN, DESCRIPTIONS, DEFAULTS)
 
    Prompts a user to fill in a structure with INPUTDLG.
    The fieldnames of the structure should be in the cell
    array of strings FN, and the human-readable descriptions
    of each field should be in the cell array of strings DESCRIPTIONS.
    Default values for each value should be the cell array DEFAULTS.
    Alternatively, DEFAULTS can be a structure with field names that 
    match those in FN.
 
    The dialog window will have a name WINDOWNAME.
 
    S will be a struct with fields FN. If the user clicks cancel, then
    S will be empty ([]).
 
    This function is only appropriate for simple structure values
    such as numbers and strings.
    
    Example:
       mystruct.a = 5;
       mystruct.b = 1;
       desc = {'Favorite number (1-10)', '2nd favorite number (1-10)'};
       s = vlt.ui.dlg2struct('Favorite numbers',fieldnames(mystruct),desc,mystruct);

```
