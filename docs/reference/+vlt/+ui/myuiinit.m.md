# vlt.ui.myuiinit

```
  MYUIINIT - a script to initialize workspace variables for user interfaces
 
    Initializes several structure variables that can then be passed to
    UICONTROL. These variables are assigned in the CALLER (that is, if you
    call this function from another function, the variable names below
    will be assigned in the function that calls this function).
 
    The following variables are initialized:
    Name:            |  Description:              
    -----------------------------------------------
    'button'         | Push button control*
    'txt'            | Static text control
    'uiedit'         | Editable text control
    'popup'          | Popup menu control*
    'checkbox'       | Checkbox type control*
 
    * indicates that the 'callback' field is set to 'vlt.ui.genercallback'
    Horizontal alignment of 'txt' and 'edit' controls is set to 'center'
    All backgrounds are set to 0.8*[1 1 1] except for 'edit', which
    is set to [1 1 1]
 
   See also: UICONTROL, vlt.ui.genercallback, ASSIGNIN

```
