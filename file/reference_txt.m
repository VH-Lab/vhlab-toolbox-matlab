% REFERENCE_TXT Documentation of the 'reference.txt' file that is used by DIRSTRUCT objects
%
%  The DIRSTRUCT class is intended to manage experimental data. The data are organized
%  into separate test directories, with each directory containing one epoch of
%  recording.  Each such directory has a file called 'reference.txt' that contains
%  information about the signals that were acquired during that epoch.  The user
%  can query the DIRSTRUCT object to see what type of signals were recorded and to load data.
% 
%  The file 'reference.txt' describes one signal on each line with a name and
%  reference number pair and a record type.  For example, if one were to record
%  from two single electrodes, one in lgn and one in cortex, and this was the first
%  spot visited in cortex and the second spot visited in lgn, one might use the
%  following as the reference.txt file (spaces are tabs, include field title line):
%
%  name    ref    type
%  lgn     2      singleEC
%  ctx     1      singleEC
%
%  The NAME and REFERENCE of an entry are referred to as a name/ref pair.
%  For example, mynameref = struct('name','lgn','ref',2) is a name/ref pair
%  that refers to the entry with name 'lgn' and reference number 2.
%
%  One can using the DIRSTRUCT object to search for the directories where
%  NAME/REF pairs were recorded, or to identify all NAME/REF pairs that are in
%  an experiment. 
%
%  See also: DIRSTRUCT, METHODS('DIRSTRUCT')
%    

