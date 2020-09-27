function varargout=simpleodedemo(varargin)
% SIMPLEODEDEMO - A simple demonstration of a first order, ordinary differential equation
%
%  vlt.neuro.models.ode.simpleodedemo - Popups up a window that allows the user to watch
%  the operation of a simple ode.  The equation simulated is the following:
%
%  tau * d r(t)/dt = -(r(t)-C)+I
%
%  The window has graphical user elements that allow the user to
%  specify all of the parameters and to watch the simulation run.
%


command = 'Main';
fig = '';
windowheight = 550;
windowwidth = 750;
windowrowheight = 35;

windowlabel = 'Simple ODE Demo';

varlist = {'windowheight','windowwidth','windowrowheight'};

if nargin==1, % it's a callback object, pull fig and command out
	fig = gcbf;
	command = get(varargin{1},'tag');
else,
	vlt.data.assign(varargin{:});
end;

if isempty(fig),
	z = findobj(allchild(0),'flat','tag','vlt.neuro.models.ode.simpleodedemo');
	if isempty(z),
		fig = figure;
	else,
		fig = z;
		figure(fig);
		return; % just pop up the existing figure
	end;
end;

if strcmp(command,'Main'),
	 % initialize userdata field of figure, to store our variables
	for i=1:length(varlist),
		eval(['ud.' varlist{i} '=' varlist{i} ';']);
	end;
else,
	ud = get(fig,'userdata');
end;

switch command, % now process the command
	case 'Main',
		set(fig,'userdata',ud);
		vlt.neuro.models.ode.simpleodedemo('command','NewWindow','fig',fig);
	case 'NewWindow',
		vlt.ui.myuiinit;
		right = ud.windowwidth;
		top = ud.windowheight;
		row = ud.windowrowheight;

		leftright_divider = right-200;
		axleft = 70;
		labels_left = 10;
		labels_top = 435;
		
		uicontrol(txt,'position',[50 top-100 right-50 75],'string','tau d r(t)/dt = -(r(t)-C)+I',...
			'fontweight','bold','fontsize',16);

		set(fig,'position',[50 50 right top],'tag','vlt.neuro.models.ode.simpleodedemo','name','simpleodedemo',...
			'numbertitle','off');
		axes('units','pixels','position',[axleft 50 leftright_divider-axleft 180],'tag','rateAx');
		axes('units','pixels','position',[axleft 205+50 leftright_divider-axleft 180],'tag','inputAx');
		txt.horizontalalignment = 'left';
		uicontrol(txt,'position',[leftright_divider+labels_left labels_top-row*1 100 20],...
			'string','Variables:','fontweight','bold');
		uicontrol(txt,'position',[leftright_divider+labels_left labels_top-row*3 50 20],...
			'string','r(0):','tag','r0Txt');
		uicontrol(txt,'position',[leftright_divider+labels_left labels_top-row*4 50 20],...
			'string','tau:','tag','tauTxt');
		uicontrol(txt,'position',[leftright_divider+labels_left labels_top-row*5 50 20],...
			'string','C:','tag','CTxt');
		uicontrol(txt,'position',[leftright_divider+labels_left labels_top-row*6 50 20],...
			'string','I mag:','tag','IMagTxt');
		uicontrol(txt,'position',[leftright_divider+labels_left labels_top-row*7 50 20],...
			'string','I type:','tag','ItypeTxt');
		uicontrol(txt,'position',[leftright_divider+labels_left labels_top-row*8 50 20],...
			'string','dT:','tag','dT text');
		uicontrol(txt,'position',[leftright_divider+labels_left labels_top-row*9 50 20],...
			'string','Time:','tag','Duration text');
		uicontrol(button,'position',[(leftright_divider+right-100)/2 labels_top-row*11 100 20],...
			'string','Simulate','tag','SimulateBt','fontweight','bold');
		uicontrol(uiedit,'position',[leftright_divider+labels_left+105-50 labels_top-row*3 120 20],...
			'string','10','tag','r0Edit');
		uicontrol(uiedit,'position',[leftright_divider+labels_left+105-50 labels_top-row*4 120 20],...
			'string','0.030','tag','tauEdit');
		uicontrol(uiedit,'position',[leftright_divider+labels_left+105-50 labels_top-row*5 120 20],...
			'string','0','tag','CEdit');
		uicontrol(uiedit,'position',[leftright_divider+labels_left+105-50 labels_top-row*6 120 20],...
			'string','0','tag','IMagEdit');
		uicontrol(popup,'position',[leftright_divider+labels_left+105-50 labels_top-row*7 120 20],...
			'string',{'Constant','Sinewave'},'tag','ItypePopup');
		uicontrol(uiedit,'position',[leftright_divider+labels_left+105-50 labels_top-row*8 120 20],...
			'string','0.01','tag','dTEdit');
		uicontrol(uiedit,'position',[leftright_divider+labels_left+105-50 labels_top-row*9 120 20],...
			'string','1','tag','DurationEdit');
	case 'GetVars', % read the inputs
		varargout{1}=str2num(get(findobj(fig,'tag','r0Edit'),'string'));       % r0
		varargout{2}=str2num(get(findobj(fig,'tag','tauEdit'),'string'));      % tau
		varargout{3}=str2num(get(findobj(fig,'tag','CEdit'),'string'));        % C
		varargout{4}=str2num(get(findobj(fig,'tag','IMagEdit'),'string'));     % I
		varargout{5}=        get(findobj(fig,'tag','ItypePopup'),'value');     % I_type
		varargout{6}=str2num(get(findobj(fig,'tag','dTEdit'),'string'));       % dT
		varargout{7}=str2num(get(findobj(fig,'tag','DurationEdit'),'string')); % Duration
	case 'SimulateBt',
		[r0,tau,C,I,Itype,dT,Duration] = vlt.neuro.models.ode.simpleodedemo('command','GetVars','fig',fig);
		t = 0;
		r = r0;
		Inp = I;
		NumSteps = (Duration/dT);
		ax1 = findobj(fig,'tag','rateAx');
		box off;
		ax2 = findobj(fig,'tag','inputAx');
		box off;
		freq = [ 0 4 ]; % 0 or 4 Hz, constant or a 4 Hz sinewave
		i = 1;
		while (i<=NumSteps),
			t(end+1) = t(end) + dT;
			Inp(end+1) = I*cos(2*pi*t(end)*freq(Itype));
			r(end+1) = r(end) + (dT/tau) * (-(r(end)-C)+Inp(end));
			axes(ax1);
			h1=plot(t,r,'b','linewidth',2);
			xlabel('Time (s)');
			set(gca,'xlim',[0 Duration],'tag','rateAx');
			ylabel('r (Hz)');
			box off;
			axes(ax2);
			h2=plot(t,Inp,'g','linewidth',2);
			set(gca,'xlim',[0 Duration],'tag','inputAx');
			ylabel('I (Hz)');
			box off;
			drawnow;
			i = i + 1;
		end;
end;


