# vlt.image.roi.ROI_3dplot2d

  ROI_3DPLOT2D - Plot 3d ROIs on a 2-d image
 
   [H_LINES, H_TEXT] = ROI_3DPLOT2D(CC, TEXTSIZE, COLOR, LINE_TAG, TEXT_TAG, ZDIM)
 
   Inputs:
      CC- An array of ROIS returned in CC by BWCONNCOMP
      TEXTSIZE - The size font that should be used to
                 label the numbers (0 for none)
      COLOR - The color that should be used, in [R G B] format (0...1)
      LINE_TAG - A text string that is used to tag the line plots
      TEXT_TAG - A text string that is used to tag the text
 
   Outputs:
      H_LINES - Handle array of line plots
      H_TEXT - Handle array of text plots
