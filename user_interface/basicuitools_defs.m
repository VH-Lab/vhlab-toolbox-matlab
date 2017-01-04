function uidefs = basicuitools_defs(varargin)
% BASICUITOOLS_DEFS - Basic user interface uitools setup
%
%  UIDEFS = BASICUITOOLS_DEFS
%
%  Returns a basic defined set of specifications for the commonly used
%  user interface controls. 
%
%  The foreground and background colors are compatible with the current
%  Matlab version.
%
%  This function also accepts name/value pairs that modify the default options.
%  Parameter (default)              :  Description
%  ------------------------------------------------------------------------
%  callbackstr ('')                 |  Callback function for all active controls
%                                   |    ('popup','button','slider','list','radiobutton',...
%                                   |      'togglebutton')
%  uiBackgroundColor (0.94*[1 1 1]) |  Background color for all except 'frame'
%  frameBackgroundColor(0.8*[1 1 1])|  Background color for 'frame'
%  uiUnits ('pixels')               |  Units for controls (could be 'normalized', 'points')
%                                   |
%             
%  Example:
%     uidefs = basicuitools_defs;
%     
%  See also: UICONTROL
%

callbackstr = '';

v = ver('MATLAB');
if datenum(v.Date) >= datenum('03-Oct-2014'),
	uiBackgroundColor = [0.94 0.94 0.94];
else,
	uiBackgroundColor = [0.8 0.8 0.8];
end;

frameBackgroundColor = 0.8 * [ 1 1 1 ];

uiUnits = 'pixels';

assign(varargin{:});

button.Units = uiUnits;
button.BackgroundColor = uiBackgroundColor;
button.HorizontalAlignment = 'center';
button.Callback = callbackstr;
button.Style = 'pushbutton';

togglebutton = button;
togglebutton.HorizontalAlignment = 'left';
togglebutton.Style = 'togglebutton';

txt.Units = uiUnits;
txt.BackgroundColor = uiBackgroundColor;
txt.fontsize = 12;
txt.fontweight = 'normal';
txt.HorizontalAlignment = 'left';
txt.Style='text';

edit = txt;
edit.BackgroundColor = [ 1 1 1] ;
edit.Style = 'Edit';

popup = txt;
popup.style = 'popupmenu';
popup.Callback = callbackstr;

slider = txt;
slider.Style = 'slider';
slider.Callback = callbackstr;

list = txt;
list.style = 'list';
list.Callback = callbackstr;

cb = txt;
cb.Style = 'Checkbox';
cb.Callback = callbackstr;
cb.fontsize = 12;

rb = cb;
rb.Style = 'radiobutton';

frame = txt;
frame.BackgroundColor = frameBackgroundColor;
frame.Style = 'frame';

uidefs = var2struct('button','togglebutton','txt','edit','popup','slider','list','cb','rb','frame');

