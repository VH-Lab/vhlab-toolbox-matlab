function [b, errormsg] = islikevarname(name)
% ISLIKEVARNAME - Is a string like a Matlab variable name (begin with letter)?
%
%  [B, ERRORMSG] = vlt.data.islikevarname(NAME)
%
%  Checks to see if NAME is a like a valid Matlab variable name. It must
%     a) begin with a letter
%     b) not have any whitespace
%     
%  Unlike real Matlab variables, NAME may be a Matlab keyword.
%   
%  B is 1 if NAME meets the criteria and is 0 otherwise.
%  ERRORMSG is a text message describing the problem.
%
%  Example:
%      [b,e] = vlt.data.islikevarname('my_var');   % b is 1, e is ''
%      [b,e] = vlt.data.islikevarname('1my_var');  % b is 0, e has an error message
%
%  See also: ISVARNAME, vlt.data.valid_varname
%

b = false;

errormsg = ['Error in ' name ': '];

if ~ischar(name),
	errormsg = [errormsg 'must be a character string.'];
	return;
end;

if length(name)<1,
	errormsg = [errormsg 'must be at least one character.'];
	return;
end;

if ~isletter(name(1)),
	errormsg = [errormsg 'must begin with a letter.'];
	return;
end;

if any(isspace(name)),
    errormsg = [errormsg 'must have no whitespace.'];
    return;
end;

b = true;
errormsg = '';

