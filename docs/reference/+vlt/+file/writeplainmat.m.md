# vlt.file.writeplainmat

  WRITEPLAINVECTOR - write a simple binary matrix to disk
 
  vlt.file.writeplainmat(FID, MAT)
 
  Writes a basic matrix to disk such that it can be read easily. 
  FID should be a Matlab file identifier (see FOPEN). 
 
  The binary data is written using FID's byte order.
 
  The first entry is a character string indicating the type of
  data to be stored. This is just class(mat) (see CLASS).
  The first entry is a uint8 DIM that indicates the dimension of
  MAT (see SIZE).  Next, a 1xDIM vector in uint32 format
  describes the number of entries in each dimension.
  Finally, the entries of MAT are written as individual elements.
 
  Only classes that can be sent to FWRITE can be used here (such as
  'char', 'double', 'uint8', etc; see FWRITE).
 
  See also: CLASS, SIZE, FWRITE.
 
  Example: 
    data = rand(3,7),
    fid = fopen('myfile.dat','w','b'); % write, big-endian
    vlt.file.writeplainmat(fid,data);
    fclose(fid);
    fid = fopen('myfile.dat','r','b'); % read, big-endian
    mydata = vlt.file.readplainmat(fid);
    fclose(fid); 
    mydata, % display mydata
    data-mydata, % display the difference
