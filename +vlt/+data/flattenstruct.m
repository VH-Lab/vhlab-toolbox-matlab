function sf = flattenstruct(s, prefix, depth)
% FLATTENSTRUCT - flatten a structure so that substructures are fields
%
% SF = vlt.data.flattenstruct(S, [PREFIX])
%
% Returns a flatten structure where any substructures are renamed to be fields
% of the structure S. 
%
% For example, if a structure A has fields AA and AB, and AA is a structure
% with fields AAA and AAB, then SF will have fields {'A__AA__AAA','A__AA__AAB','A__AB'}.
%
% If a substructure is a structure array with more than one element, then the entry number
% will be prepended to the field name.
%
% There is a chance that the function will not be able to flatten a structure array,
% if say S(1).field1 is a scalar and S(2).field1 is a structure. Then, the fields of SF(1)
% and SF(2) would differ, which will be an error.
%
% If PREFIX is provided, it will be pre-pended to to the structure names.
%
% Note: FLATTENSTRUCT is not recommended.  Fieldnames have a limit of 63 characters.
% This function may create truncated fields. Instead, see FLATTENSTRUCT2TABLE.
%
% Example:
%    A = struct('AA',struct('AAA',5,'AAB',7),'AB',2);
%    SF = vlt.data.flattenstruct(A);

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

	s_here = orderfields(s_here);

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

