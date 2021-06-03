# vlt.string.version_decode

```
  VERSION_DECODE - Decode a version string (a.b.c.d) into a number
   
   V = vlt.string.version_decode(VERSION_STRING)
 
   Decodes a version string 'a.b.c.d' into a vector of integers
   V = [ a b c d ]
 
   Example:
       version_string = '5.0.32.100';
       v = vlt.string.version_decode(version_string)
       % v = [ 5 0 32 100]

```
