function varargout = cluster_points_gui(varargin)
% CLUSTER_POINTS_GUI - Cluster points into groups with manual checking
%
%   [CLUSTERIDS,CLUSTERINFO] = vlt.math.cluster_points_gui('POINTS', POINTS)
%
%   Brings up a graphical user interface to allow the user to cluster
%   POINTS (a structure with field names and 1-D values) using several algorithms.
%
%   POINTS should be a structure with fieldnames equal to the variable names 
%   (e.g., 'x', 'y', etc), and the value in each field name should be 1-dimensional. 
%
%   Additional parameters can be adjusted by passing name/value pairs 
%   at the end of the function:
%   
%   'clusterids'                           :    preliminary cluster ids
%   'ColorOrder'                           :    Color order for cluster drawings; defaults
%                                          :        to axes color order
%   'UnclassifiedColor'                    :    Color of unclassified spikes, default [0.5 0.5 0.5]
%   'RandomSubset'                         :    Do we plot a random subset of spikes? Default 1
%   'RandomSubsetSize'                     :    How many?  Default 200
%   'ForceQualityAssessment'               :    Should we force the user to choose cluster quality
%                                          :        before closing?  Default 1
%   'EnableClusterEditing'                 :    Should we enable cluster editing?  Default 1
%   'AskBeforeDone'                        :    Ask user to confirm they are really done Default 1
%   'MarkerSize'                           :    MarkerSize for plotting; default 10
%   'FigureName'                           :    Name of the figure; default "Cluster Points".
%   'IsModal'                              :    Is it a modal dialog? That is, should it stop all other
%                                          :        windows until the user finishes? Default is 1.
%                                          :        If the dialog is not modal then it cannot return
%                                          :        any values.

  % add number of spikes to cluster info, compute mean waveforms
   
 % internal variables, for the function only
command = 'Main';    % internal variable, the command
fig = '';                 % the figure
success = 0;
algorithms(1) = struct('name','KlustaKwik',...
	'code','ud.clusterids=klustakwik_cluster(ud.F,ud.clusters(1),ud.clusters(2),10,0);',...
	'ClusterSizeEdit','[2 4]','AlgorithmSizeTxt','# clusters [min max]');
algorithms(2) = struct('name','KMeans',...
	'code','ud.clusterids=kmeans(ud.F,ud.clusters);',...
	'ClusterSizeEdit','5','AlgorithmSizeTxt','# clusters:');

windowheight = 800;
windowwidth = 600;
windowrowheight = 35;
windowfeaturewidth = 500;
clusterinfo=struct('number',[],'qualitylabel','','number_of_points',0);
clusterinfo = clusterinfo([]);
ForceQualityAssessment = 1;
EnableClusterEditing = 1;
MarkerSize = 10;
FigureName = 'Cluster Points';
IsModal = 1;

 % user-specified variables
points = struct('a',1,'b',1);
points(2) = struct('a',0,'b',2);
clusterids = [];
ColorOrder = [0 0 1; 0 0.5 0; 1 0 0; 0 0.75 0.75; 0.75 0 0.75; 0.75 0.75 0; 0.25 0.25 0.25];
UnclassifiedColor = [0.5 0.5 0.5];
NotPresentColor = 2*[ 0.5 0.25 0.25];
RandomSubset = 1;
RandomSubsetSize = 200;
windowlabel = 'Cluster Points';
ClusterRightAway = 0;
AskBeforeDone = 1;

varlist = {'success','features','algorithms','points',...
	'clusterids','windowheight','windowwidth','windowrowheight',...
	'ColorOrder','UnclassifiedColor','NotPresentColor','windowfeaturewidth','clusterinfo','RandomSubset','RandomSubsetSize','windowlabel',...
	'ForceQualityAssessment','EnableClusterEditing',...
	'AskBeforeDone','MarkerSize','clusterids_initial','clusterinfo_initial','FigureName','IsModal'};

vlt.data.assign(varargin{:});

features = fieldnames(points);

if isempty(fig),
	fig = figure;
end;

if isempty(points),
	emptypoints = 1;
elseif vlt.data.eqlen(points,-1),
	emptypoints = 0;
	points = [];
else,
	emptypoints = 0;
end;

 % initialize userdata field
if strcmp(command,'Main'),
	clusterids_initial = [];
	clusterinfo_initial = [];

	for i=1:length(varlist),
		eval(['ud.' varlist{i} '=' varlist{i} ';']);
	end;
	if isempty(points)&~emptypoints, % user specified no points, so load the example points
		ud.points= getfield(load('example_points.mat','points'),'points');
		ud.clusterids = getfield(load('example_points.mat'),'clusterids');
		ud.clusterids_initial = getfield(load('example_points.mat'),'clusterids');
		ud.clusterinfo = getfield(load('example_points.mat'),'clusterinfo');
		ud.clusterinfo_info = getfield(load('example_points.mat'),'clusterinfo');
	end;
else,
	ud = get(fig,'userdata');
end;

