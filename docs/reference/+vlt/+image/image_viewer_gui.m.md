# vlt.image.image_viewer_gui

```
  IMAGE_VIEWER_GUI - Manage the view of a multi-frame image in a Matlab GUI
 
    IMAGE_VIEWER_GUI
 
    Creates and manages an image viewer appropriate for multi-frame image viewing
    in a Matlab GUI. Features a slider to move between frames and a zoom and pan button.
 
    To create a viewer, call IMAGE_VIEWER_GUI(NAME,'command','init') where 
    NAME is a unique name on your figure (you can have more than one viewer per figure
    if you use different names).  You can pass additional name/value pairs that govern the
    behavior of the GUI.
 
    Commands and parameters are not case sensitive. Name IS case sensitive.
 
    Parameter (default value)    | Description
    --------------------------------------------------------------------------- 
    fig (gcf)                    | Figure number where the viewer is located
    Units ('pixels')             | The units we will use
    LowerLeftPoint ([0 0])       | The lower left point to use in drawing, in units of "units"
    UpperRightPoint ([500 500])  | The upper right point to use in drawing, in units of "units"
    imagemodifierfunc ('')       | A string of a function that can modify the image. It should
                                 |   return an image. It can operate on 'im', a variable with the
                                 |   unmodified image.
    drawcompletionfunc ('')      | A string that is evaluated upon drawing completition.
    
    ImageVGUIAxesParams          | A structure with modifications to default axes parameters
                                 |   (such as position, units, etc). The 'tag' field cannot be
                                 |   modified. All other fields of the axes can be modified.
    ImageVGUIHistAxesParams      | A structure with modifications to default histogram axes
                                     parameters (same as above)
    ImageVGUISliderParams        | Same for frame-selection slider 
    ImageScaleParams             | A structure with fields 'Min' and 'Max' that indicate the
                                 |   values to scale each channel of the image. By default,
                                 |   ImageScaleParams.Min = [ 0 0 0 0] and ImageScaleParams.Max = [ 255 255 255 255 ]
    ImageDisplayScaleParams      | A structure with fields 'Min' and 'Max' that indicate the
                                 |   values to which the image should be scaled for display.
                                 |   Right now these must be ImageDisplayScaleParams.Min = [0 0 0 0] and 
                                 |   ImageDisplayScaleParams.Max = [ 255 255 255 255]
    
    One can also query the internal variables by calling
 
    IMAGE_VIEWER_GUI(NAME, 'command', 'Get_Vars')
   
    Or obtain the uicontrol and axes handles by using:
 
    IMAGE_VIEWER_GUI(NAME, 'command', 'Get_Handles')

```
