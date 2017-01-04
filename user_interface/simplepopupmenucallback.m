function simplepopupmenucallback(callbacklist, value)
% SIMPLEPOPUPMENUCALLBACK - Evaluates an expression based on the value of a popup list
% 
% SIMPLEPOPUPMENUCALLBACK(CALLBACKLIST[, VALUE])
%
% Evaluates the expression at the VALUE index of
% the cell array of strings CALLBACKLIST (that is,
% evalutes CALLBACKLIST{VALUE}).
%
% If VALUE is not provided, then it is obtained from the 'value' field
% of the current callback object as obtained by the function GCBO.
%
% Example: 
%
%  uicontol('Style','popup','String',{'Option 1','Option 2'},...
%    'callback','simplepopupmenucallback({''func1'',''func2''});');
%
%  When Option 1 is chosen, 'func1' is called by EVAL, when Option 2
%  is chosen, 'func2' is called by EVAL.
%
%
%  See also: GCBO, SUBREF, EVAL, GENERCALLBACK

if nargin<2,
	try,
		value = get(gcbo,'value');
	catch,
		error(['Could not get field ''value'' from current callback object.']);
	end;
end;

eval(callbacklist{value});
