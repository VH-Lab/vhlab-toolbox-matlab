function concat_rhd_files(dirname)
% CONCAT_RHD_FILES - Concatenate RHD files and rename the original files
%
%  CONCAT_RHD_FILES(DIRNAME)
%
%  Concatenates all of the *.rhd files in a directory into one larger
%  file, and then renames the original *.rhd files so the extension is
%  .rhd_original.
%
%  See also: CAT_INTAN_RHD2000_FILES

d = dir([dirname filesep '*.rhd']);

n = {d.name};

for i =1:length(n),
	n{i} = [dirname filesep n{i}];
end;

if ~isempty(d),
	cat_Intan_RHD2000_files(n{:});
end;

for i=1:length(n),
	[newpath,newname,newext] = fileparts(n{i});
	movefile(n{i},fullfile(newpath,[newname '.rhd_original']));
end;
 

