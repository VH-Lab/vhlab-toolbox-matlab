# vlt.matlab.graphics.pcolordummyrowcolumn

  PCOLORDUMMYROWCOLUMN - Add a dummy row and column to input to pcolor
 
   C_out = vlt.matlab.graphics.pcolordummyrowcolumn(C)
 
   Adds a dummy row and column of 0 data to the matrix C.  This is especially
   made for use with the PCOLOR command, which, in SHADING FLAT or
   SHADING FACETED mode, completely ignores the contents of the last row and
   column.  If you want them to show up, simply run your data through
   vlt.matlab.graphics.pcolordummyrowcolumn first.
 
   See also: PCOLOR, NONOPTIMAL-FUNCTION-BEHAVIOR (sorry, I've got some too)
