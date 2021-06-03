# vlt.image.image_samplerange

```
  IMAGE_SAMPLERANGE - return the range of values in an image file
 
   [RANGE, IMSIZE, IMFILEINFO] = IMAGE_SAMPLERANGE(IMAGEFILE, ...)
 
   Reads in the image in IMAGEFILE and returns the range of sample values.
   RANGE is an Nx2 vector that contains the range of values (column 1 is minimum,
   column 2 is maximum) for each dimension of the image (e.g., 3 for an RGB image, 1
   for a gray scale image). If IMAGEFILE describes an image with multiple frames, all
   frames are read to find the maximum and minimum values.
 
   IMFILEINFO is the information returned from IMFINFO.
 
   This function can also be modified by name/value pairs:
   Parameter (default value)   | Description
   ------------------------------------------------------------------
   UseRawData (1)              | Find the minimum and maximum from
                               |   the raw data of the image.
                               |   If this is 0, then the minimum and maximum
                               |   are derived from the format of the data.
                               |   (For example, for uint16, min is 0 and max is
                               |    2^15-1.)
   imfileinfo ([])             | Optionally, one can pass the output
                               |   of the Matlab function IMFINFO 
                               |   if that data has already been read; 
                               |   this will save the time of re-reading it 
   
 
   See also: IMAGE, IMFINFO, NAMEVALUEPAIR

```
