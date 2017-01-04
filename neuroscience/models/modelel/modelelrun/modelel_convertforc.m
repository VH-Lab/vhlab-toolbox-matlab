function modelelout = modelel_convertforc(modelel, variables)
% MODELEL_CONVERTFORC - Convert a modelel structure into a format that can be parsed by the C++ implementation
%
%  MODELELOUT = MODELEL_CONVERTFORC(MODELEL, VARS)
%
%  Converts the structure representation that is used for
%  MATLAB (see help MODELEL) into a format suitable for
%  C++.
%
%  VARS is the list of state variables to track.  It is expected that
%  this is in the same format as the argument to modelel_run:
%  {'modelrunstruct.Model_Initial_Structure(1).T'}

modelelout = struct('modelel',[],'logged',[]);

for i=1:length(modelel),
	parameters = struct('type',modelel(i).model.type);
	fn = fieldnames(modelel);
	for j=1:length(fn),
		if ~strcmp(fn{j},'type'),
			v = getfield(modelel(i),fn{j});
			if isstruct(v),  % proceed down 1 layer
				fn2 = fieldnames(v);
				for k=1:length(fn2),
					parameters = setfield(parameters,fn2{k},getfield(v,fn2{k}));
				end;
			else,
				parameters = setfield(parameters,fn{j},v);
			end;
		end;
	end;
	modelelout(i).modelel = parameters;
end;

for i=1:length(variables),
	[el,str] = modelel_runvarname2log(variables{i});
	if isempty(modelelout(el).logged),
		modelelout(el).logged = str;
	else,
		modelelout(el).logged=[modelelout(el).logged ',' str];
	end;
end;
