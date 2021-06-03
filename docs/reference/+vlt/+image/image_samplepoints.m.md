# vlt.image.image_samplepoints

```
  IMAGE_SAMPLEPOINTS - Sample points from an image file
 
   [PTS, IMAGESIZE] = IMAGE_SAMPLEPOINTS(IMAGEFILE, N, METHOD)
 
   This function samples N values from the image file in
   IMAGEFILE. METHOD can be 'random' or 'sequential'.
   The image size is returned in IMAGESIZE. Note that IMAGESIZE corresponds
   to the number of samples [HEIGHT WIDTH NUMBER_OF_IMAGES], regardless of 
   whether the samples are singles, triples (RGB), quads (e.g., CMYK).
 
   The N samples are drawn with replacement; it is possible the same value is
   drawn more than once.
 
   PTS is an NxDIM matrix of samples from the image. If the image is
   grayscale (single channel), then DIM is 1. If it is RGB, then DIM is 3, etc.
 
   This function accepts additional parameters as name/value pairs:
   Parameter (default)   | Description
   ----------------------------------------------------------------
   info ([])             | Optionally, one can pass the output of
                         |   imfinfo as info; it saves time beause
                         |   IMAGE_SAMPLEPOINTS doesn't need to read it

```
