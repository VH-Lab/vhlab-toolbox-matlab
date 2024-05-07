function writetif(A,filename,cmap,scalefrom,scaleto,bit)
% WRITETIF - write a TIF file after scaling and converting to integer
%
% WRITETIF(A, FILENAME, CMAP, SCALEFROM, SCALETO, BIT)
%
% Write an 8-bit or 16-bit tiff of the image A to FILENAME, using
% colormap CMAP. The image is scaled (from a min of SCALEFROM(1) and a max
% of SCALEFROM(2) to a new min of SCALETO(1) and a new max of SCALETO(2)).
% If SCALEFROM is empty, it is assumed to be the min and max of the data
% of A. If SCALETO is empty, then the range is [0 2^(BIT)-1]
%
% FILENAME should end in '.tif' or '.tiff'.
%
% BIT should be 8 or 16, depending upon whether 8- or 16-bit output is desired.
%

A = double(A);

if bit~=8 & bit~=16,
	error(['BIT should be 8 or 16.']);
end;

if isempty(scalefrom),
	scalefrom = [ min(A(:)) max(A(:)) ];
end;

if isempty(scaleto),
	scaleto = [ 0 2^bit-1 ];
end;

A_ = vlt.math.rescale(A,scalefrom,scaleto);

if bit==8,
	A_ = uint8(A_);
elseif bit==16,
	A_ = uint16(A_);
end;

imwrite(A_,cmap,filename);
