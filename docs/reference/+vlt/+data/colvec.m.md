# vlt.data.colvec

  COLVEC - return a matrix reshaped as a column vector
 
   Y = vlt.data.colvec(X)
 
   Returns the contents of the matrix X as a column vector Y that is 1xM,
   where M is the product of all the sizes of the dimensions of X
   (M = PROD(SIZE(X))).
  
   vlt.data.colvec is equivalent to Y = X(:);
 
   This function is useful for addressing all of the elements of a matrix
   as a vector when X is a subset of another matrix.
 
   See also: vlt.data.rowvec
 
   Example: 
     A = rand(5,5)
     Y = vlt.data.colvec(A(1:3,1:2)) % returns points in rows 1:3, columns 1:2
