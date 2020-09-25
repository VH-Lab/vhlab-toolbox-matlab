function saveasv73(filename)
% SAVEASV73 - save a Matlab .mat file as a -v7.3 file
%
% SAVEASV73(FILENAME)
%
% Saves a Matlab .mat file with name FILENAME as a -v7.3 file.
% The original file is preserved as FILENAME_old.mat.
%
% See also: SAVE
%

savev73var = load(filename);

[parentdir,fname,ext] = fileparts(filename);

copyfile(filename,fullfile(parentdir,[fname '_old' ext]));

savev73fieldnames = fieldnames(savev73var);
savev73filename = filename;

if ~isempty(intersect(savev73fieldnames,...
	{'savev73fieldnames','savev73filename','savesv73var'})),
	error(['The variable names savev73fieldnames, savev73filename, or ' ...
		'savev73var do not work with this function.']);
end;

clear parentdir fname ext filename

vlt.data.struct2var(savev73var);

save(savev73filename,savev73fieldnames{:},'-v7.3','-mat');

