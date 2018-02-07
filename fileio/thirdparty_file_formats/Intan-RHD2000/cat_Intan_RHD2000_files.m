function status = cat_Intan_RHD2000_files(varargin)
% CAT_INTAN_RHD2000_FILES - Concatenate multiple RHD files together
%
% STATUS = CAT_INTAN_RHD2000_FILES(FILENAME1, FILENAME2, ...)
%
% Concatenate multiple RHD files together. Produces a large file
% named ['cat' FILENAME1]. Note that the filename information in the
% header of ['cat' FILENAME1] will still be FILENAME1.
%
% STATUS should always return 0 if there was no error.
%
% See also: READ_INTAN_RHD2000_DATAFILE, READ_INTAN_RHD2000_HEADER
%

status = 0;
h = {};

for i=1:length(varargin),
	h{i} = read_Intan_RHD2000_header(varargin{i});
end;


for i=1:length(h),
	fn1 = fieldnames(h{i});
	for j=2:length(h),
		fn2 = fieldnames(h{j});

		if ~eqlen(fn1,fn2),
			error(['In order to concatenate files, acquisition parameters must be the same (' varargin{i} ' ~= ' varargin{j} ').']);
		end;
		same = 1;
		for k=1:length(fn1),
			if strcmp(fn1{k},'fileinfo'),
				fnn = setdiff(fieldnames(h{i}.fileinfo),{'dirname','filename','filesize','headersize'});
				for kk=1:length(fnn),
					same = same & eqlen(getfield(h{i}.fileinfo,fnn{kk}),getfield(h{j}.fileinfo,fnn{kk}));
				end;
			elseif strcmp(fn1{k},'spike_triggers'), % not necessary to be the same
				% do nothing
			else,
				same = same & eqlen(getfield(h{i},fn1{k}), getfield(h{j},fn1{k}));
			end;
			if ~same,
				error(['In order to concatenate files, acquisition parameters must be the same (' varargin{i} ' ~= ' varargin{j} ').']);
			end;
		end;
	end;
end;

[filepath,filename,ext] = fileparts(varargin{1});

outfile = fullfile(filepath, ['cat' filename ext]);

fid_o = fopen(outfile,'w');
if fid_o<0,
	error(['Could not open the file ' outfile ' for writing.']);
end;

for i=1:length(varargin),
	fid_i = fopen(varargin{i},'r'); % should not fail because we've already read header files
	if i~=1, % if i==1, copy the header, too
		fseek(fid_i,h{i}.fileinfo.headersize,'bof');
	end;
	while ~feof(fid_i),
		data = fread(fid_i,10000,'uint8');
		try, 
			fwrite(fid_o,data,'uint8');
		catch,
			fclose(fid_i);
			fclose(fid_o);
			error(['Error writing to file ' outfile '.']);
		end;
	end;
	fclose(fid_i);
end;

fclose(fid_o);

