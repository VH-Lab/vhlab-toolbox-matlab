function fid = fileid_value(fid_or_fileobj)
%FILEID_VALUE - return the value of an FID whether it is an FID or inside a FILEOBJ
%
% FID = FILEID_VALUE(FID_OR_FILEOBJ)
%
% Given a value which may be a FID or a FILEOBJ object, return either the FID or
% the FID field of the FILEOBJ object.
%
% Allows one to test 'if fileid_value(f)<0' without knowing if f is a Matlab file identifier
% or a FILEOBJ.
%

if isa(fid_or_fileobj,'fileobj'),
	fid = fid_or_fileobj.fid;
else,
	fid = fid_or_fileobj;
end;


