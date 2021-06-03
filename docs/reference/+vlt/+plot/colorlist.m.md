# vlt.plot.colorlist

```
  COLORLIST - Grab a color or group of colors from a list
 
    C = vlt.plot.colorlist
 
       Returns an Nx3 list of colors. By default, this function
   returns the normal 7 colors that Matlab uses as the default
   ColorOrder for new axes.
   
      or
 
    C = vlt.plot.colorlist(N)
  
       Returns a 1x3 color chosen from the color list. The Nth
   entry is chosen. If N is greater than the number of colors in the
   list, the selection 'wraps around' back to the beginning of the list.    
 
  This function also takes name/value pairs that extend its
  functionality:
  Parameter (default)    | Description 
  ------------------------------------------------------
  ColorList (7x3 default | The color list to choose from
               axes      |    Examples: jet(256), gray(256)
              ColorOrder)|
  DoNotWrap (0)          | Directs the function not to wrap the
                         |    selection around the list if N
                         |    is greater than the number of colors.
                         |    Instead, an error will occur.

```
