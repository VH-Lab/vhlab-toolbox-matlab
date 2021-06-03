# vlt.data.hashmatlabvariable

```
  HASHMATLABVARIABLE - create a hashed version of a Matlab variable in memory
 
  H = vlt.data.hashmatlabvariable(D)
 
  Creates a 32-bit hashed value based on the binary data in the variable D.
  
 
  Warning: For many years, PM_HASH produced the same numbers across
  platforms and across versions. New versions (Matlab 2019a for instance) 
  now seems to produce PM_HASH numbers that differ from earlier versions.
 
  This function can be modified by name/value pairs:
  Parameter (default)        | Description
  -------------------------------------------------
  algorithm ('pm_hash/crc')  | Algorithm to be used.
                             |  At present, the only choice is 
                             |  pm_hash/crc, which uses the Matlab
                             |  function PM_HASH.

```
