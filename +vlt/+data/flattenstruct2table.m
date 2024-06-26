function t = flattenstruct2table(s, abbrev, prefix, depth)
% FLATTENSTRUCT - flatten a structure so that fields and subfields are column labels
%
% T = vlt.data.flattenstruct2table(S, ABBREV, [PREFIX])
%
% Returns a table generated from a structure S. Fieldnames become column headers,
% and subfield names become long names with a '.' separating subfields.
%
% For example, if a structure S has fields AA and AB, and AA is a structure
% with fields AAA and AAB, then T will have fields {'AA.AAA','AA.AAB','AB'}.
%
% If a substructure is a structure array with more than one element, then the entry number
% will be prepended to the field name.
%
% ABBREV is a cell array of abbreviations for shortening variable names so as not
% to exceed the 63 character limit for Matlab table variable names.
%
% If PREFIX is provided, it will be pre-pended to to the column names.
%
% Example:
%    A = struct('AA',struct('AAA',5,'AAB',7),'AB',2);
%    T = vlt.data.flattenstruct2table(A,{});

if nargin<2,
	abbrev = {};
end;

if nargin<3,
	prefix = '';
end;

if nargin<4,
	depth = 0;
end;

if ~isstruct(s),
	error(['This function only works for structures.']);
end;

fn = fieldnames(s);

t = table();

for j=1:numel(s),
	t_here = table();
	for i=1:numel(fn),
		v = getfield(s(j),fn{i});
		% if we don't have a struct, install the value and column name
		if ~isstruct(v),
			if depth>0 & numel(s)>1,
				v = eval(['{s.' fn{i} '};']);
			end;
			vname = [prefix fn{i} ];
			for k=1:size(abbrev,1),
				vname = strrep(vname,abbrev{k}{1},abbrev{k}{2});
			end;
			t_new = cell2table({v},'VariableNames',{vname});
		else,
		% if we do have a struct, we have to call our function recursively
			t_new = vlt.data.flattenstruct2table(v,abbrev,[prefix fn{i} '.'],depth+1);
		end;
		t_here = cat(2,t_here,t_new);
	end;

	if depth == 0,
		t = cat(1,t,t_here);
	else,
		t = cat(2,t,t_here);
	end;

	if depth>0, % we put them all together in a cell above
		break;
	end;
end;

