# vlt.office.addresslabels2pdf

```
  ADDRESSLABELS2PDF - print address labels to a set of PDFs following a template
 
  vlt.office.addresslabels2pdf(LABELS, ...)
 
  This prints address labels LABELS to many pieces of figure 'paper'. 
  It follows the template described below. LABELS{i}{:} is a cell
  array that contains each line of text for each label.
   
  This function accepts name/value pairs that modify its default behavior:
 
  Parameter (default)         | Description
  -------------------------------------------------------------------------
  units ('inches')            | The units to use
  first_label_Y (1.0)         | The location of the first label in X
  first_label_X (1.5025)      | The location of the first label in Y
  dX (2.75)                   | Offset between columns (center-to-center)
  dY (1)                      | Offset between rows (center-to-center)
  ncolumns (10)               | Number of columns per sheet
  nrows (3)                   | Number of rows per sheet
                              |   (These are for Avery Labels 8160)
  fontsize (13)               | Fontsize to use

```
