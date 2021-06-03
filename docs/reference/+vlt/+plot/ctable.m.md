# vlt.plot.ctable

```
   vlt.plot.ctable  Creates a color table from a colormap.
 
   CT = vlt.plot.ctable(CMAP [, SZ])
 
   Returns a color table matrix from the colormap CMAP.  The color table is
   3xSZ, and if size is not specified SZ is assumed to be 256.  Each entry
   of the colortable CT(i+1,j+1,k+1) contains the index of the closest
   color in the colormap cmap, where i,j,and k run from 1...SZ.

```
