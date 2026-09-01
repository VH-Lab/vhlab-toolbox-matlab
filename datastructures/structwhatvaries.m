function descr = structwhatvaries(celllistofstructures)
% STRUCTWHATVARIES - Identify what varies among a cell list of structure objects
%
%  DESCR = STRUCTWHATVARIES(CELLLISTOFSTRUCTURES)
%
%  Given a cell list of structures, returns a list of the fieldnames that vary in
%  value across the cell list.
%
%  Values are compared with ISEQUALN, so NaN is equal to NaN: a field that is
%  NaN in *every* structure is NOT reported as varying. Until issue #137
%  (item 3) this used EQLEN, which bottoms out in X==Y, so an all-NaN field
%  came back as varying over a single distinct value. EQLEN itself is
%  unchanged -- the fix is at this call site only, as NDI-matlab#902 did.
%
%  Two further consequences of comparing with ISEQUALN rather than EQLEN:
%  values of different class no longer compare equal (ISEQUALN separates 'a'
%  from 97, EQLEN did not), and cell-, struct- or object-valued fields are
%  compared instead of throwing, since ISEQUALN does not need == to be
%  defined for the class (see issue #137, item 2).
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


