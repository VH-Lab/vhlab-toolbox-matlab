function [x, xmlfilename] = bioformats2xml(filename, xmlfilename)
% BIOFORMATS2XML - return XML metadata (and write an XML file) using Bio-Formats
%
% [X, XMLFILENAME] = BIOFORMATS2XML(FILENAME, XMLFILENAME)
%
% Uses Bio-Formats to read XML metadata from the file FILENAME.
% If XMLFILENAME is not specified, a temporary file is created for that purpose.
% The XML character is returned in X. 
% The XMLFILENAME used is returned in XMLFILENAME.
%
% This function fixes an error in Bio-Formats (the XML file is in
% iso-88509-1, not UTF-8 as Bio-Formats outputs).
%


if nargin<2,
	xmlfilename = tempname;
end;

if ~exist(filename,'file'),
        error(['No such file ' filename '.']);
end;

r = bfGetReader(filename);

md = r.getMetadataStore();
x = char(md.dumpXML());

x = strrep(x,'utf-8','iso-8859-1');
x = strrep(x,'UTF-8','iso-8859-1');

str2text(xmlfilename,x);

