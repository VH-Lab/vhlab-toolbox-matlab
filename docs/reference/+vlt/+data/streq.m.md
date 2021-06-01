# vlt.data.streq

  vlt.data.streq(S1,S2 [,WC])
 
   Returns 1 if S1 and S2 are equal, and 0 otherwise.  The wildcard '*' may be
   used in S2, and then vlt.data.streq will return 1 if S1 matches the wildcard criteria.
   If the user wants to use a different wildcard character other than '*',
   a different wildcard character can be given in WC.
