function [selected,b,errormsg] = nitemmenuselection(popupmenu_handle, varargin)
% NITEMNENUSELECTION - control multiple item selection for a popup menu
%
% [SELECTED, B, ERRORMSG] = NITEMMENUSELECTION(POPUPMENU_HANDLE, ...)
%
% Note that you shouldn't allow any item names to begin with
% ItemPrefix{:} entries.
%
% This function's performance is modified by name/value pairs:
% Parameter (default)   | Description
% -----------------------------------------------------------
% ItemPrefix (...       | Prefix strings to add to selected items
%  {'x:','y:','z:'})    |    The number of prefixes determines the number
%                       |    of items that can be selected simulatenously (N).
% value (current        | The value to toggle
%   uicontrol value)    | 
%
%
% Example:
%   names = {'a','b','c','d'};
%   fig=figure;
%   uicontrol('units','normalized','position',[0.1 0.1 0.2 0.5],'tag','mymenu',...
%       'style','popup','string',names,'callback','nitemmenuselection(gcbo);');
%   selected=nitemmenuselection(findobj(fig,'tag','mymenu'),'value',[]);


ItemPrefix = {'x:','y:','z:'};
value = get(popupmenu_handle,'value');

assign(varargin{:});

N = numel(ItemPrefix);

names = get(popupmenu_handle,'string');

indexes = zeros(numel(names),1);

for i=1:N,
	indexes(find(strncmp(ItemPrefix{i},names,numel(ItemPrefix{i}))))=i;
end;

order = sortorder(indexes(find(indexes)));
selected = find(indexes);
selected = selected(order);

b = 1;
errormsg = '';

if isempty(value),
	return;
end;

a = find(ismember(selected,value));
if ~isempty(a),
	% deselection request
	% remove the prefix from the name:
	names{value} = names{value}(numel(ItemPrefix{a})+1:end);
	selected = selected([1:a-1 a+1:end]);
	% now 'a' is the index value of any subsequent point
	for i=a:numel(selected), % have to re-order subsequent items
		here = selected(i);
		% switch from i+1 to i
		names{here} = names{here}(numel(ItemPrefix{i+1})+1:end);
		names{here} = [ItemPrefix{i} names{here}];
	end;
else,
	if numel(selected)>=N,
		% we already are full of selections
		b = 0;
		errmsg = 'Selection failed: too many items would be selected.';
		return;
	else, % we can do it
		selected(end+1) = value;
		names{value} = [ItemPrefix{numel(selected)} names{value}];
	% we have an attempted selection event
	end;
end;

 % update the handle

set(popupmenu_handle,'string',names);


