function varargout = nbio140_wholecell(varargin)
% NBIO140_WHOLECELL - A gui to simulate a Hodgkin-Huxley recording in voltage clamp/current clamp
%
%   vlt.neuro.demos.nbio140_wholecell()
%
%   Brings up a graphical user interface to allow the user to explore a
%   current clamp/voltage clamp environment with Hodgkin-Huxley channels.
%


 % TO DO:

 % internal variables, for the function only

command = 'Main';    % internal variable, the command
fig = '';                 % the figure
success = 0;
windowheight =      525;
windowwidth =       800;
windowrowheight =    35;
HH = vlt.neuro.models.hh.HHclass();
HHsyn = vlt.neuro.models.hh.HHsynclass();

 % user-specified variables
windowlabel = 'NBIO140 CELL SIMULATOR';

varlist = {'windowheight','windowwidth','windowrowheight','windowlabel','HH','HHsyn'};

w = which('vlt.data.assign');
if isempty(w),
	mypath = which('vlt.neuro.demos.nbio140_wholecell');
	parentdir = fileparts(mypath);
	addpath(genpath(parentdir));
	clear mex;
end;

assign(varargin{:});

if isempty(fig),
	z = findobj(allchild(0),'flat','tag','vlt.neuro.demos.nbio140_wholecell');
	if isempty(z),
		fig = figure('name',windowlabel,'NumberTitle','off','Color',[0.8 0.8 0.8]); % we need to make a new figure
	else,
		fig = z;
		figure(fig);
	end;
end;

 % initialize userdata field
if strcmp(command,'Main'),
	for i=1:length(varlist),
		eval(['ud.' varlist{i} '=' varlist{i} ';']);
	end;
else,
	ud = get(fig,'userdata');
end;

%command,

