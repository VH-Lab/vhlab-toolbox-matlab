# vlt.file.xml.xmlstringinput

 XMLSTRINGINPUT Determine whether a string is a file or URL
    RESULT = vlt.file.xml.xmlstringinput(STRING) will return STRING if
    it contains "://", indicating that it is a URN.  Otherwise,
    it will search the path for a file identified by STRING.
 
    RESULT = vlt.file.xml.xmlstringinput(STRING,FULLSEARCH, RETURNFILE) will
    process STRING to return a RESULT appropriate for passing
    to an XML process.   STRING can be a URN, full path name,
    or file name.
 
    If STRING is a  filename, FULLSEARCH will control how 
    the full path is built.  If TRUE, the vlt.file.xml.xmlstringinput 
    will search the entire MATLAB path for the filename
    and return an error if the file can not be found.
    This is useful for source documents which are assumed
    to exist.  If FALSE, only the current directory will
    be searched.  This is useful for result documents which
    may not exist yet.  FULLSEARCH is TRUE if omitted.
 
    If RETURNFILE is TRUE, RESULT returns as a java.io.File
    when STRING is a file.  If RETURNFILE is FALSE,
    RESULT returns as a URN.  RETURNFILE is TRUE if omitted.
 
    This utility is used by XSLT, XMLWRITE, and XMLREAD
