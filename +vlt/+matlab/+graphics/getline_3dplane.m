function varargout = getline_3dplane(varargin)
%GETLINE_3DPLANE Select polyline with mouse.
%   [X,Y,Z] = vlt.matlab.graphics.getline_3dplane(FIG) lets you select a polyline in the
%   current axes of figure FIG using the mouse.  Coordinates of
%   the polyline are returned in X and Y and Z.  Use normal button
%   clicks to add points to the polyline.  A shift-, right-, or
%   double-click adds a final point and ends the polyline
%   selection.  Pressing RETURN or ENTER ends the polyline
%   selection without adding a final point.  Pressing BACKSPACE
%   or DELETE removes the previously selected point from the
%   polyline.
%
%   [X,Y,Z] = vlt.matlab.graphics.getline_3dplane(AX) lets you select a polyline in the axes
%   specified by the handle AX.
%
%   [X,Y,Z] = vlt.matlab.graphics.getline_3dplane is the same as [X,Y] = vlt.matlab.graphics.getline_3dplane(GCF).
%
%   [X,Y,Z] = vlt.matlab.graphics.getline_3dplane(...,'closed') animates and returns a closed
%   polygon.
%
%   Example
%   --------
%       imshow('moon.tif')
%       [x,y] = vlt.matlab.graphics.getline_3dplane 
%
%   See also GETLINE, GETRECT, GETPTS.
%
%   Modified from GETLINE by SDV

%   Callback syntaxes:
%        vlt.matlab.graphics.getline_3dplane('KeyPress')
%        vlt.matlab.graphics.getline_3dplane('FirstButtonDown')
%        vlt.matlab.graphics.getline_3dplane('NextButtonDown')
%        vlt.matlab.graphics.getline_3dplane('ButtonMotion')

%   Grandfathered syntaxes:
%   XY = GETLINE(...) returns output as M-by-2 array; first
%   column is X; second column is Y.

%   Copyright 1993-2011 The MathWorks, Inc.

global GETLINE_FIG GETLINE_AX GETLINE_H1 GETLINE_H2
global GETLINE_X GETLINE_Y GETLINE_Z
global GETLINE_ISCLOSED

xlimorigmode = xlim('mode');
ylimorigmode = ylim('mode');
zlimorigmode = zlim('mode');
xlim('manual');
ylim('manual');
zlim('manual');

if ((nargin >= 1) && (ischar(varargin{end})))
    str = varargin{end};
    if (str(1) == 'c')
        % vlt.matlab.graphics.getline_3dplane(..., 'closed')
        GETLINE_ISCLOSED = 1;
        varargin = varargin(1:end-1);
    end
else
    GETLINE_ISCLOSED = 0;
end

if ((length(varargin) >= 1) && ischar(varargin{1}))
    % Callback invocation: 'KeyPress', 'FirstButtonDown',
    % 'NextButtonDown', or 'ButtonMotion'.
    feval(varargin{:});
    return;
end

GETLINE_X = [];
GETLINE_Y = [];
GETLINE_Z = [];

if (length(varargin) < 1)
    GETLINE_AX = gca;
    GETLINE_FIG = ancestor(GETLINE_AX, 'figure');
else
    if (~ishghandle(varargin{1}))
        CleanUp(xlimorigmode,ylimorigmode,zlimorigmode);
        error(message('vlt.matlab.graphics.getline_3dplane'));
    end
    
    switch get(varargin{1}, 'Type')
    case 'figure'
        GETLINE_FIG = varargin{1};
        if numel(GETLINE_FIG)>1, GETLINE_FIG = GETLINE_FIG(1); end
        GETLINE_AX = get(GETLINE_FIG, 'CurrentAxes');
        if (isempty(GETLINE_AX))
            GETLINE_AX = axes('Parent', GETLINE_FIG);
        end

    case 'axes'
        GETLINE_AX = varargin{1};
        if numel(GETLINE_AX)>1, GETLINE_AX = GETLINE_AX(1); end
        GETLINE_FIG = ancestor(GETLINE_AX, 'figure');

    otherwise
        CleanUp(xlimorigmode,ylimorigmode,zlimorigmode);
        error(message('vlt.matlab.graphics.getline_3dplane:expectedFigureOrAxesHandle'));
    end
end

if numel(GETLINE_FIG)>1, GETLINE_FIG = GETLINE_FIG(1); end
if numel(GETLINE_AX)>1, GETLINE_AX = GETLINE_AX(1); end

% Remember initial figure state
state= uisuspend(GETLINE_FIG);

% Set up initial callbacks for initial stage
set(GETLINE_FIG, ...
    'Pointer', 'crosshair', ...
    'WindowButtonDownFcn', 'vlt.matlab.graphics.getline_3dplane(''FirstButtonDown'');',...
    'KeyPressFcn', 'vlt.matlab.graphics.getline_3dplane(''KeyPress'');');

% Bring target figure forward
figure(GETLINE_FIG);

