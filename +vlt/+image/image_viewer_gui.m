function out = image_viewer_gui(name,varargin)
% IMAGE_VIEWER_GUI - Manage the view of a multi-frame image in a Matlab GUI
%
%   IMAGE_VIEWER_GUI
%
%   Creates and manages an image viewer appropriate for multi-frame image viewing
%   in a Matlab GUI. Features a slider to move between frames and a zoom and pan button.
%
%   To create a viewer, call IMAGE_VIEWER_GUI(NAME,'command','init') where 
%   NAME is a unique name on your figure (you can have more than one viewer per figure
%   if you use different names).  You can pass additional name/value pairs that govern the
%   behavior of the GUI.
%
%   Commands and parameters are not case sensitive. Name IS case sensitive.
%
%   Parameter (default value)    | Description
%   --------------------------------------------------------------------------- 
%   fig (gcf)                    | Figure number where the viewer is located
%   Units ('pixels')             | The units we will use
%   LowerLeftPoint ([0 0])       | The lower left point to use in drawing, in units of "units"
%   UpperRightPoint ([500 500])  | The upper right point to use in drawing, in units of "units"
%   imagemodifierfunc ('')       | A string of a function that can modify the image. It should
%                                |   return an image. It can operate on 'im', a variable with the
%                                |   unmodified image.
%   drawcompletionfunc ('')      | A string that is evaluated upon drawing completition.
%   
%   ImageVGUIAxesParams          | A structure with modifications to default axes parameters
%                                |   (such as position, units, etc). The 'tag' field cannot be
%                                |   modified. All other fields of the axes can be modified.
%   ImageVGUIHistAxesParams      | A structure with modifications to default histogram axes
%                                    parameters (same as above)
%   ImageVGUISliderParams        | Same for frame-selection slider 
%   ImageScaleParams             | A structure with fields 'Min' and 'Max' that indicate the
%                                |   values to scale each channel of the image. By default,
%                                |   ImageScaleParams.Min = [ 0 0 0 0] and ImageScaleParams.Max = [ 255 255 255 255 ]
%   ImageDisplayScaleParams      | A structure with fields 'Min' and 'Max' that indicate the
%                                |   values to which the image should be scaled for display.
%                                |   Right now these must be ImageDisplayScaleParams.Min = [0 0 0 0] and 
%                                |   ImageDisplayScaleParams.Max = [ 255 255 255 255]
%   
%   One can also query the internal variables by calling
%
%   IMAGE_VIEWER_GUI(NAME, 'command', 'Get_Vars')
%  
%   Or obtain the uicontrol and axes handles by using:
%
%   IMAGE_VIEWER_GUI(NAME, 'command', 'Get_Handles')
%   

    % IMPROVEMENTS (someday):
        % SAVE the scaling information
	%  add zoom / pan / help / file controls
	%   ImageVGUIZoomButtonParams    | Same for Zoom button
	%   ImageVGUIPanButtonParams     | Same for Pan button
    %    Show/hide zoom/pan tools
    %    Show/hide scroll bar
    %    Show/hide histogram
    %    Abstract away the image part, so one can read image streams instead of just imread-capable files
    %    Add the ability to have more than one same-sized image file shown at once, on different channels

sizeparams.DefaultHeight = 500;
sizeparams.DefaultWidth = 500;
sizeparams.DefaultRowHeight = 35;
sizeparams.DefaultEdgeSpace = 30;

ImageScaleParams.Min = [0 0 0 0];
ImageScaleParams.Max = [255 255 255 255];
ImageDisplayScaleParams.Min = [0 0 0 0];
ImageDisplayScaleParams.Max = [255 255 255 255];

ImageVGUIAxesParams = [];
ImageVGUIHistAxesParams = [];
ImageVGUIZoomButtonParams = [];
ImageVGUIPanButtonParams  = [];
ImageVGUISliderParams = [];
ImageVGUIScaleMinLabelTextParams = [];
ImageVGUIScaleMaxLabelTextParams = [];
ImageVGUIScaleMinEditParams = [];
ImageVGUIScaleMaxEditParams = [];


Units = 'pixels';
LowerLeftPoint = [0 0];
UpperRightPoint = [ sizeparams.DefaultWidth sizeparams.DefaultHeight ];
ud = [];
imfile = '';
iminfo = [];
previousslidervalue = -1;
imagemodifierfunc = '';
drawcompletionfunc = '';
showhistogram = 1;

command = [name 'init']; 
fig = gcf;

