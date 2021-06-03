# vlt.image.neighborindexes

```
  NEIGHBORINDEXES - identify pixel index values that border a pixel
 
  INDEXES = NEIGHBORINDEXES(IMSIZE, INDEX, [CONN])
 
  Returns the index values of all pixels that neighbor a pixel specified
  by the index value INDEX in an image of size IMSIZE. CONN is the connectivity
  to be used.
 
  If CONN is not specified and if IMSIZE is 2-dimensional, then CONN is
  8, indicating all horizontal, vertical, and oblique neighbors.
 
  If CONN is not specified and if IMSIZE is 3-dimensional, then CONN is
  26, indicating all horizontal, vertical, above, below, and all obliques are
  considered neighbors.
 
  Currently, other modes for CONN are not supported (but feel free to add
  any of these and send a pull request).
 
  Note that INDEXES may have fewer elements than 26 or 8 if the pixel
  described by INDEX is on a border.
 
  Example:
     A = zeros(6,6,3)
     I = neighborindexes(size(A),sub2ind(size(A),3,3,2))
     A(sub2ind(size(A),3,3,2)) = 2;
     A(I) = 1  % 1s are neighbors, 2 is seed
 
  Example 2:
     A = zeros(6,6,3)
     I = neighborindexes(size(A),sub2ind(size(A),3,1,2))
     A(sub2ind(size(A),3,1,2)) = 2;
     A(I) = 1  % 1s are neighbors, 2 is seed
 
  Example 3:
     A = zeros(5,5)
     I = neighborindexes(size(A),sub2ind(size(A),2,1))
     A(sub2ind(size(A),2,1)) = 2;
     A(I) = 1  % 1s are neighbors, 2 is seed

```
