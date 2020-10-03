function [y,units_str,desc_str] = optics_table(wavelengths, filename)
% OPTICS_TABLE - Look up values from a table based on wavelength in nm
%
%  [Y,UNITS_STR,DESC_STR] = vlt.optics.optics_tables.optics_table(WAVELENGTHS, FILENAME)
%
%  Reads in a table from the text file FILENAME.  If no path is provided,
%  it is assume that FILENAME sits in the same directory as vlt.optics.optics_tables.optics_table.  
% 
%  The table should have 2 or more columns.  The first column is assumed to
%  have the wavelengths in units of nanometers, and columns 2-N have the
%  units to be returned.
%
%  Each of the N-1 dimensions is interpolated from the table using linear interpolation in INTERP1.
%  Entries for wavelengths that are outside the bounds provided in the table are 0.
%
%  If there are files FILENAME_units.txt and FILENAME_desc.txt in the same directory as
%  FILENAME, then units and a description are read.
%    UNITS_STR is a string that gives human-readable units.
%    DESC_STR is a human-readable description string.
%  If these files are not present, then UNITS_STR and DESC_STR are empty strings.
%
%
%  Example:  Read in the intensity emissions from the NP510 projector:
%
%     WAVES = [380:770]';
%     [NP510,NP510_units,NP510_desc]=vlt.optics.optics_tables.optics_table(WAVES,'NP510.txt');
%
%     figure;
%     plot(WAVES,NP510(:,1),'r');
%     hold on;
%     plot(WAVES,NP510(:,2),'g');
%     plot(WAVES,NP510(:,3),'b');
%     xlabel('Wavelength (nm)');
%     ylabel('Intensity (abitrary units)');
%
%    

units_str = '';
desc_str = '';

[pathstr, fname, ext] = fileparts(filename);

if isempty(pathstr),
	thisdir = which('vlt.optics.optics_tables.optics_table');
	pi = find(thisdir==filesep);
	thisdir= [thisdir(1:pi(end)-1) filesep];

	pathstr = thisdir;
else,
	pathstr(end+1) = filesep;
end;

table = load([pathstr fname ext]);

N = size(table,2);

y = [];

for i=2:N,
	y(:,end+1) = interp1(table(:,1),table(:,i),wavelengths,'linear',0);
end;

if size(wavelengths,2)>size(wavelengths,1), y = y'; end;

if exist([pathstr fname '_units.txt']),
	units_fid= fopen([pathstr fname '_units.txt'],'rt');
	units_str = fgets(units_fid);
	fclose(units_fid);
end;
if exist([pathstr fname '_desc.txt']),
	desc_fid= fopen([pathstr fname '_desc.txt'],'rt');
	desc_str = fgets(desc_fid);
	fclose(desc_fid);
end;