% Initialize the lines to be used for the drag
GETLINE_H1 = line('Parent', GETLINE_AX, ...
                  'XData', GETLINE_X, ...
                  'YData', GETLINE_Y, ...
                  'ZData', GETLINE_Z, ...
                  'Visible', 'off', ...
                  'Clipping', 'off', ...
                  'Color', 'k', ...
                  'LineStyle', '-', ...
                  'LineWidth', 2);

GETLINE_H2 = line('Parent', GETLINE_AX, ...
                  'XData', GETLINE_X, ...
                  'YData', GETLINE_Y, ...
                  'ZData', GETLINE_Z, ...
                  'Visible', 'off', ...
                  'Clipping', 'off', ...
                  'Color', 'w', ...
                  'LineStyle', ':', ...
                  'LineWidth', 2);

% We're ready; wait for the user to do the drag
% Wrap the call to waitfor in try-catch so we'll
% have a chance to clean up after ourselves.
errCatch = 0;
try
    waitfor(GETLINE_H1, 'UserData', 'Completed');
catch
    errCatch = 1;
end

% After the waitfor, if GETLINE_H1 is still valid
% and its UserData is 'Completed', then the user
% completed the drag.  If not, the user interrupted
% the action somehow, perhaps by a Ctrl-C in the
% command window or by closing the figure.

if (errCatch == 1)
    errStatus = 'trap';
    
elseif (~ishghandle(GETLINE_H1) || ...
            ~strcmp(get(GETLINE_H1, 'UserData'), 'Completed'))
    errStatus = 'unknown';
    
else
    errStatus = 'ok';
    x = GETLINE_X(:);
    y = GETLINE_Y(:);
    z = GETLINE_Z(:);
    % If no points were selected, return rectangular empties.
    % This makes it easier to handle degenerate cases in
    % functions that call vlt.matlab.graphics.getline_3dplane.
    if (isempty(x))
        x = zeros(0,1);
    end
    if (isempty(y))
        y = zeros(0,1);
    end
    if (isempty(z))
        z = zeros(0,1);
    end;
end

% Delete the animation objects
if (ishghandle(GETLINE_H1))
    delete(GETLINE_H1);
end
if (ishghandle(GETLINE_H2))
    delete(GETLINE_H2);
end

% Restore the figure's initial state
if (ishghandle(GETLINE_FIG))
   uirestore(state);
else,
    error(['Error in restoring state']);
end

CleanUp(xlimorigmode,ylimorigmode,zlimorigmode);

% Depending on the error status, return the answer or generate
% an error message.
switch errStatus
case 'ok'
    % Return the answer
    if (nargout >= 2)
        varargout{1} = x;
        varargout{2} = y;
        varargout{3} = z;
    else
        % Grandfathered output syntax
        varargout{1} = [x(:) y(:) z(:)];
    end
    
case 'trap'
    % An error was trapped during the waitfor
    error(message('vlt.matlab.graphics.getline_3dplane:interruptedMouseSelection'));
    
case 'unknown'
    % User did something to cause the polyline selection to
    % terminate abnormally.  For example, we would get here
    % if the user closed the figure in the middle of the selection.
    error(message('vlt.matlab.graphics.getline_3dplane:interruptedMouseSelection'));
end

%--------------------------------------------------
% Subfunction KeyPress
%--------------------------------------------------
function KeyPress %#ok

global GETLINE_FIG  GETLINE_H1 GETLINE_H2
global GETLINE_ISCLOSED
global GETLINE_X GETLINE_Y GETLINE_Z

key = get(GETLINE_FIG, 'CurrentCharacter');
if iscell(key), key = key{1}; end
switch key
case {char(8), char(127)}  % delete and backspace keys
    % remove the previously selected point
    switch length(GETLINE_X)
    case 0
        % nothing to do
    case 1
        GETLINE_X = [];
        GETLINE_Y = [];
        GETLINE_Z = [];
        % remove point and start over
        set([GETLINE_H1 GETLINE_H2], ...
                'XData', GETLINE_X, ...
                'YData', GETLINE_Y,...
                'ZData', GETLINE_Z);
        set(GETLINE_FIG, 'WindowButtonDownFcn', ...
                'vlt.matlab.graphics.getline_3dplane(''FirstButtonDown'');', ...
                'WindowButtonMotionFcn', '');
    otherwise
        % remove last point
        if (GETLINE_ISCLOSED)
            GETLINE_X(end-1) = [];
            GETLINE_Y(end-1) = [];
            GETLINE_Z(end-1) = [];
        else
            GETLINE_X(end) = [];
            GETLINE_Y(end) = [];
            GETLINE_Z(end) = [];
        end
        set([GETLINE_H1 GETLINE_H2], ...
                'XData', GETLINE_X, ...
                'YData', GETLINE_Y,...
                'ZData', GETLINE_Z);
    end
    
case {char(13), char(3)}   % enter and return keys
    % return control to line after waitfor
    set(GETLINE_H1, 'UserData', 'Completed');     

end

%--------------------------------------------------
% Subfunction FirstButtonDown
%--------------------------------------------------
function FirstButtonDown %#ok

global GETLINE_FIG GETLINE_AX GETLINE_H1 GETLINE_H2
global GETLINE_ISCLOSED
global GETLINE_X GETLINE_Y GETLINE_Z

