# vlt.matlab.graphics.savefigurelist

  SAVEFIGURELIST - Write the current figures to disk using figure tags for file names
 
    vlt.matlab.graphics.savefigurelist(FIGLIST, ...)
 
    Writes all of the figures in FIGLIST to the present
    working directory, using the 'Tag' field of each figure as its filename.
   
    If FIGLIST is empty, then all figures are written.
 
    This function also accepts additional parameter name/value pairs
      that modify its behavior:
 
    Parameter (default) | Description
    -----------------------------------------------------------------------
    ErrorIfTagEmpty (1) | 0/1 Produces an error if a 'tag' field is empty.
                        |   If 0, then a warning is given and the figure is
                        |   skipped.
    Formats ({'fig',... | File formats to write
      'epsc','pdf'})    |
 
    See also: SAVEAS, PWD
