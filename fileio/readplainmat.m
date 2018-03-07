function mat = readplainmat(fid)
% READPLAINMAT - read a simple binary matrix from disk
% 
% MAT = READPLAINMAT(FID)
%
% Reads a basic matrix written by WRITEPLAINMAT.
% See WRITEPLAINMAT for details of the file format.
% FID should be an open FID (see FOPEN).
%
% For example, see WRITEPLAINMAT.


cn = fgetl(fid);
dim = fread(fid,1,'uint8'), % dimensions, limit of 255 dimensions
sz = fread(fid,dim,'uint32'), % size
mat = fread(fid, prod(sz), cn);
mat = reshape(mat,sz(:)');
