function callbacknametag(functionname, name, varargin)
% CALLBACKNAMETAG - Callback to run a specified function with name and 'command' based on tag
%
%   CALLBACKNAMETAG(FUNCTIONNAME, NAME, ...)
%
%   Calls the function FUNCTIONNAME with first argument NAME, followed by a name/ref pair
%   argument 'command',TAG, where TAG is the TAG of the UICONTROL that was clicked.
%
%   Any additional arguments passed to CALLBACKNAMETAG will be passed along to the
%   function call to FUNCTIONNAME.
%

tag = get(gcbo,'tag');
eval([functionname '(''' name ''',''command'',''' tag ''',varargin{:});']);


