# vlt.stats.hartigansdiptest

```
  function	[dip,xl,xu, ifault, gcm, lcm, mn, mj]=HartigansDipTest(xpdf)
 
  This is a direct translation by F. Mechler (August 27 2002)
  into MATLAB from the original FORTRAN code of Hartigan's Subroutine DIPTST algorithm 
  Ref: Algorithm AS 217 APPL. STATIST. (1985) Vol. 34. No.3 pg 322-325
 
  Appended by F. Mechler (September 2 2002) to deal with a perfectly unimodal input
  This check the original Hartigan algorithm omitted, which leads to an infinite cycle
 
  HartigansDipTest, like DIPTST, does the dip calculation for an ordered vector XPDF using
  the greatest convex minorant (gcm) and the least concave majorant (lcm),
  skipping through the data using the change points of these distributions.
  It returns the 'DIP' statistic, and 7 more optional results, which include
  the modal interval (XL,XU), ann error flag IFAULT (>0 flags an error)
  as well as the minorant and majorant fits GCM, LCM, and the corresponding support indices MN, and MJ

```
