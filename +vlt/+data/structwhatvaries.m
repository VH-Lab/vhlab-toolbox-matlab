function descr = structwhatvaries(celllistofstructures)
% STRUCTWHATVARIES - Identify what varies among a cell list of structure objects
%
%  DESCR = vlt.data.structwhatvaries(CELLLISTOFSTRUCTURES)
%
%  Given a cell list of structures, returns a list of the fieldnames that vary in
%  value across the cell list.
%
%  NaN semantics: equality is tested with EQLEN, which bottoms out in X==Y, and
%  NaN is not equal to itself. A field that is NaN in *every* structure is
%  therefore reported as varying, which is usually not what a caller expects.
%  Callers needing NaN-aware behaviour should compare with ISEQUALN themselves.
%  See VH-Lab/vhlab-toolbox-matlab#137 (item 3); NDI-matlab#902 took this route.
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
	% (:) forces every piece to a column, so cat(1,...) always agrees on
	% dim 2. setdiff on a 1x1 cell returns 1x0, and stacking those yields a
	% 2x0 accumulator that then rejects a 1x1 fieldname. See issue #137.
	descr = cat(1,descr(:),fn2_not_fn1(:),fn1_not_fn2(:));
	for j=1:numel(bothfn),
		if ~vlt.data.eqlen(getfield(celllistofstructures{1},bothfn{j}),...
				getfield(celllistofstructures{i},bothfn{j})),
			descr = cat(1,descr(:),bothfn(j));
		end;
	end;
end;

descr = unique(descr);


