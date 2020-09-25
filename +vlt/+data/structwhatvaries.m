function descr = structwhatvaries(celllistofstructures)
% STRUCTWHATVARIES - Identify what varies among a cell list of structure objects
%
%  DESCR = STRUCTWHATVARIES(CELLLISTOFSTRUCTURES)
%
%  Given a cell list of structures, returns a list of the fieldnames that vary in
%  value across the cell list.
%

descr = {};

if ~iscell(celllistofstructures),
	error(['CELLLISTOFSTRUCTURES must be a cell']);
end;

for i=1:numel(celllistofstructures),
	if ~isstruct(celllistofstructures{i}),
		error(['All entries of CELLLISTOFSTRUCTURES must be of type STRUCT.']);
	end;
end;

if numel(celllistofstructures)==0,
	return;
end;

fn1 = fieldnames(celllistofstructures{1});

for i=2:numel(celllistofstructures),
	fn2 = fieldnames(celllistofstructures{i});
	% fieldnames that are in fn2 but not fn1
	fn2_not_fn1 = setdiff(fn2,fn1);
	% fieldnames that are in fn1 but not fn2
	fn1_not_fn2 = setdiff(fn1,fn2);
	bothfn = intersect(fn1,fn2);
	descr = cat(1,descr,fn2_not_fn1,fn1_not_fn2);
	for j=1:numel(bothfn),
		if ~vlt.data.eqlen(getfield(celllistofstructures{1},bothfn{j}),...
				getfield(celllistofstructures{i},bothfn{j})),
			descr = cat(1,descr,bothfn{j});
		end;
	end;
end;

descr = unique(descr);


