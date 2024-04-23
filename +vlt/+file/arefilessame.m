function b = arefilessame(file1,file2)
% AREFILESSAME - are two files the same, byte for byte?
%
% B = AREFILESSAME(FILE1, FILE2)
%
% Returns 1 if the binary contents of FILE1 and FILE2 are the same.
%

arguments
    file1 char {mustBeFile}
    file2 char {mustBeFile}
end; % arguments

fid1 = fopen(file1,'r');
fid2 = fopen(file2,'r');

if fid1<0,
    error(['Could not open ' file1 ' for reading.']);
end;

if fid2<0,
    error(['Could not open ' file1 ' for reading.']);
end;

buffersize = 100000;

b = 1;

while ~feof(fid1),
    D1 = fread(fid1,buffersize,'char');
    D2 = fread(fid2,buffersize,'char');
    b = isequaln(D1,D2);
    if ~b,
        fclose(fid1);
        fclose(fid2);
        return;
    end;
end;

fclose(fid1);
fclose(fid2);



