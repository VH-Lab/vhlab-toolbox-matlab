function descr = structwhatvaries(celllistofstructures)
% STRUCTWHATVARIES - Identify what varies among a cell list of structure objects
%
%  DESCR = STRUCTWHATVARIES(CELLLISTOFSTRUCTURES)
%
%  Given a cell list of structures, returns a list of the fieldnames that vary in
%  value across the cell list.
%
%  NaN semantics: equality is tested with ISEQUALN, so a field that is NaN in
%  every structure counts as constant and is NOT reported as varying. This was
%  changed in issue #137 (item 3): the previous EQLEN comparison bottoms out in
%  X==Y, under which NaN differs from itself, so an all-NaN field was reported
%  as varying -- which is not what "what varies" should mean.
%
%  The fix is deliberately here rather than in EQLEN. EQLEN has 52 call sites in
%  this toolbox, and datastructures/@cell/eq.m and @struct/eq.m both call it, so
%  changing its NaN semantics would silently change == for every cell and struct
%  in any session with vlt on the path. NDI-matlab#902 fixed it at its own call
%  site for the same reason.
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
		if ~isequaln(getfield(celllistofstructures{1},bothfn{j}),...
				getfield(celllistofstructures{i},bothfn{j})),
			descr = cat(1,descr(:),bothfn(j));
		end;
	end;
end;

descr = unique(descr);


