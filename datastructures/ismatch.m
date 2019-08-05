function b = ismatch(data, searchParams)
% ISMATCH - does a data structure match the search parameters?
%
% B = ISMATCH(DATA, SEARCHPARAMS)
%
%  (write some documentation)
%
% Example:
%    mydata = struct('a',1,'b',2,'c',3);
%    ismatch(mydata,{'a','exist',NaN})
%    ismatch(mydata,{'a','equal',1})
%    
%    mydata = struct('name','myname');
%    ismatch(mydata,{'name','contains','my'})
%


 % for loop that loops over the search parameters

b = 1;

for i=1:3:numel(searchParams),
	% 
	param = searchParams{i};
	op = searchParams{i+1};
	value = searchParams{i+2};

	switch op,
		case 'exists',

			b = 0;
			break;

		case 'exact', % exact match between parameter and value

		case 'equal', % does numeric value equal a value?
		case 'regexpmatch',
			% use the code from dumbjsondb


	end;
end;
