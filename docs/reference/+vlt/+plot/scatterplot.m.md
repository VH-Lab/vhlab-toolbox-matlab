# vlt.plot.scatterplot

  SCATTERPLOT -- plot data points
 
 	vlt.plot.scatterplot (X) draws a scatter plot with a dot for each row
 	in X.  If X has more than two columns then each dimension is
 	plotted against each other one to form a triangular set of
 	subplots in the current figure.
 
 	OPTIONS:
 
 	'class'		- vector containing a class label for each
 			  point.  If any (or all) of markercolor,
 			  markersize or markerstyle are cell arrays
 			  the label is used to index the cell array to
 			  set the marker appearance.
 	'color'		- color for marker border and fill (if used).
 			  Defaults to cell array of 'ColorOrder'
 			  property of axes. 
 	'fill'		- boolean indicating whether to fill marker
 	'marker'	- marker symbol to use
 	'markeredgecolor' - color for marker border: may be a string
 			  or [r,g,b] vector 
 	'markerfacecolor' - color for marker fill: may be a string
 			  or [r,g,b] vector
 	'markersize'	- marker size (default is 1)
 	'projection'	- plot only the specified dimensions
 	'shrink'	- resize the axes to exactly surround
 			  the points (on by default)