switch command,
	case 'Main',
		set(fig,'userdata',ud);
		vlt.neuro.demos.nbio140_wholecell('command','NewWindow','fig',fig);
	case 'NewWindow',
		% control object defaults

		% this callback was a nasty puzzle in quotations:
		callbackstr = [  'eval([get(gcbf,''Tag'') ''(''''command'''','''''' get(gcbo,''Tag'') '''''' ,''''fig'''',gcbf);'']);']; 

		button.Units = 'pixels';
                button.BackgroundColor = [0.8 0.8 0.8];
                button.HorizontalAlignment = 'center';
                button.Callback = callbackstr;
                txt.Units = 'pixels';
		txt.BackgroundColor = [0.8 0.8 0.8];
                txt.fontsize = 12;
		txt.fontweight = 'normal';
                txt.HorizontalAlignment = 'left';
		txt.Style='text';
                edit = txt;
		edit.BackgroundColor = [ 1 1 1];
		edit.Style = 'Edit';
                popup = txt;
		popup.style = 'popupmenu';
                popup.Callback = callbackstr;
		list = txt;
		list.style = 'list';
		list.Callback = callbackstr;
                cb = txt;
		cb.Style = 'Checkbox';
                cb.Callback = callbackstr;
                cb.fontsize = 12;

		right = ud.windowwidth;
		top = ud.windowheight;
		row = ud.windowrowheight;

		set(fig,'position',[50 50 right top],'tag','vlt.neuro.demos.nbio140_wholecell');

		% TOP

		uicontrol(txt,'position',[5 top-row*1 250 30],'string',ud.windowlabel,'horizontalalignment','left','fontweight','bold', ...
			'fontsize',14);

		% upper-right pop-up menu
		uicontrol(txt,'position',[right-200 top-row*1 100 30],'string','Exercise:','horizontalalignment','left','fontweight','bold');
		uicontrol(popup,'position',[right-100 top-row*1 100 30],'string',{'Choose','---','Lab 1','Lab 2','Lab 3','Lab 4'},'value',1,'tag','LabPopup');

		% LEFT: CELL AND SYNAPSE PARAMETERS

		paramwidth = 130;

		% cell parameter group, upper left
		uicontrol(txt,'position',[5 top-row*2 200 30],'string','Cell properties','horizontalalignment','left','fontweight','bold');
		uicontrol(txt,'position',[5 top-row*3 100 30],'string','[R_L Cm]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*3 paramwidth 30],'string','[33.3e6 100e-12]','tag','RlCmEdit');
		uicontrol(txt,'position',[5 top-row*4 100 30],'string','[E_L E_Na E_K]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*4 paramwidth 30],'string','[-0.075 0.045 -0.082]','tag','RevEdit');
		uicontrol(txt,'position',[5 top-row*5 100 30],'string','[GNa GK]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*5 paramwidth 30],'string','[12e-6 3.6e-6]','tag','ChannelConductancesEdit');
		uicontrol(txt,'position',[5 top-row*6 100 30],'string','[V_initial]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*6 paramwidth 30],'string','[-0.065]','tag','V_initial_Edit');

		% synapse parameter group, lower left
		uicontrol(txt,'position',[5 top-row*7 200 30],'string','Synapse properties','horizontalalignment','left','fontweight','bold');
		uicontrol(txt,'position',[5 top-row*8 100 30],'string','[E_E E_I]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*8 paramwidth 30],'string','[0 -0.090]','tag','SynRevEdit');
		uicontrol(txt,'position',[5 top-row*9 100 30],'string','GLUT: [P N Q]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*9 paramwidth 30],'string','[0.5 10 12e-10]','tag','GLUT_Syn_Edit');
		uicontrol(txt,'position',[5 top-row*10 100 30],'string','GABA: [P N Q]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*10 paramwidth 30],'string','[0.5 10 12e-10]','tag','GABA_Syn_Edit');
		uicontrol(txt,'position',[5 top-row*11 100 30],'string','E1 SynTime: [1 2]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*11 paramwidth 30],'string','[0 2]','tag','ESyn1TimesEdit');
		uicontrol(txt,'position',[5 top-row*12 100 30],'string','E2 SynTime: [1 2]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*12 paramwidth 30],'string','[2 5]','tag','ESyn2TimesEdit');
		uicontrol(txt,'position',[5 top-row*13 100 30],'string','I SynTime: [1 2]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*13 paramwidth 30],'string','[2 5]','tag','ISynTimesEdit');
		uicontrol(txt,'position',[5 top-row*14 100 30],'string','[VR F F_tau]','horizontalalignment','left');
		uicontrol(edit,'position',[5+100 top-row*14 paramwidth 30],'string','[0.1 0.2 0.150]','tag','SynDynamicsEdit');
			
		% AXES, IN CENTER COLUMN

		ax_left = 210+75;
		ax_right = right - 210;
		ax_width = ax_right - ax_left + 1;

		ax_v = axes('units','pixels','position',[ax_left top-row*5 ax_width row*4],'tag','VoltageAxes');
		axis([0 0.5 -0.120 0.05]);
		title('Voltage');
		ylabel('Vm (V)');
		ax_i = axes('units','pixels','position',[ax_left top-row*10 ax_width row*4],'tag','CurrentAxes');
		axis([0 0.5 -5e-9 5e9]);
		title('Current');
		ylabel('Im (A)');
		ax_chan = axes('units','pixels','position',[ax_left top-row*14 ax_width row*3],'tag','ChannelOpenAxes');
		axis([0 0.5 0 100]);
		title('Channels open');
		ylabel('Percent Open');
		xlabel('Time (s)');
		linkaxes([ax_v ax_i ax_chan],'x');
		
		% RIGHT COLUMN
		rightcol_left = right - 200;
		skip = 5;
		middle = 100;
		
		% operation
		uicontrol(txt,'position',  [skip+rightcol_left top-row*2 200 30],'string','Operation',...
			'horizontalalignment','left','fontweight','bold');
		uicontrol(txt,'position',  [skip+rightcol_left top-row*3 100 30],'string','Mode:','horizontalalignment','left');
		uicontrol(popup,'position',[skip+rightcol_left+middle-30 top-row*3 100+30 30],'string',{'Current Clamp', 'Voltage Clamp'},...
			'value',1,'tag','ClampPopup');
		uicontrol(txt,'position',  [skip+rightcol_left top-row*4 100 30],'string','Step [1 2]','horizontalalignment','left');
		uicontrol(edit,'position', [skip+rightcol_left+middle top-row*4 100-5 30],'string','[1e-9 0]', 'tag','StepValuesEdit');
		uicontrol(txt,'position',  [skip+rightcol_left top-row*5 100 30],'string','Step Time [1 2]','horizontalalignment','left');
		uicontrol(edit,'position', [skip+rightcol_left+middle top-row*5 100-5 30],'string','[0 0.5]', 'tag','StepTimesEdit');
		uicontrol(txt,'position',  [skip+rightcol_left top-row*6 100 30],'string','Sin [Amp F]','horizontalalignment','left');
		uicontrol(edit,'position', [skip+rightcol_left+middle top-row*6 100-5 30],'string','[0 4]', 'tag','SinAmpFEdit');
		uicontrol(cb,'position',   [skip+rightcol_left top-row*7 100 30],'string','TEA','value',0,'tag','TEACB');
		uicontrol(cb,'position',   [skip+rightcol_left+middle top-row*7 100 30],'string','TTX','value',0,'tag','TTXCB');
		uicontrol(cb,'position',   [skip+rightcol_left top-row*8 100 30],'string','AMPA','value',0,'tag','AMPACB');
		uicontrol(cb,'position',   [skip+rightcol_left+middle top-row*8 100 30],'string','NMDA','value',0,'tag','NMDACB');
		uicontrol(cb,'position',   [skip+rightcol_left top-row*9 100 30],'string','GABA','value',0,'tag','GABACB');
		uicontrol(cb,'position',   [skip+rightcol_left+middle top-row*9 100 30],'string','Sr2+','value',0,'tag','SRCB');
		uicontrol(cb,'position',   [skip+rightcol_left top-row*10 200 30],'string','Na Inactivation','value',1,'tag','NAINACTCB');

		uicontrol(button,'position',[skip+rightcol_left top-row*13 100-skip 30],'string','Run','tag','RunBt','userdata',0);
		uicontrol(button,'position',[skip+rightcol_left+middle+skip top-row*13 100-3*skip 30],'string','Pause','tag','PauseBt','visible','off');

		ch = get(fig,'children');
		set(ch,'units','normalized');

		set(fig,'userdata',ud);

	case 'GetParameters',
		p_struct.label = 'Parameters for HH model';
		tags = {...
			'RlCmEdit','RevEdit','ChannelConductancesEdit','V_initial_Edit',... % cell parameters group
			'SynRevEdit','GLUT_Syn_Edit','GABA_Syn_Edit', ... % synapse group 1
			'ESyn1TimesEdit', 'ESyn2TimesEdit', 'ISynTimesEdit','SynDynamicsEdit', ... % synapse parameters group 2
			'StepValuesEdit','StepTimesEdit','SinAmpFEdit' ... % clamp parameters group
			};
		numels = [2 3 2 1 ...  % number of elements required
				2 3 3 ...
				2 2 2 3 ...
				2 2 2];

		for i=1:numel(tags),
			s = get(findobj(fig,'tag',tags{i}),'string');
			try,
				v = eval(s);
			catch,
				errordlg(['Syntax error in ' tags{i} ': cannot evaluate ' s '.']);
			end;
			if numel(v)~=numels(i),
				errordlg(['Value in ' tags{i} ' did not have expected number of elements (' int2str(numels(i)) ').']);
			end;
			p_struct = setfield(p_struct,tags{i},v);
		end;

		value_tags = { 'ClampPopup', 'TEACB', 'TTXCB', 'AMPACB', 'NMDACB', 'GABACB', 'SRCB', 'NAINACTCB' };
		for i=1:numel(value_tags),
			v = get(findobj(fig,'tag',value_tags{i}),'value');
			p_struct = setfield(p_struct,value_tags{i},v);
		end;

		varargout{1} = p_struct;
	case 'RunBt',
		if ud.HH.samplenumber_current <= 1 | ud.HH.samplenumber_current >= size(ud.HH.S,2) -1,
			% need to set up
			p_struct = vlt.neuro.demos.nbio140_wholecell('command','GetParameters','fig',fig);
			useSyn = 0;
			if any([p_struct.AMPACB p_struct.NMDACB p_struct.GABACB]),
				useSyn = 1;
			end;
			if useSyn, 
				HH = ud.HHsyn;
			else,
				HH = ud.HH;
			end;
			
			HH.step1_time = p_struct.StepTimesEdit(1);
			HH.step2_time = p_struct.StepTimesEdit(2);
			HH.step1_value = p_struct.StepValuesEdit(1);
			HH.step2_value = p_struct.StepValuesEdit(2);
			HH.S(1,1) = p_struct.V_initial_Edit(1);
			HH.V_initial = p_struct.V_initial_Edit(1);
			HH.involtageclamp = (p_struct.ClampPopup==2);
			HH = HH.setup_command('A',p_struct.SinAmpFEdit(1),'f',p_struct.SinAmpFEdit(2));

			if useSyn,
				HH.AMPA = p_struct.AMPACB;
				HH.NMDA = p_struct.NMDACB;
				HH.GABA = p_struct.GABACB;
				HH.SR = p_struct.SRCB;
				HH.facilitation = p_struct.SynDynamicsEdit(2);
				HH.facilitation_tau = p_struct.SynDynamicsEdit(3);
				HH.V_recovery_time = p_struct.SynDynamicsEdit(1);
				HH.E_ESyn = p_struct.SynRevEdit(1);
				HH.E_ISyn = p_struct.SynRevEdit(2);
				HH.GLUT_PNQ = p_struct.GLUT_Syn_Edit; 
				HH.GABA_PNQ = p_struct.GABA_Syn_Edit;

				HH.ESyn1_times = p_struct.ESyn1TimesEdit; 
				HH.ESyn2_times = p_struct.ESyn2TimesEdit; 
				HH.ISyn_times  = p_struct.ISynTimesEdit;  
				HH = HH.setup_synapses();
			end;
				
			if useSyn,
				ud.HHsyn = HH;
			else,
				ud.HH = HH;
			end;
			set(fig,'userdata',ud); % update userdata
		end;
		set(findobj(fig,'tag','RunBt'),'userdata',1);
		vlt.neuro.demos.nbio140_wholecell('command','Step','fig',fig);
	case 'Step', % make a step in the simulation
		if get(findobj(fig,'tag','RunBt'),'userdata'),
			p_struct = vlt.neuro.demos.nbio140_wholecell('command','GetParameters','fig',fig);
			useSyn = 0;
			if any([p_struct.AMPACB p_struct.NMDACB p_struct.GABACB]),
				useSyn = 1;
			end;
			if useSyn,
				HH = ud.HHsyn;
			else,
				HH = ud.HH;
			end;

			% Step 1: set parameters
			HH.G_L = 1/p_struct.RlCmEdit(1);
			HH.G_Na = p_struct.ChannelConductancesEdit(1)*(1-p_struct.TTXCB);
			HH.G_K = p_struct.ChannelConductancesEdit(2)*(1-p_struct.TEACB);
			HH.Cm = p_struct.RlCmEdit(2);
			HH.E_leak = p_struct.RevEdit(1);
			HH.E_K = p_struct.RevEdit(3);
			HH.E_Na = p_struct.RevEdit(2);
			HH.Na_Inactivation_Enable = p_struct.NAINACTCB;
			HH.TTX = p_struct.TTXCB;
			HH.TEA = p_struct.TEACB;

			% Step 2: run simulation

			HH = HH.simulate();
			set(fig,'userdata',ud);

			% in this preliminary mode, cancel the Run
			set(findobj(fig,'tag','RunBt'),'userdata',0);

			% Step 3: update the plot and axes

			ax_v = findobj(fig,'tag','VoltageAxes');
			axes(ax_v);
			myline = findobj(ax_v,'tag','VoltagePlot');
			if ~isempty(myline),
				set(myline,'xdata',HH.t,'ydata',HH.S(1,:));
			else,
				cla;
				h=plot(HH.t, HH.S(1,:),'k');
				box off;
				set(h,'tag','VoltagePlot');
			end;
			axis([HH.t(1) HH.t(end) -0.125 0.1]);
			set(ax_v,'tag','VoltageAxes');
			zoom reset;
			title('Voltage');

			ax_i = findobj(fig,'tag','CurrentAxes');
			axes(ax_i);
			myline = findobj(ax_i,'tag','CurrentPlot');
			if ~isempty(myline),
				set(myline,'xdata',HH.t,'ydata',HH.I);
			else,
				cla;
				h=plot(HH.t, HH.I,'k');
				box off;
				set(h,'tag','CurrentPlot');
			end;
			if p_struct.ClampPopup == 1,
				axis([HH.t(1) HH.t(end) -1e-9 3e-9]);
			else,
				axis([HH.t(1) HH.t(end) -100e-9 300e-9]);
			end;
			zoom reset;
			set(ax_i,'tag','CurrentAxes');
			title('Current');

			ax_c = findobj(fig,'tag','ChannelOpenAxes');
			axes(ax_c);
			hold on;
			names = {'Na_{Open}','K_{Open}','Na_{Inactivated}'};
			vals = {};
			if p_struct.NAINACTCB,
				vals{1} =  100*(HH.mvar() .*HH.mvar() .* HH.mvar() .* HH.hvar());
			else,
				vals{1} =  100*(HH.mvar() .*HH.mvar() .* HH.mvar() );
			end;
			if p_struct.TTXCB,
				vals{1} = 0 * vals{1};
			end;
			vals{2} = 100 * (power(HH.nvar(),4));
			if p_struct.TEACB,
				vals{2} = 0 * vals{2};
			end;
			vals{3} = 100 * (1-HH.hvar())*p_struct.NAINACTCB;
			cols = ['bgm'];
			for i=1:numel(names),
				myline = findobj(ax_c,'tag',names{i});
				if ~isempty(myline),
					set(myline,'xdata',HH.t, 'ydata', vals{i});
				else,
					h=plot(HH.t, vals{i},cols(i));
					set(h,'tag',names{i});
				end;
			end;
			box off;
			legend(names);
			axis([HH.t(1) HH.t(end) 0 100]);
			set(ax_c,'tag','ChannelOpenAxes');
			zoom reset;
			title('Channels open');

			if useSyn,
				ud.HHsyn = HH;
			else,
				ud.HH = HH;
			end;
		end;
		% if we are still running, call Step again
		if get(findobj(fig,'tag','RunBt'),'userdata'),
			vlt.neuro.demos.nbio140_wholecell('command','Step','fig',fig);
		end;
	case 'PauseBt',
		set(findobj(fig,'RunBt','userdata',0));
	case 'LabPopup',
		v = get(findobj(fig,'tag','LabPopup'),'value');
		if v<=2, 
			set(findobj(fig,'tag','LabPopup'),'value',1);
			return;
		end;
		tags = {...
			'RlCmEdit','RevEdit','ChannelConductancesEdit','V_initial_Edit',... % cell parameters group
			'SynRevEdit','GLUT_Syn_Edit','GABA_Syn_Edit', ... % synapse parameter group
			'ESyn1TimesEdit', 'ESyn2TimesEdit', 'ISynTimesEdit', 'SynDynamicsEdit', ... % synapse parameters group
			'StepValuesEdit','StepTimesEdit','SinAmpFEdit' ... % clamp parameters group
			};
		value_tags = { 'ClampPopup', 'TEACB', 'TTXCB', 'AMPACB', 'NMDACB', 'GABACB', 'SRCB', 'NAINACTCB' };
		switch v,
			case 1+2, % Lab 1
				string_values = {'[33.3e6 100e-12]', '[-0.075 0.045 -0.082]', '[12e-6 3.6e-6]', '[-0.073]', ...
					'[0 -0.090]', '[0.5 20 13e-10]', '[0.5 10 30e-10]', ...
					'[0 5]', '[2 5]', '[2 5]', '[0.1 0.2 0.150]', ...
					'[0.5e-9 0]', '[0 0.5]', '[0 4]' };
				value_values = { 1, 0, 0, 0, 0, 0, 0, 1 };
			case 2+2,
				string_values = {'[33.3e6 100e-12]', '[-0.075 0.045 -0.082]', '[12e-6 3.6e-6]', '[-0.073]', ...
					'[0 -0.090]', '[0.5 20 13e-10]', '[0.5 10 30e-10]', ...
					'[0 5]', '[2 5]', '[2 5]', '[0.1 0.2 0.150]', ...
					'[0.5e-9 0]', '[0 0.5]', '[0 4]' };
				value_values = { 1, 0, 0, 0, 0, 0, 0, 1 };
			case 3+2,
				string_values = {'[33.3e6 100e-12]', '[-0.075 0.045 -0.082]', '[12e-6 3.6e-6]', '[-0.073]', ...
					'[0 -0.090]', '[0.5 20 13e-10]', '[0.5 10 30e-10]', ...
					'[0 5]', '[2 5]', '[2 5]', '[0.1 0.2 0.150]', ...
					'[-1e-9 0]', '[0 0.5]', '[0 4]' };
				value_values = { 1, 1, 1, 0, 0, 0, 0, 1 };
			case 4+2,
				string_values = {'[33.3e6 100e-12]', '[-0.075 0.045 -0.082]', '[12e-6 3.6e-6]', '[-0.073]', ...
					'[0 -0.090]', '[0.5 20 13e-10]', '[0.5 10 30e-10]', ...
					'[0 5]', '[2 5]', '[2 5]', '[0.1 0.2 0.150]', ...
					'[0 0]', '[-0.1 0.5]', '[0 4]' };
				value_values = { 1, 0, 0, 1, 1, 0, 0, 1 };
		end;

		for i=1:numel(tags),
			set(findobj(fig,'tag',tags{i}),'string',string_values{i});
		end;
		for i=1:numel(value_tags),
			set(findobj(fig,'tag',value_tags{i}),'value',value_values{i});
		end;
		set(findobj(fig,'tag','LabPopup'),'value',1);
end;
