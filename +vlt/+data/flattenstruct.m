function sf = flattenstruct(s, prefix, depth)
% VLT.DATA.FLATTENSTRUCT - Flatten a structure by merging substructures into top-level fields
%
%   SF = vlt.data.flattenstruct(S, [PREFIX])
%
%   This function flattens a structure S by taking any nested substructures
%   and making their fields top-level fields of the output structure SF.
%   The new field names are created by concatenating the original field names
%   with a double underscore '__'.
%
%   If a substructure is an array, the index is appended to the field name.
%
%   Note: This function is not recommended for structures with deep nesting
%   or long field names, as it may create field names that exceed Matlab's
%   63-character limit. Consider using vlt.data.flattenstruct2table instead.
%
%   Example:
%       A = struct('AA', struct('AAA', 5, 'AAB', 7), 'AB', 2);
%       SF = vlt.data.flattenstruct(A, 'A__');
%       % SF will have fields: 'A__AA__AAA', 'A__AA__AAB', 'A__AB'
%
%   See also: vlt.data.flattenstruct2table, fieldnames, orderfields
%

if nargin<2,
	prefix = '';
end;

if nargin<3,
	depth = 0;
end;

if ~isstruct(s),
	error(['This function only works for structures.']);
end;

fn = fieldnames(s);

for j=1:numel(s),
	s_here = s(j);
	for i=1:numel(fn),
		v = getfield(s(j),fn{i});
		% remove and rename it
		s_here = rmfield(s_here,fn{i});
		% if we don't have a struct, rename the field
		% if we do have a struct, we have to flatten it and add the entries
		if ~isstruct(v),
			item_str = '';
			if depth>0 & numel(s)>1,
				item_str = ['_' int2str(j) ];
			end;
			s_here = setfield(s_here,[prefix fn{i} item_str],v);
		else,
			s_new = vlt.data.flattenstruct(v,[prefix fn{i} '__'],depth+1);
			fn_new = fieldnames(s_new);
			for k=1:numel(fn_new),
				s_here = setfield(s_here,fn_new{k},getfield(s_new,fn_new{k}));
			end;
		end;
	end;

	s_here = orderfields(s_here)

	if j==1,
		sf = s_here;
	else,
		fn1 = fieldnames(sf);
		fn2 = fieldnames(s_here);
		if depth == 0,
			if ~isequal(fn1,fn2),
				error(['Subfields are not congruent. This struct cannot be flattened. Sorry.']);
			end;
			sf(j) = s_here; % might fail is not congruent
		else,
			for i=1:numel(fn2),
				sf = setfield(sf,fn2{i},getfield(s_here,fn2{i}));
			end;
		end;
	end;
end;

if depth == 0,
	sf = reshape(sf,size(s));
end;

