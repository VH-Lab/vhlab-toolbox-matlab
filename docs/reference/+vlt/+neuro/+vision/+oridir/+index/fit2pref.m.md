# vlt.neuro.vision.oridir.index.fit2pref

  FIT2PREF - calculate the preferred response from a fit to direction
 
   PREF=vlt.neuro.vision.oridir.index.fit2pref(RESPONSE)
 
   Given the RESPONSE of a double gaussian fit, find the maximum response.  
 
   RESPONSE is a 360x2 vector of responses. The first row indicates the 
   angles of the fit, and the second row indicates the responses.
 
   For backwards compatibility, if RESPONSE is a 360x1 vector, a new first
   row is added equal to 0:359.
 
   The largest response is returned in PREF.
 
   See also: vlt.neuro.vision.oridir.index.fit2null, vlt.neuro.vision.oridir.index.fit2orth
