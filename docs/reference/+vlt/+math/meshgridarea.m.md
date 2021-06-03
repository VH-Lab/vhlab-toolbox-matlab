# vlt.math.meshgridarea

```
  AREA = MESHGRIDAREA - Compute the area of each element of a meshgrid
 
    AREA = vlt.math.meshgridarea(XMESH, YMESH)
 
  Computes the area for a mesh grid with points XMESH YMESH.
 
  This function assumes that the 'area' for each MESH pixel i,j
  is equal to (XMESH(i)-XMESH(i-1)) * (YMESH(j)-YMESH(j-1)) and
  that the area of the first row and column are equal to the second
  row and column, respectively.

```
