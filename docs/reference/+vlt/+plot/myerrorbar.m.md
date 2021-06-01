# vlt.plot.myerrorbar

 MYERRORBAR Error bar plot.
    ERRORBAR(X,Y,L,U) plots the graph of vector X vs. vector Y with
    error bars specified by the vectors L and U.  L and U contain the
    lower and upper error ranges for each point in Y.  Each error bar
    is L(i) + U(i) long and is drawn a distance of U(i) above and L(i)
    below the points in (X,Y).  The vectors X,Y,L and U must all be
    the same length.  If X,Y,L and U are matrices then each column
    produces a separate line.
 
    ERRORBAR(X,Y,E) or ERRORBAR(Y,E) plots Y with error bars [Y-E Y+E].
    ERRORBAR(...,'LineSpec') uses the color and linestyle specified by
    the string 'LineSpec'.  See PLOT for possibilities.
 
    ERRORBAR(...,TEE) gives the 'TEE' width, in the same units as X variable
 
    H = ERRORBAR(...) returns a vector of line handles.
 
    For example,
       x = 1:10;
       y = sin(x);
       e = std(y)*ones(size(x));
       errorbar(x,y,e)
    draws symmetric error bars of unit standard deviation.
