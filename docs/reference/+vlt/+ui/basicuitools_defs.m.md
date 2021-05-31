# vlt.ui.basicuitools_defs

  BASICUITOOLS_DEFS - Basic user interface uitools setup
 
   UIDEFS = vlt.ui.basicuitools_defs
 
   Returns a basic defined set of specifications for the commonly used
   user interface controls. 
 
   The foreground and background colors are compatible with the current
   Matlab version.
 
   This function also accepts name/value pairs that modify the default options.
   Parameter (default)              :  Description
   ------------------------------------------------------------------------
   callbackstr ('')                 |  Callback function for all active controls
                                    |    ('popup','button','slider','list','radiobutton',...
                                    |      'togglebutton')
   uiBackgroundColor (0.94*[1 1 1]) |  Background color for all except 'frame'
   frameBackgroundColor(0.8*[1 1 1])|  Background color for 'frame'
   uiUnits ('pixels')               |  Units for controls (could be 'normalized', 'points')
                                    |
              
   Example:
      uidefs = vlt.ui.basicuitools_defs;
      
   See also: UICONTROL
