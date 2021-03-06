function g = intnchoosek(N,K)

%  vlt.math.intnchoosek  n choose k, 0 for non-integer, negative values
%    vlt.math.intnchoosek(N,K) calls NCHOOSEK(N,K), but defines the
%  result to be zero when N and K are not positive integers
%  with N>=K.  This is different from matlab's normal behavior
%  of producing an error or returning an empty matrix.

if vlt.data.isint(N)&vlt.data.isint(K)&N>=0&K>=0&N>=K,
  g = nchoosek(N,K);
else, g = 0;
end;
