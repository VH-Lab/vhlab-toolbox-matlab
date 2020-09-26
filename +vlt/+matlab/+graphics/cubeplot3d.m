function varargout = cubeplot3d(name, varargin)
% CUBEPLOT3D - Plot 3-dimensional data from many views simultaneously
%
% CUBEPLOT3D(NAME, 'data', DATA, ...)
%
% 
%

command = 'init';
data = [];
fig = gcf;
rect = [0 0 1 1];
units = 'normalized';

imageGain = 1;
imageMean = 128;
d3currentbin = 1;

d3binwidth = 0.25;
d3binstart = -0.100;
d3binstop = 0.300;

d1units = [];
d1label = 'Space (pixels)';
d2units = [];
d2label = 'Space (pixels)';
d3units = [];
d3label = 'Time (seconds)';

varlist = {'data','rect','units','imageGain','imageMean','d3currentbin','d3binwidth','d3binstart','d3binstop',...
	'd1units','d1label','d2units','d2label','d3units','d3label'};

assign(varargin{:});

if strcmp(lower(command),'init'),
	command = [name 'init'];
end;

command_extract_success = 0;

if length(command)>length(name),
	if strcmp(name,command(1:length(name))),
		command = lower(command(length(name)+1:end));
		command_extract_success = 1;
	end;
end;

if ~command_extract_success,
	error(['Command must include plot name (see help cubeplot3d)']);
end;

command,

% initialize our internal variables or pull it
if strcmp(lower(command),'init'), 
	for i=1:length(varlist),
		eval(['ud.' varlist{i} '=' varlist{i} ';']);
	end;
elseif strcmp(lower(command),'set_vars'), % if it is set_vars, leave ud alone, user had to set it
elseif ~strcmp(lower(command),'get_vars') & ~strcmp(lower(command),'get_handles'), % let the routine below handle it
	ud = cubeplot3d(name,'command',[name 'Get_Vars'],'fig',fig);
end;

switch lower(command),
	case 'init',
		uidefs = basicuitools_defs('callbackstr', ['callbacknametag(''cubeplot3d'',''' name ''');']),

		target_rect = ud.rect;
		units = ud.units;

		cmenu = uicontextmenu(fig, 'tag',[name '-contextmenu'],'callback',uidefs.popup.Callback);
		uimenu(cmenu,'label','Set parameters','tag',[name '-SetParameters'],'callback',uidefs.popup.Callback);
		
		axes_tags = {'-3dAxes' '-2dAxes', '-1dAxes'};
		position{1} = [0.1300 0.5838 0.3347 0.3412];
		position{2} = [0.1300 0.1100 0.3347 0.3412];
		position{3} = [0.5703 0.1100 0.3347 0.3412];

		for i=1:numel(position),
			if strcmp(units,'pixels'),
				position{i} = normalized2pixels(fig,position{i});
			end
			axes('units',units,'position',position{i},'tag',[name position{i}]);
		end

		cubeplot3d(name,'command',[name 'Set_Vars'],'ud',ud);

	case 'get_vars',
		handles = at_itemeditlist_gui(name,'command',[name 'get_handles'],'fig',fig);
		out = get(handles.ItemList,'userdata');
	case 'set_vars',  % needs 'ud' to be passed by caller
		handles = at_itemeditlist_gui(name,'command',[name 'get_handles'],'fig',fig);
		set(handles.ItemList,'userdata',ud);

	case 'get_handles',
		handle_base_names = {'3dAxes'};
		out = [];
		for i=1:length(handle_base_names),
			out = setfield(out,handle_base_names{i},findobj(fig,'tag',[name '-' handle_base_names{i}]));
		end

	case 'updateall',


	case 'updatecube',

		% plot the spatial averages
		% plot the yellow indicator

	case 'update2d',

	case 'update1d'

	case '-setparameters',

end;

	




