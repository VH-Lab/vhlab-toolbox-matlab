# vlt.image.mergeluts

```
  MERGELUTS Merge color look up tables
 
  NEWLUT = MERGELUTS(ORIGINAL_LUT, LUT_TO_BE_MERGED)
 
 
    ORIGINAL_LUT will be overwritten with the first entries of
       LUT_TO_BE_MERGED.  In the event that ORIGINAL_LUT is larger
       than LUT_TO_BE_MERGED, either in depth or number of elements,
       then ORIGINAL_LUT's values will be preserved.  In this way,
       NEWLUT will have size identical to ORIGINAL_LUT.

```
