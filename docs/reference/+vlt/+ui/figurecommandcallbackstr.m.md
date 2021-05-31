# vlt.ui.figurecommandcallbackstr

  FIGURECOMMANDCALLBACKSTR - Callback string that calls function in figure tag with uicontrol command
 
   CALLBACKSTR = vlt.ui.figurecommandcallbackstr
 
   Returns a string that is a useful callback for uicontrols in graphical user interfaces.
 
   This string performs the following actions:
        1)  Obtains the name of a function, located in the figure's tag field (say, 'myfunction')
        2)  Calls this function with input arguments 'command', TAG, 'fig', f, where f is the
            number of the current figure, and TAG is the tag of the uicontrol that was clicked.
 
   That is, this function calls myfunction('command',TAG,'fig',f)
 
   See also =: UICONTROL
