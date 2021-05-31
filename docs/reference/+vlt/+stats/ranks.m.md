# vlt.stats.ranks

  RANKS - Returns vector of ranks of X adjusted for ties
 
  Y = vlt.stats.ranks(X)
 
  If X is a vector, return the (column) vector of ranks of
  X adjusted for ties.
 
  If X is a matrix, do the above for each column of X
 
  [From Octave 2.5.1]
  Author: KH <Kurt.Hornik@ci.tuwien.ac.at>
  Description: Compute ranks
  This code is rather ugly, but is there an easy way to get the ranks
  adjusted for ties from sort?
