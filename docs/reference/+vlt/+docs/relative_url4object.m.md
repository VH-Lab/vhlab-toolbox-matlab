# vlt.docs.relative_url4object

  vlt.docs.relative_url4object - compute the relative url name for an object, relative to the current path
 
  S = vlt.docs.relative_url4object(CURRENTPATH, OBJECTNAME)
 
  Given the CURRENTPATH (the current directory of a URL), produce a relative URL S for 
  the object OBJECTNAME. OBJECTNAME should have the form 'package1.package2.{etc}.object' with no '.m' appended
  to the end of the object.
 
  **Example**:
    currentPath = '+ndi/+app/'
    objectName = 'ndi.time.timereference'
    s = vlt.docs.relative_url4object(currentPath,objectName);
      % s = '../+time/timereference.m.md'