varlist = {'sizeparams','LowerLeftPoint','UpperRightPoint','imfile','iminfo', 'previousslidervalue',...
	'imagemodifierfunc','showhistogram','drawcompletionfunc',...
	'ImageVGUIAxesParams','ImageVGUIHistAxesParams','ImageVGUIZoomButtonParams','ImageVGUIPanButtonParams','ImageVGUISliderParams',...
	'ImageVGUIScaleMinLabelTextParams','ImageVGUIScaleMaxLabelTextParams','ImageVGUIScaleMinEditParams','ImageVGUIScaleMaxEditParams',...
	'ImageScaleParams','ImageDisplayScaleParams'};

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
	error(['Command must include IMAGE_VIEWER_GUI name (see help image_viewer_gui)']);
end;

% initialize our internal variables or pull it
if strcmp(lower(command),'init'), 
	for i=1:length(varlist),
		eval(['ud.' varlist{i} '=' varlist{i} ';']);
	end;
elseif strcmp(lower(command),'set_vars'), % if it is set_vars, leave ud alone, user had to set it
elseif ~strcmp(lower(command),'get_vars') & ~strcmp(lower(command),'get_handles'), % let the routine below handle it
	ud = image_viewer_gui(name,'command',[name 'Get_Vars']);
end;

switch lower(command),
	case 'init',
		uidefs = basicuitools_defs('callbackstr', ['callbacknametag(''image_viewer_gui'',''' name ''');']);
        uidefs.edit.callback = ['callbacknametag(''image_viewer_gui'',''' name ''');'];

		axes('units','pixels','tag',[name 'HistogramAxes']);
		axes('units','pixels', 'tag',[name 'ImageAxes']);
		uicontrol(uidefs.slider,'units','pixels', 'tag',[name 'ImageSlider']);
        uicontrol(uidefs.txt,'units','pixels','tag',[name 'ImageScaleMinLabelText'],'string','Min:');
        uicontrol(uidefs.txt,'units','pixels','tag',[name 'ImageScaleMaxLabelText'],'string','Max:');
        uicontrol(uidefs.edit,'units','pixels','tag',[name 'ImageScaleMinEdit'],'string','[0 0 0 0]');
        uicontrol(uidefs.edit,'units','pixels','tag',[name 'ImageScaleMaxEdit'],'string','[1 1 1 1]');
		
		image_viewer_gui(name,'command',[name 'Set_Vars'],'ud',ud);
		image_viewer_gui(name,'command',[name 'position_gui']);
		image_viewer_gui(name,'command',[name 'load_image']);
		image_viewer_gui(name,'command',[name 'reset_axes_size']);
	case 'get_vars',
		handles = image_viewer_gui(name,'command',[name 'get_handles'],'fig',fig);
		out = get(handles.ImageSlider,'userdata');
	case 'set_vars',  % needs 'ud' to be passed by caller
		handles = image_viewer_gui(name,'command',[name 'get_handles'],'fig',fig);
		set(handles.ImageSlider,'userdata',ud);
	case 'get_handles',
		handle_base_names = {'HistogramAxes','ImageSlider','ImageAxes','ImageScaleMinLabelText','ImageScaleMinEdit','ImageScaleMaxLabelText','ImageScaleMaxEdit','ImageZoomButton','ImagePanButton'};
		out = [];
		for i=1:length(handle_base_names),
			out=setfield(out,handle_base_names{i},findobj(fig,'tag',[name handle_base_names{i}]));
		end;
	case 'position_gui',
		w = ud.sizeparams.DefaultWidth;
		h = ud.sizeparams.DefaultHeight;
		r = ud.sizeparams.DefaultRowHeight;
		ws = ud.sizeparams.DefaultEdgeSpace;

		% at present, 2 states: 1 = all items present, 2 = no histogram
		state = 2 - ud.showhistogram;

		histheight = 100 * ud.showhistogram;
		toolarea = 100 * ud.showhistogram;
		sliderws = 5;
		sliderw = 20;

		target_rect = rect2rect([ud.LowerLeftPoint ud.UpperRightPoint],'lbrt2lbwh');

		handles = image_viewer_gui(name,'command',[name 'get_handles'],'fig',fig);
		handle_base_names = {'HistogramAxes','ImageSlider','ImageAxes','ImageScaleMinLabelText','ImageScaleMinEdit','ImageScaleMaxLabelText','ImageScaleMaxEdit','ImageZoomButton','ImagePanButton'};
		modifiers = {'ImageVGUIHistAxesParams','ImageVGUIAxesParams','ImageVGUISliderParams',...
			'ImageVGUIScaleMinLabelTextParams','ImageVGUIScaleMaxLabelTextParams','ImageVGUIScaleMinEditParams','ImageVGUIScaleMaxEditParams',...
		'ImageVGUIZoomButtonParams','ImageVGUIPanButtonParams'};

		positions{1} = { rescale_subrect([ws ws w-2*ws 100],[0 0 w h],target_rect,3) % HistogramAxes
					rescale_subrect([w-sliderw histheight+2*ws sliderw h-histheight-3*ws],[0 0 w h],target_rect,3)  % slider
					rescale_subrect([ws+toolarea histheight+2*ws w-2*ws-toolarea-sliderws h-histheight-3*ws],[0 0 w h],target_rect,3) % image axes
                    rescale_subrect([ws+toolarea histheight+0*ws 50 20],[0 0 w h],target_rect,3) % ImageScaleMinLabelText
                    rescale_subrect([ws+toolarea+55 histheight+0*ws 100 20],[0 0 w h],target_rect,3) % ImageScaleMinEdit
                    rescale_subrect([ws+toolarea+155+10 histheight+0*ws 50 20],[0 0 w h],target_rect,3) % ImageScaleMaxLabelText
                    rescale_subrect([ws+toolarea+210+10 histheight+0*ws 100 20],[0 0 w h],target_rect,3) % ImageScaleMaxEdit
					};
		positions{2} = positions{1};
		visible{1} = {'on','on','on','on','on','on','on'};
		visible{2} = {'off','on','on','on','on','on','on'};

		for i=1:7, % right now, only 3 objects, even though we've sketched other controls
			myobj = getfield(handles,handle_base_names{i});
			eval(['p = struct2namevaluepair(' modifiers{i} ');']);
			set(myobj,'units','pixels','position',positions{state}{i},'visible',visible{state}{i},p{:});
		end;

	case 'set_image', % needs input imfile as name/value pair
		ud.imfile = imfile;
		image_viewer_gui(name,'command',[name 'Set_Vars'],'ud',ud);
		image_viewer_gui(name,'command',[name 'Load_image']);

	case 'load_image',
		if ~isempty(ud.imfile),
			handles = image_viewer_gui(name,'command',[name 'get_handles'],'fig',fig);

			currentsliderpos = get(handles.ImageSlider,'value');

			ud.iminfo = imfinfo(ud.imfile);
			imagerange = image_samplerange(ud.imfile,'imfileinfo',ud.iminfo);
			ud.ImageScaleParams.Min = imagerange(:,1)';
			ud.ImageScaleParams.Max = imagerange(:,2)';
			image_viewer_gui(name,'command',[name 'Set_Vars'],'ud',ud);

			number_of_frames = length(ud.iminfo);
			% if needed, fix slider to match frames
			ss=get(handles.ImageSlider,'sliderstep');
			if sum(abs(ss-(1/number_of_frames)*[1 1]))>1e-13,
				% reset slider
				%disp(['resetting slider']);
				sliderstep = 1/(number_of_frames-1)*[1 1];
				if isinf(sliderstep), sliderstep = [0 0]; end;
				if currentsliderpos <= number_of_frames & currentsliderpos >= 1,
					newsliderpos = currentsliderpos;
				else,
					newsliderpos = number_of_frames;
				end
				set(handles.ImageSlider,'sliderstep',sliderstep,'min',1,'max',number_of_frames,...
					'value',newsliderpos);
			end;
			image_viewer_gui(name,'command',[name 'Draw_Image'],'ud',ud);
			image_viewer_gui(name,'command',[name 'Draw_Histogram'],'fig',fig);
		end;

	case 'reset_axes_size', % resets the image view
		if ~isempty(ud.imfile) & ~isempty(ud.iminfo),
			handles = image_viewer_gui(name,'command',[name 'get_handles'],'fig',fig);
			axes(handles.ImageAxes);
			axis([0.5 ud.iminfo(1).Width+0.5 0.5 ud.iminfo(1).Height+0.5]);
			set(handles.ImageAxes,'tag',[name 'ImageAxes']); % seems to get reset by some commands
			box off;
		end;
	case 'getslider', % get the slider value
		handles = image_viewer_gui(name,'command',[name 'get_handles'],'fig',fig);
		out = round(get(handles.ImageSlider,'value'));

	case 'getslice', % get the slice value
		handles = image_viewer_gui(name,'command',[name 'get_handles'],'fig',fig);
		v = round(get(handles.ImageSlider,'value'));
		out = 1+length(ud.iminfo)-v;

	case 'draw_image',
		if ~isempty(ud.imfile),
			handles = image_viewer_gui(name,'command',[name 'get_handles'],'fig',fig);
			v = round(get(handles.ImageSlider,'value'));
			vars = image_viewer_gui(name,'command',[name 'get_vars'],'fig',fig);

			oldimg = findobj(handles.ImageAxes,'tag','image');
			if ~isempty(oldimg), delete(oldimg); end;
			%disp(['getting ready to draw frame ' int2str(1+length(ud.iminfo)-v)]);
			im = imread(ud.imfile, 'index', 1+length(ud.iminfo)-v);
			if size(im,3)==4, % assume cmyk
				im = cmyk2rgb(double(im));
			end;
			currentAx = gca;
			axes(handles.ImageAxes);
			im = double(im); % make sure it is a double
			for i=1:size(im,3),
				im(:,:,i) = rescale(im(:,:,i),[vars.ImageScaleParams.Min(i) vars.ImageScaleParams.Max(i)],...
						[vars.ImageDisplayScaleParams.Min(i) vars.ImageDisplayScaleParams.Max(i)]);
			end;
			if ~isempty(ud.imagemodifierfunc),
				im = eval([ud.imagemodifierfunc ';']);
			end
			h=image(im);
			set(h,'tag','image');
			box off;
			set(handles.ImageAxes,'tag',[name 'ImageAxes']);
			axes(currentAx); % make old axes current
			if size(im,3)==1, % grayscale
				colormap(gray(256));
			end
			image_viewer_gui(name,'command',[name 'movetoback'],'fig',fig);
			if ~isempty(ud.drawcompletionfunc),
				eval([ud.drawcompletionfunc ';']);
			end;
		else,
			error(['image not loaded.']);
		end;
		image_viewer_gui(name,'command',[name 'UpdateControls'],'fig',fig);        

	case {'imagescaleminedit','imagescalemaxedit'},
		handles = image_viewer_gui(name,'command',[name 'get_handles'],'fig',fig);
		minstr = get(handles.ImageScaleMinEdit,'string');
		maxstr = get(handles.ImageScaleMaxEdit','string');
		try,
		    mins = str2num(minstr);
		    maxes = str2num(maxstr);
		catch,
		    error(['Error in min/max image values.']);
		end;
		% now check for errors
		ud.ImageScaleParams.Min = mins;
		ud.ImageScaleParams.Max = maxes;
		image_viewer_gui(name,'command',[name 'Set_Vars'],'ud',ud);
		image_viewer_gui(name,'command',[name 'Draw_Image'],'fig',fig);
		image_viewer_gui(name,'command',[name 'Draw_Histogram'],'fig',fig);        
        
	case 'updatecontrols',
		image_viewer_gui(name,'command',[name 'updateImageScaleEdits'],'fig',fig);
    
	case 'updateimagescaleedits',
		handles = image_viewer_gui(name,'command',[name 'get_handles'],'fig',fig);
		minstr = mat2str(ud.ImageScaleParams.Min);
		maxstr = mat2str(ud.ImageScaleParams.Max);
		set(handles.ImageScaleMinEdit,'string',minstr);
		set(handles.ImageScaleMaxEdit,'string',maxstr);

	case 'movetoback', % move image to back
		handles = image_viewer_gui(name,'command',[name 'get_handles'],'fig',fig);
		currentAxes = gca;
		axes(handles.ImageAxes);
		im=findobj(gca,'tag','image');
		if ~isempty(im), movetoback(im); end;
		axes(currentAxes);

	case 'imageslider',
		handles = image_viewer_gui(name,'command',[name 'get_handles'],'fig',fig);
		v = get(handles.ImageSlider,'value');
		set(handles.ImageSlider,'value',round(v));
		if round(v)~=ud.previousslidervalue,
			ud.previousslidervalue = round(v);
			image_viewer_gui(name,'command',[name 'Set_Vars'],'ud',ud);
			%disp(['Drawing image now']);
			image_viewer_gui(name,'command',[name 'Draw_Image'],'fig',fig);
		end;

	case 'draw_histogram',
		if ~isempty(ud.imfile) & ud.showhistogram,
			handles = image_viewer_gui(name,'command',[name 'get_handles'],'fig',fig);
			[pts,imsize] = image_samplepoints(ud.imfile,10000,'random','info',ud.iminfo);
			pts = pts(:);
			[counts,bin_centers]=autohistogram(double(pts));
			currentAxes = gca;
			axes(handles.HistogramAxes);
			hold off;
			bar(bin_centers,counts,1);
			hold on;
			binwidth = bin_centers(2) - bin_centers(1);
			set(gca,'xlim',[bin_centers(1)-binwidth/2 bin_centers(end)+binwidth/2]);
			box off;
			set(handles.HistogramAxes,'tag',[name 'HistogramAxes']);
			axes(currentAxes); % restore previous axes
		end;
		image_viewer_gui(name,'command',[name 'UpdateControls'],'fig',fig);        

	case 'zoomtogglebutton',
		% future
	case 'pantogglebutton',
		% future

	otherwise,
		disp(['Unknown command ' command ]);
end;

