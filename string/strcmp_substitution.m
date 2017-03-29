function [tf, match_string, substitute_string] = strcmp_substitution(s1, s2, varargin)
% STRCMP_SUBSTITUTION - Checks strings for match with ability to substitute a symbol for a string
%
%  [TF, MATCH_STRING, SUBSTITUTE_STRING] = STRCMP_SUBSTITUTION(S1, S2, ...)
%
%  Compares S1 and S2 and returns in TF a logical 1 if they are of the same form and logical 0 otherwise.
%  These strings are of the same form if
%     a) S1 and S2 are identical
%     b) S2 is a regular expression match of S1 (see REGEXP)
%     c) S2 matches S1 when the symbol '#' in S1 is replaced by some string in S2. In this case,
%        SUBSTITUTE_STRING, the string that can replace the SubstituteStringSymbol '#' is also returned.
%     In any case, the entire matched string MATCH_STRING will be returned.
%
%
%  The function also has the form:
%
%  [TF, MATCH_STRING, SUBSTITUTE_STRING] = STRCMP_SUBSTITUTION(S1, A, ...)
%
%   where A is a cell array of strings. TF will be a vector of 0/1s the same length as A,
%   and SUBSTITUTE_STRING will be a cell array of the suitable substitute strings.
%   
%  One can also specify the substitute string to be used (that is, not allow it to vary)
%  by adding the name/value pair 'SubstituteString',THESTRING as extra arguments to the function.
%
%  This file can be modified by passing name/value pairs:
%
%  Parameter(default):         | Description:
%  ----------------------------------------------------------------------
%  SubstituteStringSymbol('#') | The symbol to indicate the substitute string 
%  UseSubstituteString(1)      | Should we use the SubstituteString option?
%  SubstituteString('')        | Force the function to use this string as the only acceptable
%                              |    replacement for SubstituteStringSymbol
%  ForceCellOutput(0)          | 0/1 should we output a cell even if we receive single strings as S1, S2?
%
%
%  Examples:
%            s1 = ['.*\.ext\>']; % equivalent of *.ext on the command line
%            s2 = { 'myfile1.ext' 'myfile2.ext' 'myotherfile.ext1'};
%            [tf, matchstring, substring] = strcmp_substitution(s1,s2,'UseSubstituteString',0)
%
%            s1 = ['stimtimes#.txt'];
%            s2 = { 'dummy.ext' 'stimtimes123.txt' 'stimtimes.txt' 'stimtimes456.txt'}
%            [tf, matchstring, substring] = strcmp_substitution(s1,s2)
%

SubstituteStringSymbol = '#';
UseSubstituteString = 1;
LiteralCharacter = '\';
SubstituteString = '';
ForceCellOutput = 0;

assign(varargin{:});

made_cell = 0;

if ischar(s2),
	s2 = {s2};
	made_cell = 1;
end;

   % step 1, identify all exact matches

tf = strcmp(s1,s2);

substitute_string = cell(1,length(s2));
substitute_string(:) = {''};
match_string = s2;

   % step 2, identify all regexp matches

indexes = find(~tf);

S = regexp(s2(indexes), s1);
tf2 = ~cellfun(@isempty,S);
tf(indexes) = tf2;


  % step 3, identify all substitution matches

if UseSubstituteString,
		% what work do we have remaining?
	indexes = find(~tf); % things that don't match and clean up match string indexes
	myregexp_literalexception = ['[\' LiteralCharacter ']' SubstituteStringSymbol];
	myregexp = SubstituteStringSymbol;
	mymatches = setdiff( regexp(s1,myregexp), 1+regexp(s1,myregexp_literalexception) );
	s1_ = s1;

	% the function operates in 2 modes; either we are given the SubstituteString and we look for matches,
	% or we look, for each string, if there exists a SubstituteString and return it

	if ~isempty(SubstituteString), % we are looking for this string
		for i=1:length(mymatches),
			s1_ = [s1_(1:(mymatches(i)-1)) SubstituteString s1_(mymatches(i)+1:end)];
			mymatches(i+1:end) = mymatches(i+1:end) + length(SubstituteString) - 1; % move these guys along
		end;
		tf2 = strcmp(s1_,s2(indexes)); % works for arrays, too
		indexeshere = find(tf2);
		tf(indexes(indexeshere)) = 1; % we found a match
		for j=1:length(indexeshere)
			substitute_string{indexes(indexeshere(j))} = SubstituteString;
		end;

	else, % we need to see if there is a string that fits
		if length(mymatches)>1,
			error(['Cannot deal with multiple locations for string match: ' s1 '.']);
		end;
		for i=1:length(mymatches),
			s1_ = [s1_(1:mymatches(i)-1) '(.+)' s1_(mymatches(i)+1:end)];
		end;
		[S] = regexp(s2(indexes),s1_,'forceCellOutput','tokens');
		tf2 = ~cellfun(@isempty,S);
		indexeshere = find(tf2);
		tf(indexes(indexeshere)) = 1;
		for j=1:length(indexeshere),
			substitute_string{indexes(indexeshere(j))} = S{indexeshere(j)}{1}{1};
		end;
	end;
end;

indexes = find(~tf); % things that don't match and clean up match string indexes
for j=1:length(indexes),
	match_string{indexes(j)} = '';
end;

  % clean up outputs, string or cell

if made_cell & ~ForceCellOutput,
	match_string = match_string{1};
	substitute_string = substitute_string{1};
end;


