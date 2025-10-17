function struct_out = catstructfields(struct1, struct2, dimension)
% CATSTRUCTFIELDS - Concatenate fields from structures with equal fields
%
%  STRUCT_OUT = vlt.data.catstructfields(STRUCT1,STRUCT2[,DIMENSION])
%
%  This function concatenates the contents of the field values of
%  STRUCT1 and STRUCT2.  STRUCT1 and STRUCT2 must have identical fieldnames.
%  DIMENSION is the dimension over which the concatenation is performed.
%  If DIMENSION is not provided, then the function uses the largest
%  dimension of each field as the concatenation dimension.
%  
%  Example:
%    a.field1 = [ 1 2 3];
%    a.field2 = [ 1 2 3];
%    b.field1 = [ 4 5 6];
%    b.field2 = [ 4 5 6];
%    c = vlt.data.catstructfields(a,b);
%    c.field1 % is [1 2 3 4 5 6]
%    c.field2 % is [1 2 3 4 5 6]
%     
%  

if nargin<3,
	dimension=0;
end;

fn1 = fieldnames(struct1);
if ~vlt.data.eqlen(fn1,fieldnames(struct2)),
	error('MATLAB:vlt:data:catstructfields:mismatchedFields','Fieldnames of STRUCT1 and STRUCT2 must match exactly.');
end;

struct_out = struct1;

for i=1:length(fn1),
	dim = dimension;
	data = getfield(struct1,fn1{i});
	if dimension==0,
		[dummy,dim] = max(size(data));
	end;
	newdata = cat(dim,data,getfield(struct2,fn1{i}));
	struct_out = setfield(struct_out,fn1{i},newdata);
end;