pt = get(GETLINE_AX, 'CurrentPoint');
x = pt(1,1);
y = pt(1,2);
z = pt(1,3);
%[x,y] = getcurpt(GETLINE_AX);

% check if GETLINE_X,GETLINE_Y is inside of axis
xlim = get(GETLINE_AX,'xlim');
ylim = get(GETLINE_AX,'ylim');
zlim = get(GETLINE_AX,'zlim');

[az,el] = view(GETLINE_AX);
if abs(el)==90,
    z = max(zlim); % force to top of box for visibility in 2D view
end

if (x>=xlim(1)) && (x<=xlim(2)) && (y>=ylim(1)) && (y<=ylim(2)) && (z>=zlim(1)) && (z<=zlim(2))
    % inside axis limits
    GETLINE_X = x;
    GETLINE_Y = y;
    GETLINE_Z = z;
else
    % outside axis limits, ignore this FirstButtonDown
    return
end

if (GETLINE_ISCLOSED)
    GETLINE_X = [GETLINE_X GETLINE_X];
    GETLINE_Y = [GETLINE_Y GETLINE_Y];
    GETLINE_Z = [GETLINE_Z GETLINE_Z];
end

set([GETLINE_H1 GETLINE_H2], ...
        'XData', GETLINE_X, ...
        'YData', GETLINE_Y, ...
        'Visible', 'on');

if (~strcmp(get(GETLINE_FIG, 'SelectionType'), 'normal'))
    % We're done!
    set(GETLINE_H1, 'UserData', 'Completed');
else
    % Let the motion functions take over.
    set(GETLINE_FIG, 'WindowButtonMotionFcn', 'vlt.matlab.graphics.getline_3dplane(''ButtonMotion'');', ...
            'WindowButtonDownFcn', 'vlt.matlab.graphics.getline_3dplane(''NextButtonDown'');');
end

%--------------------------------------------------
% Subfunction NextButtonDown
%--------------------------------------------------
function NextButtonDown %#ok

global GETLINE_FIG GETLINE_AX GETLINE_H1 GETLINE_H2
global GETLINE_ISCLOSED
global GETLINE_X GETLINE_Y GETLINE_Z

selectionType = get(GETLINE_FIG, 'SelectionType');
if (~strcmp(selectionType, 'open'))
    % We don't want to add a point on the second click
    % of a double-click

    %[x,y] = getcurpt(GETLINE_AX);
    pt = get(GETLINE_AX, 'CurrentPoint');
    x = pt(1,1);
    y = pt(1,2);
    z = pt(1,3);
    
    if (GETLINE_ISCLOSED)
        GETLINE_X = [GETLINE_X(1:end-1) x GETLINE_X(end)];
        GETLINE_Y = [GETLINE_Y(1:end-1) y GETLINE_Y(end)];
        GETLINE_Z = [GETLINE_Z(1:end-1) z GETLINE_Z(end)];
    else
        GETLINE_X = [GETLINE_X x];
        GETLINE_Y = [GETLINE_Y y];
        GETLINE_Z = [GETLINE_Z z];
    end
    
    set([GETLINE_H1 GETLINE_H2], 'XData', GETLINE_X, ...
            'YData', GETLINE_Y,'ZData',GETLINE_Z);
    
end

if (~strcmp(get(GETLINE_FIG, 'SelectionType'), 'normal'))
    % We're done!
    set(GETLINE_H1, 'UserData', 'Completed');
end

%-------------------------------------------------
% Subfunction ButtonMotion
%-------------------------------------------------
function ButtonMotion %#ok

global GETLINE_AX GETLINE_H1 GETLINE_H2
global GETLINE_ISCLOSED
global GETLINE_X GETLINE_Y GETLINE_Z

%[newx, newy] = getcurpt(GETLINE_AX);
pt = get(GETLINE_AX, 'CurrentPoint');
newx = pt(1,1);
newy = pt(1,2);
newz = pt(1,3);

[az,el] = view(GETLINE_AX);
if abs(el)==90,
    zlim = get(GETLINE_AX,'zlim');
    newz = max(zlim); % force to top of box for visibility in 2D view
end

if (GETLINE_ISCLOSED && (length(GETLINE_X) >= 3))
    x = [GETLINE_X(1:end-1) newx GETLINE_X(end)];
    y = [GETLINE_Y(1:end-1) newy GETLINE_Y(end)];
    z = [GETLINE_Z(1:end-1) newz GETLINE_Z(end)];
else
    x = [GETLINE_X newx];
    y = [GETLINE_Y newy];
    z = [GETLINE_Z newz];
end

set([GETLINE_H1 GETLINE_H2], 'XData', x, 'YData', y, 'ZData', z);

%---------------------------------------------------
% Subfunction CleanUp
%--------------------------------------------------
function CleanUp(xlimmode,ylimmode,zlimorigmode)

xlim(xlimmode);
ylim(ylimmode);
zlim(zlimorigmode);
% Clean up the global workspace
clear global GETLINE_FIG GETLINE_AX GETLINE_H1 GETLINE_H2
clear global GETLINE_X GETLINE_Y GETLINE_Z
clear global GETLINE_ISCLOSED
