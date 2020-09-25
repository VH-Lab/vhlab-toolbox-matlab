function tf = ismatlabstring(str, startiswithinstring)
% ISMATLABSTRING - is a character within a Matlab string?
%
% TF = ISMATLABSTRING(STR, [STARTISWITHINSTRING])
%
% Returns 0/1 for each character of STR as to whether or not the
% character is within a Matlab string literal. The quotes are considered
% to be part of the string.
%
% It is normally assumed that the beginning of STR is not already
% considered to be part of a Matlab string. The user can pass STARTISWITHINSTRING as
% 1 to indicate that the first character of STR should be taken to be within a Matlab
% string.
%
% Examples:
%    str = ['myvar=5; a = ''my string'';']
%    vlt.string.ismatlabstring(str)
%             000000000000011111111100
%
%    str = ['myvar=5; a = [''my '''' '' int2str(5) '' string'';]']
%    vlt.string.ismatlabstring(str)

if nargin<2,
	startiswithinstring = 0;
end;

tf = zeros(size(str));

insidestringnow = startiswithinstring;
literalquoteflag = 0;
exitingstring = 0;

for i=1:numel(str),
	if literalquoteflag, 
		literalquoteflag = 0; % we already know this character is a literal quote, nothing to do
	elseif str(i) == '''',
		if ~insidestringnow,
			insidestringnow = 1;
		else, % we are already in a string
			% can be a closing quote or a literal quote ('')
			if i<numel(str),
				if str(i+1) == '''', % if the next one is a quote
					literalquoteflag = 1;
				end
			end
			if ~literalquoteflag, 
				% we saw a quote, and it was not a literalquoteflag, so it is an end
				exitingstring = 1;
			end
		end;
	else, % status quo
	end;
	tf(i) = insidestringnow;
	if exitingstring,
		exitingstring = 0;
		insidestringnow = 0;
	end
end

