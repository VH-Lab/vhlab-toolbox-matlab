function out=modelel_importvariables(filename, modelelstruct, vars)
% MODELEL_IMPORTVARIABLES - Import variable values from the external C modelel simulator
%
%  OUT = vlt.neuroscience.models.modelel.modelelrun.modelel_importvariables(FILENAME, MODELELSTRUCT, VARS)
%
%  Returns the values of the output variables that were requested.
%  Reads these values from the file FILENAME.  VARS are the 
%  Matlab variable names that were requested.
%
%  See also: vlt.neuroscience.models.modelel.modelelrun.modelelrun
%

M = importdata(filename, ';' ,1);

if length(M.textdata)==1,
	z = [0 find(M.textdata{1}==';')];
	textdata = M.textdata{1};
	for l=1:length(z)-1,
		M.textdata{l} = textdata(1+z(l):z(l+1)-1);
	end;
end;

 % for each column of data, we need to identify which VARS entry it corresponds to

 % first, identify all of the element indexes for the VARS

out_indexes = [];

indexes = [];
varname = {};

for i=1:length(vars),
	element = sscanf(vars{i},'modelrunstruct.Model_Final_Structure(%d)');
	indexes(i) = element;
	period_indexes = find(vars{i}=='.');
	varname{i} = vars{i}(period_indexes(end)+1:end);
end;

for i=1:length(M.textdata),
	varname_start = find(M.textdata{i}=='_');
	varname_current = M.textdata{i}(varname_start+1:end);
	current_index = str2num(M.textdata{i}(1:varname_start-1));

	z = find(indexes==current_index);
	if ~isempty(z),
		match = 0;
		for j=1:length(z),
			if strcmp(varname{z(j)},varname_current),
				match = 1;
				out_indexes(i) = z(j);
				break;
			end;
		end;
		if match==0,
			error(['No match for variable name ' M.textdata{i} '.']);
		end;
	else,
		error(['No match for variable name ' M.textdata{i} '.']);
	end;
end;

out = [];
for i=1:length(out_indexes),
	out(i,:) = M.data(:,out_indexes(i))';
end;

