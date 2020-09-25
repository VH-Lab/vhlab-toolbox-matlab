function saveStructArray(fname,gdi,header)
% SAVESTRUCTARRAY - Save a structure array into a text file
%  
%   SAVESTRUCTARRAY(FILENAME, STRUCTARRAY, [HEADER])
%
%   Saves structure array data of type STRUCT into a text
%   file.  FILENAME is the name of the file to be written.
%   STRUCTARRAY is the Matlab structure to be written (of type
%   STRUCT).
%
%   If HEADER is 1, then a header row with tab-delimited field names
%   is written (recommended if the file is to be read back in with 
%   LOADSTRUCTARRAY).  The input argument HEADER is optional 
%   (and is 1 if not specified).
%
%   Any existing FILENAME is overwritten.
%
%   Originally from Ken Sugino
%
%   See also: LOADSTRUCTARRAY, STRUCT, TABSTR2STRUCT
%   

if nargin == 2
	header = 1;
end

[fid,msg] = fopen(fname, 'wt');
if fid == -1
	disp(msg);
	return;
end

if header == 1
	fn = fieldnames(gdi([]));
	s = '';
	for i=1:length(fn)
		s = [s char(9) fn{i}];
	end
	s = s(2:end);
	fprintf(fid,'%s\n',s);
end

for i=1:length(gdi)
	s = struct2tabstr(gdi(i));
	fprintf(fid,'%s\n',s);
end

fclose(fid);

