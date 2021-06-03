# vlt.image.tiff16bit28bit

```
  TIFF16BIT28BIT Convert 16bit TIFF to 8-bit
 
    [IMG1,IMG2] = TIFF16BIT28BIT(FILENAME)
     or
    [IMG1,IMG2] = TIFF16BIT28BIT(FILENAME, WRITEIT)
   
    Opens the TIFF file with name FILENAME.  The file is assumed to
    be grayscale.  The original image is returned in IMG1.  The image is
    then scaled between 0 and 255 and returned as IMG2.  If 'WRITEIT' is
    provided, then the image is saved as FILENAME_8bit.TIFF.
 
    If the file is not a grayscale image then an error is generated.

```
