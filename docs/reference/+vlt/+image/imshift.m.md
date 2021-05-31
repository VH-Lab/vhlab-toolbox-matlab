# vlt.image.imshift

  IMSHIFT - Shift an image, maintaining image size
 
   IM_OUT = IMSHIFT(IM, SHIFT)
 
   Shifts a 2-dimensional image IM by SHIFT pixels
   SHIFT should be a vector with elements [SHIFT_ROWS SHIFT_COLUMNS]
   SHIFT_COLUMNS is the number of pixels to shift the pixels to the
   right (can be negative to shift left); SHIFT_ROWS is the number
   of pixels to shift down (can be negative to shift up).
 
   Note that with images, the 'X' axis typically corresponds to
   columns, and the 'Y' axis typically corresponds to rows, so
   consider the order of the shift parameters for your application.
   
   One can pass additional arguments as name/value pairs:
   Name (default value): | Description:  
   ---------------------------------------------------------
   'PadValue' (0)        | Value for pixels used to pad the
                         |   edges of the shifted image so as
                         |   to maintain the original image size.
