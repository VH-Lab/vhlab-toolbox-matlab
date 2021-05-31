# vlt.math.inside

 vlt.math.inside Points inside a polygonal region in the plane.
    k = vlt.math.inside(z,w) is a vector of indices.
    The points z(k) are strictly inside the region defined by w.
    Here, z is a complex vector of points in the plane, and
    w is a complex vector of points definining the vertices of a
    polygonal region in the plane.  The region should be "starlike"
    wth respect to the "center", i.e. any ray eminating from
    mean(w) should intersect the boundary only once.
    Convex regions satisfy this requirement.
    For example, the vertices of the unit square are
    w = [0 1 1+i i] and k = vlt.math.inside(z,w) is the same as
    k = find((real(z)>0) & (real(z)<1) & (imag(z)>0) & (imag(z)<1))
 
    Developer note: This is an old Matlab function that has been replaced
    by INPOLYGON. Here for backwards compatibility
