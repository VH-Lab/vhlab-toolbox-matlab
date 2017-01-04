function header_string = readcellvoyagerheaderfile(filename)
% READCELLVOYAGERHEADERFILE - Read header information from a CellVoyager tiff
%
%  H = READCELLVOYAGERHEADERFILE(FILENAME)
%
%  Reads the header 'ImageDescription' for all of the frames present in a
%  TIFF file acquired by the CellVoyager system.
%
%  

finfo = imfinfo(filename);

header_string = finfo(1).UnknownTags(2).Value);
header_string = header_string(14:2:end);


