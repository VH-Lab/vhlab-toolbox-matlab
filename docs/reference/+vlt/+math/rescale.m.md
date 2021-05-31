# vlt.math.rescale

   vlt.math.rescale - Rescale a quantity to a new interval
 
     NEWVALS = vlt.math.rescale(VALS, INT1, INT2)
 
   Takes values in an interval INT1 = [a b] and scales
   them so they are now in an interval [c d].  Any values
   less than a are set to c, and any values greater than b
   are set to d.
     NEWVALS = vlt.math.rescale(VALS, INT1, INT2, 'noclip')
        will do the same as above but will not clip values
        above b or below a.