switch command,
	case 'Main',
		if isempty(ud.clusterids),
			ud.clusterids = NaN(1,numel(ud.points));
		end;  % make sure there are initial assigned clusters

		if length(ud.clusterids)<numel(ud.points),
			ud.clusterids(end+1:numel(ud.points)) = NaN;
		end;

		if any(isnan(ud.clusterids)), % if we have NaN clusterids, make sure there is corresponding clusterinfo
			A = isempty(ud.clusterinfo);
			if ~A, 
				B = find(strncmp('NaN',{ud.clusterinfo.number},3));
			end;
			if A | isempty(B), % we need to add a clusterinfo for NaN
				ud.clusterinfo(end+1)=struct('number','NaN','qualitylabel','Unselected','number_of_points',sum(isnan(ud.clusterids)));
			end;
		end;

		ud.clusterids_initial = ud.clusterids;
		ud.clusterinfo_initial = ud.clusterinfo;

		set(fig,'userdata',ud);

		vlt.math.cluster_points_gui('command','NewWindow','fig',fig);
		if ~EnableClusterEditing,
			disablelist = {'MoveTo1Menu','MoveTo1Txt','ClusterAllBt','MergeTxt',...
					'MergeBt','Merge1Menu','Merge2Menu','AlgorithmTxt','AlgorithmMenu',...
					'ClusterSizeEdit','AlgorithmSizeTxt'};
			for i=1:length(disablelist),
				set(findobj(fig,'tag',disablelist{i}),'enable','off');
			end;
		end;
		if isempty(ud.clusterinfo),
			vlt.math.cluster_points_gui('command','InitClusterInfo','fig',fig);
		end;
		vlt.math.cluster_points_gui('command','FeatureMenu','fig',fig);
		drawnow;
		if ClusterRightAway,
			vlt.math.cluster_points_gui('command','ClusterAllBt','fig',fig);
		end;
		if ~ud.IsModal, 
			return;
		end; % if we are just sitting here, dont wait for output
		uiwait(fig); 
		ud = get(fig,'userdata');
		if nargout>=1,
			if ud.success, varargout{1} = ud.clusterids;
			else, varargout{1} = [];
			end;
		end;
		if nargout>=2,
			if ud.success, varargout{2} = ud.clusterinfo;
			else, varargout{2} = [];
			end;
		end;
		close(fig);
	case 'NewWindow',
		set(fig,'Name',ud.FigureName);

		% control object defaults
		% this callback was a nasty puzzle in quotations:
		callbackstr = [  'eval([get(gcbf,''Tag'') ''(''''command'''','''''' get(gcbo,''Tag'') '''''' ,''''fig'''',gcbf);'']);']; 

		button.Units = 'pixels';
                button.BackgroundColor = [0.8 0.8 0.8];
                button.HorizontalAlignment = 'center';
                button.Callback = callbackstr;
                txt.Units = 'pixels'; txt.BackgroundColor = [0.8 0.8 0.8];
                txt.fontsize = 12; txt.fontweight = 'normal';
                txt.HorizontalAlignment = 'left';txt.Style='text';
                edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';
                popup = txt; popup.style = 'popupmenu';
                popup.Callback = callbackstr;
                cb = txt; cb.Style = 'Checkbox';
                cb.Callback = callbackstr;
                cb.fontsize = 12;

		% feature list:

		right = ud.windowwidth;
		top = ud.windowheight;
		row = ud.windowrowheight;

                set(fig,'position',[50 50 right top],'tag','vlt.math.cluster_points_gui');

		uicontrol(button,'position',[5 top-row*1 100 30],'string','DONE','fontweight','bold','tag','DoneBt');
		uicontrol(button,'position',[5+100+10 top-row*1 100 30],'string','Cancel','fontweight','bold','tag','CancelBt');
		uicontrol(button,'position',[5+100+10+5+100 top-row*1+15 100 15],'string','Cluster all','fontweight','bold','tag','ClusterAllBt');
		uicontrol(button,'position',[5+100+10+5+100 top-row*1 100 15],'string','Cluster visible','fontweight','bold','tag','ClusterVisibleBt','enable','off');
		uicontrol(button,'position',[5+100+10+5+100+5+100 top-row*1 150 30],'string','Show initial clusters','fontweight','bold','tag','ShowInitialClustersBt');
		if isempty(ud.clusterids_initial), set(findobj(fig,'tag','ShowInitialClustersBt'),'enable','off'); end;

		uicontrol(txt,'position',[5 top-row*2 80 30],'string','Feature:','tag','FeatureTxt');
		uicontrol(popup,'position',[5+10+80 top-row*2 150 30],'string',ud.features,'value',1,'tag','FeatureMenu');
		%uicontrol(txt,'position',[5+10+80+150+5 top-row*2 100 30],'string',ud.features(1).FeatureText,'tag','FeatureText');
		%uicontrol(edit,'position',[5+10+80+150+5+100+5 top-row*2 100 30],'string',mat2str([0]),'tag','FeatureEdit','callback',callbackstr);

		uicontrol(txt,'position',[5 top-row*3 80 30],'string','Algorithm:','tag','AlgorithmTxt');
		uicontrol(popup,'position',[5+10+80 top-row*3 150 30],'string',{ud.algorithms.name},'value',1,'tag','AlgorithmMenu');
		uicontrol(txt,'position',[5+10+80+150+5 top-row*3 150 30],'string',ud.algorithms(1).AlgorithmSizeTxt,'tag','AlgorithmSizeTxt');
		uicontrol(edit,'position',[5+10+80+150+5+150+5 top-row*3+2 100 30],'string',ud.algorithms(1).ClusterSizeEdit,'tag','ClusterSizeEdit');

		uicontrol(txt,'position',[5 top-row*4 90 30],'string','Cluster actions:','tag','MergeTxt');
		uicontrol(popup,'position',[5+10+90+5 top-row*4 60 30],'string',{''},'value',1,'tag','Merge1Menu');
		uicontrol(txt,'position',[5+10+90+60+5 top-row*4 60 30],'string','merge with','tag','MergeToTxt');
		uicontrol(popup,'position',[5+10+90+60+5+60+5 top-row*4 60 30],'string',{''},'value',1,'tag','Merge2Menu');
		uicontrol(button,'position',[5+10+90+60+5+60+5+60+5 top-row*4 80 30],'string','Merge','tag','MergeBt');
		uicontrol(popup,'position',[5+10+90+60+5+60+5+60+5+80+5 top-row*4 120 30],'string',...
			{'Other actions','---','Move to cluster 1','---','Select points to add','Select points to exclude'}, ...
			'visible','on','tag','OtherActionMenu');

		%uicontrol(txt,'position',[5 top-row*5 150 30],'string','Move to cluster 1:','tag','MoveTo1Txt');
		%uicontrol(popup,'position',[5+10+150 top-row*5 60 30],'string',{''},'value',1,'tag','MoveTo1Menu');

		uicontrol(txt,'position',[5 top-row*5 80 30],'string','Cluster info:','tag','ClusterInfoTxt');
		%uicontrol(popup,'position',[5+10+80 top-row*5 80 30],'string',{''},'value',1,'tag','ClusterPropertyMenu'); % this is really a 'ClusterPropertyMenu' now; Merge1Menu now performs this function
		uicontrol(txt,'position',[5+10+80+80+5 top-row*5 50 30],'string','is','tag','QualityWithTxt');
		uicontrol(popup,'position',[5+10+80+60+5+60+5 top-row*5 200 30],'string',...
			{'Unselected','Not usable','Usable'},'value',1,'tag','QualityMenu');

		uicontrol(txt,'position',[5 5 80 30],'string','Click action:', 'tag', 'FeatureClickActionTxt','visible','off');
		uicontrol(popup,'position',[5+10+150-20 5 200 30],'string',{'Selects','Zooms','Rotates'},'value',1,'tag','FeatureClickMenu','visible','off');

		uicontrol(txt,'position',[5 top-row*8-2 80 30],'string', 'MarkerSize','tag','MarkerSizeText');
		uicontrol(edit,'position',[5+80+5 top-row*8+4 40 30],'string', int2str(ud.MarkerSize),'tag','MarkerSizeEdit','callback',callbackstr);
		uicontrol(cb,'position',[5+80+5+40+5 top-row*8+4 230 30],'string', 'Show subset of points','tag','RandomSubsetCB','value',ud.RandomSubset);
		uicontrol(txt,'position',[5+80+5+40+5+230+5 top-row*8-2 80 30],'string', 'Subset size','tag','RandomSubsetSizeText','visible','off');
		uicontrol(edit,'position',[5+80+5+40+5+230+5+80+5 top-row*8+4 50 30],'string', int2str(ud.RandomSubsetSize),...
				'tag','RandomSubsetSizeEdit','callback',callbackstr,'visible','off');

		axes('units','pixels','position',[50+25 5+2*row 500-20 top-11*row-10],'tag','FeatureAxes','ButtonDownFcn',callbackstr);

		uicontrol(cb,'position',[5 5+0*row 100 30],'string', 'Fixed axes','tag','FixedAxesCB','value',0);
		uicontrol(txt,'position',[5+100+5 5+0*row-3 130 30],'string', '[xmin xmax ymin ymax]','tag','AxesText');
		uicontrol(edit,'position',[5+100+5+130 5+0*row 200 30],'string', '[-2 0 -1 1]','tag','AxesEdit','callback',callbackstr);
		uicontrol(button,'position',[5+100+5+130+200+5 5+0*row 40 30],'string', 'auto','tag','AxesAutoBt');

		set(fig,'userdata',ud);
	case 'ShowInitialClustersBt',
		vlt.math.cluster_points_gui('points',ud.points,'clusterids',ud.clusterids_initial,'clusterinfo',ud.clusterinfo_initial,...
			'IsModal',0,'FigureName',[ud.FigureName ' - initial clusters'],'EnableClusterEditing',0,'AskBeforeDone',0,'ForceQualityAssessment',0,...
			'MarkerSize',ud.MarkerSize,'RandomSubset',ud.RandomSubset,'RandomSubsetSize',ud.RandomSubsetSize);
	case 'FeatureEdit',
		% Not needed here
		featureEditString = get(findobj(fig,'tag','FeatureEdit'),'string');
		good = 0;
		try,
			f = get(findobj(fig,'tag','FeatureMenu'),'value');
			if f==1,
				set(fig,'userdata',ud);
				good = 1;
			elseif f==2,
				set(fig,'userdata',ud);
				good = 1;
			end;
		catch,
			errordlg(['Error in setting spikewaves2NpointfeatureSampleList']);
			error(['Error in setting spikewaves2NpointfeatureSampleList']);
		end;
		if good, vlt.math.cluster_points_gui('command','FeatureMenu','fig',fig); end;
	case 'FeatureMenu',
		vlt.ui.nitemmenuselection(findobj(fig,'tag','FeatureMenu'),'ItemPrefix',{'x:','y:','z:'});
		selected = vlt.ui.nitemmenuselection(findobj(fig,'tag','FeatureMenu'),'ItemPrefix',{'x:','y:','z:'},'value',[]);
		if numel(selected)>0,
			ud.F = [];
			fn = fieldnames(ud.points);
			for i=1:numel(selected),
				eval(['c=vlt.data.colvec([ud.points.' fn{selected(i)} ']);' ]); 
				ud.F = cat(2,ud.F,c);
			end;
		else,
			ud.F = [];
		end;
		set(fig,'userdata',ud);
		vlt.math.cluster_points_gui('command','Draw','fig',fig);
	case 'ClusterAllBt',
		v = get(findobj(fig,'tag','AlgorithmMenu'),'value');
		cluster_number_string = get(findobj(fig,'tag','ClusterSizeEdit'),'string');
		good = 1;
		try,
			ud.clusters = str2num(cluster_number_string);
		catch,
			good = 0;
			errordlg(['Syntax error in # of clusters input: ' cluster_number_string '.'],'Syntax error');
		end;
		if good,
			try,
				eval(ud.algorithms(v).code);
			catch,
				errordlg(['Error in clustering: ' lasterr],'Cluster error');
				good = 0;
			end;
		end;
		if good,
			set(fig,'userdata',ud);
			vlt.math.cluster_points_gui('command','ReOrderMinToMax','fig',fig);
			vlt.math.cluster_points_gui('command','InitClusterInfo','fig',fig);
			vlt.math.cluster_points_gui('command','MakeClusters1toN','fig',fig);
			vlt.math.cluster_points_gui('command','Draw','fig',fig);
		end;
	case 'ClusterVisibleBt',
		v = get(findobj(fig,'tag','AlgorithmMenu'),'value');
		cluster_number_string = get(findobj(fig,'tag','ClusterSizeEdit'),'string');
		good = 1;
		try,
			ud.clusters = str2num(cluster_number_string);
		catch,
			good = 0;
			errordlg(['Syntax error in # of clusters input: ' cluster_number_string '.'],'Syntax error');
		end;
		if good,
			z = find(ud.algorithms(v).code=='=');
			z2 = findstr(ud.algorithms(v).code,'ud.F');
			indexes = vlt.math.cluster_points_gui('command','FindVisiblePoints','fig',fig);
			string_to_eval = [ud.algorithms(v).code(1:z-1) '(visiblespikes)' ud.algorithms(v).code(z) ...
					'max(ud.clusterids)+1+' ud.algorithms(v).code(z+1:z2+4) '(indexes,:)' ud.algorithms(v).code(z2+5:end)];
			try,
				eval(string_to_eval);
			catch,
				errordlg(['Error in clustering: ' lasterr],'Cluster error');
				good = 0;
			end;
		end;
		if good,
			set(fig,'userdata',ud);
			vlt.math.cluster_points_gui('command','ReOrderMinToMax','fig',fig);
			vlt.math.cluster_points_gui('command','InitClusterInfo','fig',fig);
			vlt.math.cluster_points_gui('command','MakeClusters1toN','fig',fig);
		end;
	case 'ReOrderMinToMax',
		clusters = unique(ud.clusterids);
		if isnan(clusters(end)),
			clusters = clusters(1:find(isnan(clusters),1,'first')); % take only 1 NaN from unique
		end;  
		minvalues = [];
		indshere = {};
		for i=1:length(clusters),
			indshere{i} = find(ud.clusterids==clusters(i));
			minvalues(end+1) = i; % punt for now
		end;
		[values,order] = sort(minvalues);
		for i=1:length(order),
			ud.clusterids(indshere{order(i)}) = i;
		end;
		set(fig,'userdata',ud);
	case 'InitClusterInfo',
		clusterinfo=struct('number',[],'qualitylabel','','number_of_points',[]);
		clusters = unique(ud.clusterids);
		if isnan(clusters(end)), clusters = clusters(1:find(isnan(clusters),1,'first')); end;  % take only 1 NaN from unique
		for i=1:length(clusters),
			if length(ud.clusterinfo)<i,
				if ~isnan(clusters(i)),
					indshere = find(ud.clusterids==clusters(i));
				else,
					indshere = find(isnan(ud.clusterids));
				end;
				ud.clusterinfo(i) = struct('number',int2str(clusters(i)),'qualitylabel','Unselected',...
						'number_of_points',length(indshere));
			end;
		end;
		set(fig,'userdata',ud);
		vlt.math.cluster_points_gui('command','UpdateMergeQualityMenu','fig',fig);
	case 'InitClusterInfoExtra',
		clusterinfo=struct('number',[],'qualitylabel','','number_of_points',[]);
		clusters = unique(ud.clusterids);
		if isnan(clusters(end)), clusters = clusters(1:find(isnan(clusters),1,'first')); end;  % take only 1 NaN from unique
		ud.clusterinfo = ud.clusterinfo([]); % start over
		for i=1:length(clusters),
			if ~isnan(clusters(i)),
				indshere = find(ud.clusterids==clusters(i));
			else,
				indshere = find(isnan(ud.clusterids));
			end;
			ud.clusterinfo(i) = struct('number',int2str(clusters(i)),'qualitylabel','Unselected',...
					'number_of_points',length(indshere));
		end;
		set(fig,'userdata',ud);
		vlt.math.cluster_points_gui('command','UpdateMergeQualityMenu','fig',fig);
	case 'MakeClusters1toN',
		clusters = unique(ud.clusterids);
		if isnan(clusters(end)), clusters = clusters(1:find(isnan(clusters),1,'first')); end;  % take only 1 NaN from unique
		inds = {};
		for i=1:length(clusters),
			if ~isnan(clusters(i)),
				inds{i} = find(ud.clusterids==clusters(i));
			else,
				inds{i} = find(isnan(ud.clusterids));
			end;
		end;
		for i=1:length(clusters),
			ud.clusterids(inds{i}) = i;
			ud.clusterinfo(i).number = num2str(i);
		end;
		if length(ud.clusterinfo) > length(clusters), % there is an empty cluster, cut it off
			ud.clusterinfo = ud.clusterinfo(1:length(clusters));
		end;
		set(fig,'userdata',ud);
	case 'OtherActionMenu',
		v = get(findobj(fig,'tag','OtherActionMenu'),'value');
		set(findobj(fig,'tag','OtherActionMenu'),'value',1);
		commands = {'','','MoveTo1Menu','','SelectSpikesToAddFeatureAxes','SelectSpikesToExcludeFeatureAxes','ExcludeAllVisibleSpikes','NotPresentIntoNewCluster'};
		if ~isempty(commands{v}), 
			vlt.math.cluster_points_gui('command',commands{v},'fig',fig);
		end;
	case 'SplitCluster', % requires input 'indexes', 'parentcluster' 
		% creates a new cluster using the spikes with indexes 'indexes', from the parent cluster 'parentcluster'
		% check for variable input errors
		if exist('indexes')~=1, error(['Programmer error: variable "indexes" needs to be passed.']); end;
		if exist('parentcluster')~=1, error(['Programmer error: variable "parentcluster" needs to be passed.']); end;

		N = length(ud.clusterinfo);
		ud.clusterinfo(N+1) = ud.clusterinfo(parentcluster);
		ud.clusterinfo(N+1).number = num2str(N+1);
		ud.clusterids(indexes) = N+1;
		ud.clusterinfo(N+1).number_of_points = length(indexes);
		ud.clusterinfo(N+1).qualitylabel = 'Unselected';
		oldindexes = find(ud.clusterids==parentcluster);
		if isempty(oldindexes), % empty cluster, delete info
			ud.clusterinfo = ud.clusterinfo([1:parentcluster-1 parentcluster+1:end]);
		else,
			ud.clusterinfo(parentcluster).number_of_points = length(oldindexes); % POSSIBLE NAN handling wrong
		end;
		set(fig,'userdata',ud);
		vlt.math.cluster_points_gui('command','MakeClusters1toN','fig',fig); % possible we emptied one
		vlt.math.cluster_points_gui('command','UpdateMergeQualityMenu','fig',fig);
		vlt.math.cluster_points_gui('command','Draw','fig',fig);
	case 'CurrentSelectedCluster',  
		clusters = unique(ud.clusterids);
		mm1 = findobj(fig,'tag','Merge1Menu');
		st = get(mm1,'string');
		v = get(mm1,'value');
		value = str2num(st{v});
		varargout{1} = value;
	case 'SelectSpikesToAddFeatureAxes',
		currentSelectedCluster = vlt.math.cluster_points_gui('command','CurrentSelectedCluster','fig',fig);
		axes(findobj(fig,'tag','FeatureAxes'));
		indexes = vlt.math.cluster_points_gui('command','FindVisiblePoints','fig',fig);
		inside = vlt.matlab.graphics.selectpoints3d(ud.F(indexes,:)');
		z = find(inside); % who is inside the selection region?
		%oldclusterids = ud.clusterids(indexes(z));  % no need, MakeClusters1toN covers this
		ud.clusterids(indexes(z)) = currentSelectedCluster;
		set(fig,'userdata',ud);
		vlt.math.cluster_points_gui('command','MakeClusters1toN','fig',fig);
		vlt.math.cluster_points_gui('command','UpdateMergeQualityMenu','fig',fig);
		vlt.math.cluster_points_gui('command','Draw','fig',fig);
	case 'SelectSpikesToExcludeFeatureAxes', 
		currentSelectedCluster = vlt.math.cluster_points_gui('command','CurrentSelectedCluster','fig',fig);
		if isnan(currentSelectedCluster),
			errordlg(['Cannot exclude from NaN cluster']);
			return;
		end;
		axes(findobj(fig,'tag','FeatureAxes'));
		indexes = vlt.math.cluster_points_gui('command','FindVisiblePoints','fig',fig);
		z = find(ud.clusterids(indexes)==currentSelectedCluster);
		indexes = indexes(z); % subset that belong to this cluster
		if isempty(indexes),
			errordlg(['No visible spikes here to exclude']);
			return;
		end;
		inside = vlt.matlab.graphics.selectpoints3d(ud.F(indexes,:)');
		z = find(inside); % who is inside the selection region?
		indexes = indexes(z); 
		vlt.math.cluster_points_gui('command','SplitCluster','fig',fig,'parentcluster',currentSelectedCluster,'indexes',indexes);
	case 'FindVisiblePoints',
		if exist('indexes')~=1,
			indexes = 1:numel(ud.points);
		end;
		varargout{1} = indexes;
		varargout{2} = [];
	case 'NotPresentIntoNewCluster',
		parentcluster = vlt.math.cluster_points_gui('command','CurrentSelectedCluster','fig',fig);
		indexes = vlt.math.cluster_points_gui('command','FindVisiblePoints','fig',fig);
		indexes = indexes(find(indexes==parentcluster));
		inds_notpresent = [];
		if isempty(inds_notpresent),
			errordlg(['No pointsare labeled as "Not present".']);
			return;
		end;
		vlt.math.cluster_points_gui('command','SplitCluster','fig',fig,'parentcluster',parentcluster,'indexes',inds_notpresent);
	case 'UpdateMergeQualityMenu',  % update the labels in the Merge/Quality menus
		clusters = unique(ud.clusterids);
		if isnan(clusters(end)), clusters = clusters(1:find(isnan(clusters),1,'first')); end;  % take only 1 NaN from unique
		mergemenustring = {};
		for i=1:length(clusters),
			mergemenustring{end+1} = int2str(clusters(i));
		end;
		set(findobj(fig,'tag','Merge1Menu'),'string',mergemenustring,'value',1);
		set(findobj(fig,'tag','MoveTo1Menu'),'string',mergemenustring,'value',1);
		vlt.math.cluster_points_gui('command','Merge1Menu','fig',fig);
	case 'MoveTo1Menu',
		% need to move this cluster number to position 1; everything gets moved down by 1
		clusters = unique(ud.clusterids);
		if isnan(clusters(end)), clusters = clusters(1:find(isnan(clusters),1,'first')); end;  % take only 1 NaN from unique
		v = get(findobj(fig,'tag','Merge1Menu'),'value');
		ud.clusterids(find(ud.clusterids==clusters(v))) = 0;
		for i=v-1:-1:0,
			if i>0,
				target=clusters(i);
			else,
				target = 0;
			end;
			ud.clusterids(find(ud.clusterids==target)) = clusters(i+1);
		end;
		ud.clusterinfo = ud.clusterinfo([v 1:v-1 v+1:end]);
		for i=1:length(ud.clusterinfo),
			ud.clusterinfo(i).number = int2str(clusters(i));
		end;
		set(fig,'userdata',ud);
		vlt.math.cluster_points_gui('command','UpdateMergeQualityMenu','fig',fig);
		vlt.math.cluster_points_gui('command','Draw','fig',fig);
	case 'Merge1Menu',  % Set Merge1Menu value
		mm1 = findobj(fig,'tag','Merge1Menu');
		st = get(mm1,'string');
		v = get(mm1,'value');
		if ~isempty(st),
			mm2str = setdiff(st,st(v));
		else,
			mm2str = '';
		end;
		if isempty(mm2str), mm2str = {' '}; end;
		mm2 = findobj(fig,'tag','Merge2Menu');
		set(mm2,'string',mm2str,'value',1);
		vlt.math.cluster_points_gui('command','ClusterPropertyMenu','fig',fig);
	case 'MergeBt',
		mm1 = findobj(fig,'tag','Merge1Menu');
		mm2 = findobj(fig,'tag','Merge2Menu');
		v1 = get(mm1,'value');
		str1 = get(mm1,'string');
		v2 = get(mm2,'value');
		str2 = get(mm2,'string');
		value2 = str2num(str2{v2});
		value1 = str2num(str1{v1});
		if value1>value2, % make sure lower number is the first one
			value_ = value1;
			value1 = value2;
			value2 = value_;
		end;
		clusters = unique(ud.clusterids);
		if isnan(clusters(end)), clusters = clusters(1:find(isnan(clusters),1,'first')); end;  % take only 1 NaN from unique
		if ~isnan(value2),
			ud.clusterids(find(ud.clusterids==value2)) = value1;
		else,
			ud.clusterids(find(isnan(ud.clusterids))) = value1;
		end;
		loc2 = []; 
		loc1 = [];
		for i=1:length(ud.clusterinfo),
			if strcmp(int2str(value2),ud.clusterinfo(i).number),
				loc2 = i;
			end;
			if strcmp(int2str(value1),ud.clusterinfo(i).number),
				loc1 = i;
			end;
		end;
		if isempty(loc2), errordlg(['Cannot merge when there is only 1 cluster.']); return; end;
		ud.clusterinfo = ud.clusterinfo([1:loc2-1 loc2+1:end]);
		newinds = find(ud.clusterids==value1);
		ud.clusterinfo(loc1).number_of_points = length(newinds);
		set(fig,'userdata',ud);
		vlt.math.cluster_points_gui('command','MakeClusters1toN','fig',fig);
		vlt.math.cluster_points_gui('command','UpdateMergeQualityMenu','fig',fig);
		vlt.math.cluster_points_gui('command','Draw','fig',fig);
	case 'ClusterPropertyMenu',
		v = get(findobj(fig,'tag','Merge1Menu'),'value'); % formerly ClusterProperyMenu
		str = get(findobj(fig,'tag','QualityMenu'),'string');
		v2 = [];
		for i=1:length(str),
			if v<=length(ud.clusterinfo),
				if strcmp(str{i},ud.clusterinfo(v).qualitylabel),
					v2 = i;
				end;
			end;
		end;
		if isempty(v2)&~isempty(ud.clusterinfo), error(['Could not find quality label ' ud.clusterinfo(v).qualitylabel '; this situation really should not happen.']); end;
		set(findobj(fig,'tag','QualityMenu'),'value',v2);
	case 'QualityMenu',
		v2 = get(findobj(fig,'tag','QualityMenu'),'value');
		str2 = get(findobj(fig,'tag','QualityMenu'),'string');
		v = get(findobj(fig,'tag','Merge1Menu'),'value'); % formerly ClusterPropertyMenu
		ud.clusterinfo(v).qualitylabel = str2{v2};
		set(fig,'userdata',ud);
		vlt.math.cluster_points_gui('command','RelabelSpikes','fig',fig);
	case 'AlgorithmMenu',
		v = get(findobj(fig,'tag','AlgorithmMenu'),'value');
		set(findobj(fig,'tag','AlgorithmSizeTxt'),'string',ud.algorithms(v).AlgorithmSizeTxt);
		set(findobj(fig,'tag','ClusterSizeEdit'),'string',ud.algorithms(v).ClusterSizeEdit);
	case 'EnableDisable',
		% is there really anything to do here?
	case 'MarkerSizeEdit',
		MarkerSizeString = get(findobj(fig,'tag','MarkerSizeEdit'),'string');
		ud.MarkerSize = str2num(MarkerSizeString);
		set(fig,'userdata',ud);
		vlt.math.cluster_points_gui('command','DrawFeatures','fig',fig);
	case {'RandomSubsetSizeEdit', 'RandomSubsetCB'},
		RandomSubsetSizeString = get(findobj(fig,'tag','RandomSubsetSizeEdit'),'string');
		try,
			ud.RandomSubsetSize = str2num(RandomSubsetSizeString);
		catch,
			errordlg(['Syntax error in RandomSubsetSize']);
			error(['Syntax error in RandomSubsetSize']);
		end;
		ud.RandomSubset = get(findobj(fig,'tag','RandomSubsetCB'),'value');
		set(fig,'userdata',ud);
	case 'AxesEdit', % user modified axes values or we want to initiate same command
		% we assume that there is a drawing right now that needs to be preserved
		FixedAxesCB = get(findobj(fig,'tag','FixedAxesCB'),'value');
		FixedAxesEdit = get(findobj(fig,'tag','AxesEdit'),'string');
		axes(findobj(fig,'tag','FeatureAxes'));
		if FixedAxesCB,
			try,
				FixedAxesValues = eval(FixedAxesEdit);
				axis(FixedAxesValues);
			catch,
				% reset to something that will not produce an error
				errordlg(['Error in Fixed Axes text field; check for syntax errors or xmin>=xmax, ymin>=ymax, etc;  resetting']);
				vlt.math.cluster_points_gui('command','AxesAutoBt','fig',fig); % repair the damage
			end;
		end;
		FixedAxesValues = axis;
		set(findobj(fig,'tag','AxesEdit'),'string',mat2str(FixedAxesValues));
	case 'AxesAutoBt',
		axes(findobj(fig,'tag','FeatureAxes'));
		axis auto;
		FixedAxesValues = axis;
		set(findobj(fig,'tag','AxesEdit'),'string',mat2str(FixedAxesValues));
	case 'Draw',
		vlt.math.cluster_points_gui('command','DrawFeatures','fig',fig);
		vlt.math.cluster_points_gui('command','UpdateMergeQualityMenu','fig',fig);
	case 'DrawFeatures',
		axes(findobj(fig,'tag','FeatureAxes'));
		cla;
		numPoints = size(ud.F,1);
		dim = size(ud.F,2);
		clusters = unique(ud.clusterids);
		if isnan(clusters(end)), clusters = clusters(1:find(isnan(clusters),1,'first')); end;  % take only 1 NaN from unique
		cluster_id_numbers = [];
		for i=1:length(ud.clusterinfo), % find corresponding clusterid numbers
			cluster_id_numbers(end+1) = str2num(ud.clusterinfo(i).number);
		end;
		for i=1:length(clusters),
			if ~isnan(clusters(i)),
				clusteridhere = find(cluster_id_numbers==clusters(i));
				inds = find(ud.clusterids==clusters(i));
				colorid = 1+mod(i-1,size(ud.ColorOrder,1));
				thecolor = ud.ColorOrder(colorid,:);
			else,
				clusteridhere = find(isnan(cluster_id_numbers));
				inds = find(isnan(ud.clusterids));
				thecolor = ud.UnclassifiedColor;
			end;

			axisnames = get(findobj(fig,'tag','FeatureMenu'),'string');
			selection = vlt.ui.nitemmenuselection(findobj(fig,'tag','FeatureMenu'),'value',[]);
			% only examine 'visible' spikes
			[inds_visible,inds_invisible] = vlt.math.cluster_points_gui('command','FindVisiblePoints','fig',fig,'indexes',inds);
			inds = inds_visible;
			if numel(inds)>0 & ~isempty(ud.F),
				if dim>=3,
					plot3(ud.F(inds,1),ud.F(inds,2),ud.F(inds,3),'.','color',thecolor,'MarkerSize',ud.MarkerSize);
					xlabel(axisnames{selection(1)},'interp','none');
					ylabel(axisnames{selection(2)},'interp','none');
					zlabel(axisnames{selection(3)},'interp','none');
				elseif dim==2,
					plot(ud.F(inds,1),ud.F(inds,2),'.','color',thecolor,'MarkerSize',ud.MarkerSize);
					xlabel(axisnames{selection(1)},'interp','none');
					ylabel(axisnames{selection(2)},'interp','none'); 
				elseif dim==1,
					plot(ud.F(inds),ud.F(inds),'.','color',thecolor,'MarkerSize',ud.MarkerSize);
					xlabel(axisnames{selection(1)},'interp','none'); 
				end;
			end;
			hold on;
		end;
		box off; % good taste
		MarkerSizeString = int2str(ud.MarkerSize);
		set(findobj(fig,'tag','MarkerSizeEdit'),'string',MarkerSizeString);
		vlt.math.cluster_points_gui('command','AxesEdit','fig',fig); % adjust axis if necessary
		drawnow;
	case 'RelabelSpikes',
		for i=1:length(ud.clusterinfo),
			axes(findobj(fig,'tag',['SpikeAxes' int2str(i)]));
			A = axis;
			ch = findobj(gca,'type','text');
			delete(ch);
			if ~isnan(str2num(ud.clusterinfo(i).number)),
                                inds = find(ud.clusterids==str2num(ud.clusterinfo(i).number));
                        else,
                                inds = find(isnan(ud.clusterids));
                        end;
                        inds = [];
			Number_match = length(inds);
			text(A(:,1), A(:,3)+0.9*A(:,4)-A(:,3), ud.clusterinfo(i).number, ...
				'horizontalalignment','left','fontweight','bold','fontsize',12);
			text(A(:,1)+1*(A(:,2)-A(:,1)), A(:,3)+0.1*(A(:,4)-A(:,3)),...
				['N=' int2str(Number_match) ', Q=' ud.clusterinfo(i).qualitylabel ],...
				'horizontalalignment','right');
		end;

	case 'DoneBt',
		b = 1;
		for i=1:length(ud.clusterinfo),
			if strcmp(ud.clusterinfo(i).qualitylabel,'Unselected'),
				b = 0;
			end;
		end;
		if b | ~ud.ForceQualityAssessment,
			saidyes = 1;
			if ud.AskBeforeDone,
				answer = questdlg('Are you sure you are done?','Confirm Done','Yes','No','Yes');
				saidyes = strcmp(answer,'Yes');
			end;
			if saidyes,

				% finally, mark all clusterids as NaN if those spikes are not 'present'
				for i=1:length(ud.clusterinfo),
					if ~isnan(str2num(ud.clusterinfo(i).number)),
						inds = find(ud.clusterids==str2num(ud.clusterinfo(i).number));
					else,
						inds = find(isnan(ud.clusterids));
					end;
					inds_notpresent = [];
					ud.clusterids(inds_notpresent) = NaN;
					ud.clusterinfo(i).number_of_points = length(inds);
				end;

				if any(isnan(ud.clusterids)), % if we have NaN clusterids, make sure there is corresponding clusterinfo
					A = isempty(ud.clusterinfo);
					if ~A,
						B = find(strncmp('NaN',{ud.clusterinfo.number},3));
					end;
					if A | isempty(B), % we need to add a clusterinfo for NaN
						ud.clusterinfo(end+1)=struct('number','NaN','qualitylabel','Unselected','number_of_points',sum(isnan(ud.clusterids)));
					end;
				end;

				ud.success = 1;
				set(fig,'userdata',ud);
				uiresume(fig);
			end;
		else,
			errordlg(['Please make sure a quality label has been assigned to all clusters.'],'Assign quality label');
		end;
		if ~(ud.IsModal), close(fig); end;
	case 'CancelBt',
		ud.success = 0;
		set(fig,'userdata',ud);
		uiresume(fig);
		if ~(ud.IsModal), close(fig); end;
end;
