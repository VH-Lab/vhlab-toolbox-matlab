# vlt.ui.nitemmenuselection

```
  NITEMNENUSELECTION - control multiple item selection for a popup menu
 
  [SELECTED, B, ERRORMSG] = vlt.ui.nitemmenuselection(POPUPMENU_HANDLE, ...)
 
  Note that you shouldn't allow any item names to begin with
  ItemPrefix{:} entries.
 
  This function's performance is modified by name/value pairs:
  Parameter (default)   | Description
  -----------------------------------------------------------
  ItemPrefix (...       | Prefix strings to add to selected items
   {'x:','y:','z:'})    |    The number of prefixes determines the number
                        |    of items that can be selected simulatenously (N).
  value (current        | The value to toggle
    uicontrol value)    | 
 
 
  Example:
    names = {'a','b','c','d'};
    fig=figure;
    uicontrol('units','normalized','position',[0.1 0.1 0.2 0.5],'tag','mymenu',...
        'style','popup','string',names,'callback','vlt.ui.nitemmenuselection(gcbo);');
    selected=vlt.ui.nitemmenuselection(findobj(fig,'tag','mymenu'),'value',[]);

```
