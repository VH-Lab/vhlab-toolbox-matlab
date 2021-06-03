# vlt.plot.intline

```
 INTLINE Integer-coordinate line drawing algorithm.
    [X, Y] = vlt.plot.intline(X1, X2, Y1, Y2) computes an
    approximation to the line segment joining (X1, Y1) and
    (X2, Y2) with integer coordinates.  X1, X2, Y1, and Y2
    should be integers.  vlt.plot.intline is reversible; that is,
    vlt.plot.intline(X1, X2, Y1, Y2) produces the same results as
    FLIPUD(vlt.plot.intline(X2, X1, Y2, Y1)).

```
