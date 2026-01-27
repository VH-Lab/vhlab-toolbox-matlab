function varargout = cluster_spikewaves_gui(varargin)
% CLUSTER_SPIKEWAVES_GUI - Cluster spikewaves into groups with manual checking
%
%   [CLUSTERIDS,CLUSTERINFO] = vlt.neuro.spikesorting.cluster_spikewaves_gui('WAVES', WAVES, ...
%      'WAVEPARAMETERS', WAVEPARAMETERS, ...)
%
%   Brings up a graphical user interface to allow the user to divide the
%   spikewaves WAVES into groups using several algorithms, and to check
%   the output of these algorithms with different views (raw data views, 
%   feature views, etc).
%
%   WAVES should be NumSamples X NumChannels X NumSpikes
%   WAVEPARAMETERS should be a structure with the following fields:
%
%    NAME (type):                      DESCRIPTION         
%    -------------------------------------------------------------------------
%    waveparameters.numchannels (uint8)    : Number of channels
%    waveparameters.S0 (int8)              : Number of samples before spike center
%                                          :  (usually negative)
%    waveparameters.S1 (int8)              : Number of samples after spike center
%                                          :  (usually positive)
%    waveparameters.name (80xchar)         : Name (up to 80 characters)
%    waveparameters.ref (uint8)            : Reference number
%    waveparameters.comment (80xchar)      : Up to 80 characters of comment
%    waveparameters.samplingrate           : The sampling rate (float64)
%   (this is the same as the output of HEADER in vlt.file.custom_file_formats.readvhlspikewaveformfile)
%
%   Additional parameters can be adjusted by passing name/value pairs 
%   at the end of the function:
%   
%   'clusterids'                           :    preliminary cluster ids
%   'wavetimes'                            :    1xNumSpikes; the time of each spike
%   'spikewaves2NpointfeatureSampleList'   :    [x1 x2] the locations where we should measure the
%                                          :        voltage, defaults [half_way 5/6 of way]
%   'spikewaves2pcaRange'                  :    [x1 x2] the locations within which we should examine pca
%                                          :        default [6 22]/24 * number of spike samples
%   'ColorOrder'                           :    Color order for cluster drawings; defaults
%                                          :        to axes color order
%   'UnclassifiedColor'                    :    Color of unclassified spikes, default [0.5 0.5 0.5]
%   'NotPresentColor'                      :    Color of spikes not present, default [1 0.5 0.5] (light pink)
%   'RandomSubset'                         :    Do we plot a random subset of spikes? Default 1
%   'RandomSubsetSize'                     :    How many?  Default 200
%   'ForceQualityAssessment'               :    Should we force the user to choose cluster quality
%                                          :        before closing?  Default 1
%   'EnableClusterEditing'                 :    Should we enable cluster editing?  Default 1
%   'AskBeforeDone'                        :    Ask user to confirm they are really done Default 1
%   'MarkerSize'                           :    MarkerSize for plotting; default 10
%   'FigureName'                           :    Name of the figure; default "Cluster spikewaves".
%   'IsModal'                              :    Is it a modal dialog? That is, should it stop all other
%                                          :        windows until the user finishes? Default is 1.
%                                          :        If the dialog is not modal then it cannot return
%                                          :        any values.
%   'EpochStartSamples'                    :    Array with the sample corresponding to the start
%                                          :        of each recording epoch. Default [1], which specifies
%                                          :        a single recording epoch that starts with the first
%                                          :        sample.
%   'EpochNames'                           :    Cell list of string names of the recording epochs.
%                                          :        Default {'Epoch1'}. There must be the same number
%                                          :        of EpochNames as there are entries in the array
%                                          :        EpochStartSamples.
  

  % add number of spikes to cluster info, compute mean waveforms
   
 % internal variables, for the function only
command = 'Main';    % internal variable, the command
fig = '';                 % the figure
success = 0;
features = struct('name','2points','code','ud.F=transpose(vlt.neuro.spikesorting.spikewaves2Npointfeature(ud.waves,ud.spikewaves2NpointfeatureSampleList));','FeatureText','2 points');
features(2) = struct('name','pca3','code','ud.F=transpose(vlt.neuro.spikesorting.spikewaves2pca(ud.waves,3,ud.spikewaves2pcaRange));','FeatureText','range [-S0 S1]');
algorithms(1) = struct('name','KlustaKwik','code','ud.clusterids=klustakwik_cluster(ud.F,ud.clusters(1),ud.clusters(2),10,0);','ClusterSizeEdit','[2 4]','AlgorithmSizeTxt','# clusters [min max]');
algorithms(2) = struct('name','KMeans','code','ud.clusterids=kmeans(ud.F,ud.clusters);','ClusterSizeEdit','5','AlgorithmSizeTxt','# clusters:');
windowheight = 800;
windowwidth = 1000;
windowrowheight = 35;
windowfeaturewidth = 500;
clusterinfo=struct('number',[],'qualitylabel','','number_of_spikes',[],'meanshape',[],'EpochStart',[],'EpochStop',[]);
clusterinfo = clusterinfo([]);
ForceQualityAssessment = 1;
EnableClusterEditing = 1;
MarkerSize = 10;
FigureName = 'Cluster spikewaves';
IsModal = 1;
EpochStartSamples = 1;
EpochNames = {'Epoch1'};

 % user-specified variables
waves = -1;               % waves
waveparameters = [];      % waveparameters
clusterids = [];
wavetimes = [];
spikewaves2NpointfeatureSampleList = [ ];
spikewaves2pcaRange = [ ];
ColorOrder = [0 0 1; 0 0.5 0; 1 0 0; 0 0.75 0.75; 0.75 0 0.75; 0.75 0.75 0; 0.25 0.25 0.25];
UnclassifiedColor = [0.5 0.5 0.5];
NotPresentColor = 2*[ 0.5 0.25 0.25];
RandomSubset = 1;
RandomSubsetSize = 200;
windowlabel = 'Cluster spikes';
ClusterRightAway = 0;
AskBeforeDone = 1;

varlist = {'success','features','algorithms','wavetimes','waveparameters','waves',...
	'clusterids','spikewaves2NpointfeatureSampleList','spikewaves2pcaRange','windowheight','windowwidth','windowrowheight',...
	'ColorOrder','UnclassifiedColor','NotPresentColor','windowfeaturewidth','clusterinfo','RandomSubset','RandomSubsetSize','windowlabel',...
	'ForceQualityAssessment','EnableClusterEditing',...
	'EpochStartSamples','EpochNames',...
	'AskBeforeDone','MarkerSize','clusterids_initial','clusterinfo_initial','FigureName','IsModal'};

vlt.data.assign(varargin{:});

if isempty(fig),
	fig = figure;
end;

if isempty(waves),
	emptywaves = 1;
elseif vlt.data.eqlen(waves,-1),
	emptywaves = 0;
	waves = [];
else,
	emptywaves = 0;
end;

 % initialize userdata field
if strcmp(command,'Main'),
	clusterids_initial = [];
	clusterinfo_initial = [];

	for i=1:length(varlist),
		eval(['ud.' varlist{i} '=' varlist{i} ';']);
	end;
	if isempty(waves)&~emptywaves, % user specified no waves, so load the example waves
		ud.waves = getfield(load('example_waves.mat','waves'),'waves');
		ud.wavesparameters = getfield(load('example_waves.mat','waveparameters'),'waveparameters');
		ud.clusterids = getfield(load('example_waves.mat'),'clusterids');
		ud.clusterids_initial = getfield(load('example_waves.mat'),'clusterids');
		ud.clusterinfo = getfield(load('example_waves.mat'),'clusterinfo');
		ud.clusterinfo_info = getfield(load('example_waves.mat'),'clusterinfo');
		ud.spikewaves2NpointfeatureSampleList = [ 11 20]; % appropriate settings for these spikes
		ud.spikewaves2pcaRange = [5 33];
	end;
	if isempty(ud.spikewaves2NpointfeatureSampleList),
		% set it halfway and 5/6 of way; if odd number of samples, use N/2 - 1
		ud.spikewaves2NpointfeatureSampleList = [((size(ud.waves,1)/2)-mod(size(ud.waves,1),2)) round((5/6) * size(ud.waves,1))];
	end;
	if isempty(ud.spikewaves2pcaRange),
		ud.spikewaves2pcaRange = round([8 22]/24 * size(ud.waves,1));
	end;
	% check to make sure we are within bounds for our features
	if ud.spikewaves2pcaRange(1)<1, ud.spikewaves2pcaRange(1) = 1; end;
	if ud.spikewaves2pcaRange(end)>size(ud.waves,1), ud.spikewaves2pcaRange(end) = size(ud.waves,1); end;
	if ud.spikewaves2NpointfeatureSampleList(1)<1, ud.spikewaves2NpointfeatureSampleList(1) = 1; end;
	if ud.spikewaves2NpointfeatureSampleList(end)>size(ud.waves,1), ud.spikewaves2NpointfeatureSampleList(end) = size(ud.waves,1); end;
else,
	ud = get(fig,'userdata');
end;

switch command,
	case 'Main',
		if isempty(ud.clusterids),
			ud.clusterids = NaN(1,size(ud.waves,3));
		end;  % make sure there are initial assigned clusters

		if length(ud.clusterids)<size(ud.waves,3),
			ud.clusterids(end+1:size(ud.waves,3)) = NaN;
		end;

		if ~isempty(ud.clusterinfo), % make sure we have EpochStart/Stop
			if ~isfield(ud.clusterinfo,'EpochStart'),
				for i=1:length(ud.clusterinfo),
					ud.clusterinfo(i).EpochStart = ud.EpochNames{1};
					ud.clusterinfo(i).EpochStop = ud.EpochNames{end};
				end;
			end;
		end;

		if any(isnan(ud.clusterids)), % if we have NaN clusterids, make sure there is corresponding clusterinfo
			A = isempty(ud.clusterinfo);
			if ~A, 
				B = find(strncmp('NaN',{ud.clusterinfo.number},3));
			end;
			if A | isempty(B), % we need to add a clusterinfo for NaN
%				C = struct('number','NaN','qualitylabel','Unselected','number_of_spikes',sum(isnan(ud.clusterids)), ...
%					'meanshape',nanmean(ud.waves(:,:,find(isnan(ud.clusterids))),3),'EpochStart',ud.EpochNames{1},'EpochStop',ud.EpochNames{end});
				ud.clusterinfo(end+1)=struct('number','NaN','qualitylabel','Unselected','number_of_spikes',sum(isnan(ud.clusterids)), ...
					'meanshape',nanmean(ud.waves(:,:,find(isnan(ud.clusterids))),3),'EpochStart',ud.EpochNames{1},'EpochStop',ud.EpochNames{end});
			end;
		end;

		% make sure any Epochs in incoming clusterinfo match the epochs we actually have
		for i=1:length(ud.clusterinfo),
			if ~any(strcmp(ud.clusterinfo(i).EpochStart,EpochNames)),
				warning(['Cannot find an exact match for EpochStart for cluster ' ud.clusterinfo(i).number ' so using first Epoch ' EpochNames{1}]);
				ud.clusterinfo(i).EpochStart = EpochNames{1};
			end;
			if ~any(strcmp(ud.clusterinfo(i).EpochStop,EpochNames)),
				warning(['Cannot find an exact match for EpochStop for cluster ' ud.clusterinfo(i).number ' so using last Epoch ' EpochNames{end}]);
				ud.clusterinfo(i).EpochStop = EpochNames{end};
			end;
		end;

		ud.clusterids_initial = ud.clusterids;
		ud.clusterinfo_initial = ud.clusterinfo;

		set(fig,'userdata',ud);

		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','NewWindow','fig',fig);
		if ~EnableClusterEditing,
			disablelist = {'MoveTo1Menu','MoveTo1Txt','ClusterAllBt','MergeTxt',...
					'MergeBt','Merge1Menu','Merge2Menu','AlgorithmTxt','AlgorithmMenu',...
					'ClusterSizeEdit','AlgorithmSizeTxt'};
			for i=1:length(disablelist),
				set(findobj(fig,'tag',disablelist{i}),'enable','off');
			end;
		end;
		if isempty(ud.clusterinfo),
			vlt.neuro.spikesorting.cluster_spikewaves_gui('command','InitClusterInfo','fig',fig);
		end;
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','FeatureMenu','fig',fig);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','EnableDisableEpochItems','fig',fig);
		drawnow;
		if ClusterRightAway,
			vlt.neuro.spikesorting.cluster_spikewaves_gui('command','ClusterAllBt','fig',fig);
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
                txt.Units = 'pixels'; txt.BackgroundColor = get(fig,'Color');
                txt.fontsize = 10; txt.fontweight = 'normal';
                txt.HorizontalAlignment = 'left';txt.Style='text';
                edit = txt; edit.BackgroundColor = [ 1 1 1]; edit.Style = 'Edit';
                popup = txt; popup.style = 'popupmenu';
                popup.Callback = callbackstr;
                cb = txt; cb.Style = 'Checkbox';
                cb.Callback = callbackstr;
                cb.fontsize = 10;

		% feature list:

		right = ud.windowwidth;
		top = ud.windowheight;
		row = ud.windowrowheight;

                set(fig,'position',[50 50 right top],'tag','vlt.neuro.spikesorting.cluster_spikewaves_gui');

		uicontrol(button,'position',[5 top-row*1 100 30],'string','DONE','fontweight','bold','tag','DoneBt');
		uicontrol(button,'position',[5+100+10 top-row*1 100 30],'string','Cancel','fontweight','bold','tag','CancelBt');
		uicontrol(button,'position',[5+100+10+5+100 top-row*1+15 100 15],'string','Cluster all','fontweight','bold','tag','ClusterAllBt');
		uicontrol(button,'position',[5+100+10+5+100 top-row*1 100 15],'string','Cluster visible','fontweight','bold','tag','ClusterVisibleBt','enable','off');
		uicontrol(button,'position',[5+100+10+5+100+5+100 top-row*1 150 30],'string','Show initial clusters','fontweight','bold','tag','ShowInitialClustersBt');
		if isempty(ud.clusterids_initial), set(findobj(fig,'tag','ShowInitialClustersBt'),'enable','off'); end;

		uicontrol(txt,'position',[5 top-row*2 80 30],'string','Feature:','tag','FeatureTxt');
		uicontrol(popup,'position',[5+10+80 top-row*2 150 30],'string',{ud.features.name},'value',1,'tag','FeatureMenu');
		uicontrol(txt,'position',[5+10+80+150+5 top-row*2 100 30],'string',ud.features(1).FeatureText,'tag','FeatureText');
		uicontrol(edit,'position',[5+10+80+150+5+100+5 top-row*2 100 30],'string',mat2str(spikewaves2NpointfeatureSampleList),'tag','FeatureEdit','callback',callbackstr);

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
			{'Other actions','---','Move to cluster 1','---','Select spikes to add','Select spikes to exclude',...
			'Exclude all visible spikes','Make "not present" spikes into a new cluster'},...
			'visible','on','tag','OtherActionMenu');

		%uicontrol(txt,'position',[5 top-row*5 150 30],'string','Move to cluster 1:','tag','MoveTo1Txt');
		%uicontrol(popup,'position',[5+10+150 top-row*5 60 30],'string',{''},'value',1,'tag','MoveTo1Menu');

		uicontrol(txt,'position',[5 top-row*5 80 30],'string','Cluster info:','tag','ClusterInfoTxt');
		%uicontrol(popup,'position',[5+10+80 top-row*5 80 30],'string',{''},'value',1,'tag','ClusterPropertyMenu'); % this is really a 'ClusterPropertyMenu' now; Merge1Menu now performs this function
		uicontrol(txt,'position',[5+10+80+80+5 top-row*5 50 30],'string','is','tag','QualityWithTxt');
		uicontrol(popup,'position',[5+10+80+60+5+60+5 top-row*5 200 30],'string',...
			{'Unselected','Not usable','Multi-unit','Good','Excellent'},'value',1,'tag','QualityMenu');

		uicontrol(txt,'position',[5+10+80 top-row*6 120 30],'string','is present from ','tag','EpochsStartText','visible','off');
		uicontrol(popup,'position',[5+10+80+120+5+5 top-row*6 100 30],'string',ud.EpochNames,'tag','EpochsStartMenu','visible','off','value',1);
		uicontrol(txt,'position',[5+10+80+5+5+120+100+5 top-row*6 30 30],'string','to','tag','EpochsStopText','visible','off');
		uicontrol(popup,'position',[5+10+80+5+5+120+100+5+30+5 top-row*6 100 30],'string',ud.EpochNames,'tag','EpochsStopMenu','visible','off','value',length(ud.EpochNames));

		uicontrol(txt,'position',[5 5 80 30],'string','Click action:', 'tag', 'FeatureClickActionTxt','visible','off');
		uicontrol(popup,'position',[5+10+150-20 5 200 30],'string',{'Selects','Zooms','Rotates'},'value',1,'tag','FeatureClickMenu','visible','off');

		uicontrol(txt,'position',[5 top-row*7 150 30],'string','View Epochs from ','tag','ViewEpochsStartText','visible','off');
		uicontrol(popup,'position',[5+150 top-row*7 100 30],'string',ud.EpochNames,'tag','ViewEpochsStartMenu','visible','off','value',1);
		uicontrol(txt,'position',[5+150+100+5 top-row*7 30 30],'string','to','tag','ViewEpochsStopText','visible','off');
		uicontrol(popup,'position',[5+150+100+5+30+5 top-row*7 100 30],'string',ud.EpochNames,'tag','ViewEpochsStopMenu','visible','off','value',length(ud.EpochNames));

		uicontrol(txt,'position',[5 top-row*8-2 80 30],'string', 'MarkerSize','tag','MarkerSizeText');
		uicontrol(edit,'position',[5+80+5 top-row*8+4 40 30],'string', int2str(ud.MarkerSize),'tag','MarkerSizeEdit','callback',callbackstr);
		uicontrol(cb,'position',[5+80+5+40+5 top-row*8+4 230 30],'string', 'Show subset of spikewaves','tag','RandomSubsetCB','value',ud.RandomSubset);
		uicontrol(txt,'position',[5+80+5+40+5+230+5 top-row*8-2 80 30],'string', 'Subset size','tag','RandomSubsetSizeText');
		uicontrol(edit,'position',[5+80+5+40+5+230+5+80+5 top-row*8+4 50 30],'string', int2str(ud.RandomSubsetSize),'tag','RandomSubsetSizeEdit','callback',callbackstr);

		axes('units','pixels','position',[25 5+2*row 500-20 top-11*row-10],'tag','FeatureAxes','ButtonDownFcn',callbackstr);

		uicontrol(cb,'position',[5 5+0*row 100 30],'string', 'Fixed axes','tag','FixedAxesCB','value',0);
		uicontrol(txt,'position',[5+100+5 5+0*row-3 130 30],'string', '[xmin xmax ymin ymax]','tag','AxesText');
		uicontrol(edit,'position',[5+100+5+130 5+0*row 200 30],'string', '[-2 0 -1 1]','tag','AxesEdit','callback',callbackstr);
		uicontrol(button,'position',[5+100+5+130+200+5 5+0*row 40 30],'string', 'auto','tag','AxesAutoBt');

		ch = get(gcf,'children');
		for i=1:numel(ch),
			try,
				set(ch(i),'units','normalized');
			end;
		end;

		set(fig,'userdata',ud);
	case 'ShowInitialClustersBt',
		vlt.neuro.spikesorting.cluster_spikewaves_gui('waves',ud.waves,'waveparameters',ud.waveparameters,'clusterids',ud.clusterids_initial,'clusterinfo',ud.clusterinfo_initial,...
			'IsModal',0,'FigureName',[ud.FigureName ' - initial clusters'],'EnableClusterEditing',0,'AskBeforeDone',0,'ForceQualityAssessment',0,...
			'MarkerSize',ud.MarkerSize,'RandomSubset',ud.RandomSubset,'RandomSubsetSize',ud.RandomSubsetSize,'EpochNames',ud.EpochNames,'EpochStartSamples',ud.EpochStartSamples);
	case 'FeatureEdit',
		featureEditString = get(findobj(fig,'tag','FeatureEdit'),'string');
		good = 0;
		try,
			f = get(findobj(fig,'tag','FeatureMenu'),'value');
			if f==1,
				ud.spikewaves2NpointfeatureSampleList = str2num(featureEditString);
				set(fig,'userdata',ud);
				good = 1;
			elseif f==2,
				ud.spikewaves2pcaRange = str2num(featureEditString);
				set(fig,'userdata',ud);
				good = 1;
			end;
		catch,
			errordlg(['Error in setting spikewaves2NpointfeatureSampleList']);
			error(['Error in setting spikewaves2NpointfeatureSampleList']);
		end;
		if good, vlt.neuro.spikesorting.cluster_spikewaves_gui('command','FeatureMenu','fig',fig); end;
	case 'FeatureMenu',
		% really nothing to do here
		f = get(findobj(fig,'tag','FeatureMenu'),'value');
		good = 1;
		if good,
			if f==1, % show the text and edit boxes
				%set(findobj(fig,'tag','FeatureText'),'visible','on');
				featureEditString = mat2str(ud.spikewaves2NpointfeatureSampleList );
				set(findobj(fig,'tag','FeatureEdit'),'visible','on','string',featureEditString,'ForegroundColor',[0 0 0]);
			else,
				%set(findobj(fig,'tag','FeatureText'),'visible','off');
				featureEditString = mat2str(ud.spikewaves2pcaRange);
				set(findobj(fig,'tag','FeatureEdit'),'visible','on','string',featureEditString,'ForegroundColor',[0 0 1]);
			end;
			try, eval(ud.features(f).code);
			catch,
				good = 0;
				errordlg(['Error in calculating features: ' lasterr ] ,'Cluster error');
				error(['Error in calculating features: ' lasterr ] ,'Cluster error');
			end;
			set(fig,'userdata',ud);
			vlt.neuro.spikesorting.cluster_spikewaves_gui('command','Draw','fig',fig);
		end;
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
			vlt.neuro.spikesorting.cluster_spikewaves_gui('command','ReOrderMinToMax','fig',fig);
			vlt.neuro.spikesorting.cluster_spikewaves_gui('command','InitClusterInfo','fig',fig);
			vlt.neuro.spikesorting.cluster_spikewaves_gui('command','MakeClusters1toN','fig',fig);
			vlt.neuro.spikesorting.cluster_spikewaves_gui('command','Draw','fig',fig);
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
			indexes = vlt.neuro.spikesorting.cluster_spikewaves_gui('command','FindVisibleSpikes','fig',fig);

%algorithms(1) = struct('name','KlustaKwik','code','ud.clusterids=klustakwik_cluster(ud.F,ud.clusters(1),ud.clusters(2),10,0);','ClusterSizeEdit','[2 4]','AlgorithmSizeTxt','# clusters [min max]');
%algorithms(2) = struct('name','KMeans','code','ud.clusterids=kmeans(ud.F,ud.clusters);','ClusterSizeEdit','5','AlgorithmSizeTxt','# clusters:');

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
			vlt.neuro.spikesorting.cluster_spikewaves_gui('command','ReOrderMinToMax','fig',fig);
			vlt.neuro.spikesorting.cluster_spikewaves_gui('command','InitClusterInfo','fig',fig);
			vlt.neuro.spikesorting.cluster_spikewaves_gui('command','MakeClusters1toN','fig',fig);
		end;
	case 'ReOrderMinToMax',
		clusters = unique(ud.clusterids);
		if isnan(clusters(end)), clusters = clusters(1:find(isnan(clusters),1,'first')); end;  % take only 1 NaN from unique
		minvalues = [];
		indshere = {};
		for i=1:length(clusters),
			indshere{i} = find(ud.clusterids==clusters(i));
			mn = nanmean(ud.waves(:,:,indshere{i}),3);
			minvalues(end+1) = min(mn(:));
		end;
		[values,order] = sort(minvalues);
		for i=1:length(order),
			ud.clusterids(indshere{order(i)}) = i;
		end;
		set(fig,'userdata',ud);
	case 'InitClusterInfo',
		clusterinfo=struct('number',[],'qualitylabel','','numberofspikes',[],'meanshape',[]);
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
						'number_of_spikes',length(indshere),'meanshape',nanmean(ud.waves(:,:,indshere),3),...
						'EpochStart',ud.EpochNames{1},'EpochStop',ud.EpochNames{end});
			end;
		end;
		set(fig,'userdata',ud);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','UpdateMergeQualityMenu','fig',fig);
	case 'InitClusterInfoExtra',
		clusterinfo=struct('number',[],'qualitylabel','','numberofspikes',[],'meanshape',[]);
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
					'number_of_spikes',length(indshere),'meanshape',nanmean(ud.waves(:,:,indshere),3),...
					'EpochStart',ud.EpochNames{1},'EpochStop',ud.EpochNames{end});
		end;
		set(fig,'userdata',ud);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','UpdateMergeQualityMenu','fig',fig);
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
			vlt.neuro.spikesorting.cluster_spikewaves_gui('command',commands{v},'fig',fig);
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
		ud.clusterinfo(N+1).number_of_spikes = length(indexes);
		ud.clusterinfo(N+1).meanshape = nanmean(ud.waves(:,:,indexes),3);
		ud.clusterinfo(N+1).qualitylabel = 'Unselected';
		oldindexes = find(ud.clusterids==parentcluster);
		if isempty(oldindexes), % empty cluster, delete info
			ud.clusterinfo = ud.clusterinfo([1:parentcluster-1 parentcluster+1:end]);
		else,
			ud.clusterinfo(parentcluster).number_of_spikes = length(oldindexes); % POSSIBLE NAN handling wrong
			ud.clusterinfo(parentcluster).meanshape = nanmean(ud.waves(:,:,oldindexes),3);
		end;
		set(fig,'userdata',ud);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','MakeClusters1toN','fig',fig); % possible we emptied one
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','UpdateMergeQualityMenu','fig',fig);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','Draw','fig',fig);
	case 'CurrentSelectedCluster',  
		clusters = unique(ud.clusterids);
		mm1 = findobj(fig,'tag','Merge1Menu');
		st = get(mm1,'string');
		v = get(mm1,'value');
		value = str2num(st{v});
		varargout{1} = value;
	case 'SelectSpikesToAddFeatureAxes',
		currentSelectedCluster = vlt.neuro.spikesorting.cluster_spikewaves_gui('command','CurrentSelectedCluster','fig',fig);
		axes(findobj(fig,'tag','FeatureAxes'));
		indexes = vlt.neuro.spikesorting.cluster_spikewaves_gui('command','FindVisibleSpikes','fig',fig);
		inside = vlt.matlab.graphics.selectpoints3d(ud.F(indexes,:)');
		z = find(inside); % who is inside the selection region?
		%oldclusterids = ud.clusterids(indexes(z));  % no need, MakeClusters1toN covers this
		ud.clusterids(indexes(z)) = currentSelectedCluster;
		set(fig,'userdata',ud);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','MakeClusters1toN','fig',fig);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','UpdateMergeQualityMenu','fig',fig);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','Draw','fig',fig);
	case 'SelectSpikesToExcludeFeatureAxes', 
		currentSelectedCluster = vlt.neuro.spikesorting.cluster_spikewaves_gui('command','CurrentSelectedCluster','fig',fig);
		if isnan(currentSelectedCluster),
			errordlg(['Cannot exclude from NaN cluster']);
			return;
		end;
		axes(findobj(fig,'tag','FeatureAxes'));
		indexes = vlt.neuro.spikesorting.cluster_spikewaves_gui('command','FindVisibleSpikes','fig',fig);
		z = find(ud.clusterids(indexes)==currentSelectedCluster);
		indexes = indexes(z); % subset that belong to this cluster
		if isempty(indexes),
			errordlg(['No visible spikes here to exclude']);
			return;
		end;
		inside = vlt.matlab.graphics.selectpoints3d(ud.F(indexes,:)');
		z = find(inside); % who is inside the selection region?
		indexes = indexes(z); 
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','SplitCluster','fig',fig,'parentcluster',currentSelectedCluster,'indexes',indexes);
	case 'ExcludeAllVisibleSpikes',
		parentcluster = vlt.neuro.spikesorting.cluster_spikewaves_gui('command','CurrentSelectedCluster','fig',fig);
		indexes = vlt.neuro.spikesorting.cluster_spikewaves_gui('command','FindVisibleSpikes','fig',fig);
		if ~isnan(parentcluster),
			% select the subset of visible spikes that belong to the parent cluster
			z = find(ud.clusterids(indexes)==parentcluster);
			indexes = indexes(z); 
			vlt.neuro.spikesorting.cluster_spikewaves_gui('command','SplitCluster','fig',fig,'parentcluster',parentcluster,'indexes',indexes);
		else,
			errordlg(['Cannot split NaN cluster']);
		end;
	case 'NotPresentIntoNewCluster',
		parentcluster = vlt.neuro.spikesorting.cluster_spikewaves_gui('command','CurrentSelectedCluster','fig',fig);
		indexes = vlt.neuro.spikesorting.cluster_spikewaves_gui('command','FindVisibleSpikes','fig',fig);
		indexes = indexes(find(indexes==parentcluster));
		[inds_present,dummy,inds_notpresent] = vlt.signal.samplesinepochs(indexes, ud.EpochStartSamples, ...
			find(strcmp(ud.clusterinfo(parentcluster).EpochStart,ud.EpochNames)) , ...
			find(strcmp(ud.clusterinfo(parentcluster).EpochStop,ud.EpochNames)) );
		if isempty(inds_notpresent),
			errordlg(['No spikes are labeled as "Not present".']);
			return;
		end;
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','SplitCluster','fig',fig,'parentcluster',parentcluster,'indexes',inds_notpresent);
	case 'UpdateMergeQualityMenu',  % update the labels in the Merge/Quality/Epoch menus
		clusters = unique(ud.clusterids);
		if isnan(clusters(end)), clusters = clusters(1:find(isnan(clusters),1,'first')); end;  % take only 1 NaN from unique
		mergemenustring = {};
		for i=1:length(clusters),
			mergemenustring{end+1} = int2str(clusters(i));
		end;
		set(findobj(fig,'tag','Merge1Menu'),'string',mergemenustring,'value',1);
		%set(findobj(fig,'tag','ClusterPropertyMenu'),'string',mergemenustring,'value',1); % this doesn't exist anymore
		set(findobj(fig,'tag','MoveTo1Menu'),'string',mergemenustring,'value',1);
		set(findobj(fig,'tag','EpochsStartMenu'),'string',ud.EpochNames);
		set(findobj(fig,'tag','EpochsStopMenu'),'string',ud.EpochNames);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','Merge1Menu','fig',fig);
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
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','UpdateMergeQualityMenu','fig',fig);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','Draw','fig',fig);
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
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','ClusterPropertyMenu','fig',fig);
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
		ud.clusterinfo(loc1).number_of_spikes = length(newinds);
		ud.clusterinfo(loc1).meanshape = nanmean(ud.waves(:,:,newinds),3);
		set(fig,'userdata',ud);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','MakeClusters1toN','fig',fig);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','UpdateMergeQualityMenu','fig',fig);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','Draw','fig',fig);
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
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','UpdateEpochMenus','fig',fig);
	case 'QualityMenu',
		v2 = get(findobj(fig,'tag','QualityMenu'),'value');
		str2 = get(findobj(fig,'tag','QualityMenu'),'string');
		v = get(findobj(fig,'tag','Merge1Menu'),'value'); % formerly ClusterPropertyMenu
		ud.clusterinfo(v).qualitylabel = str2{v2};
		set(fig,'userdata',ud);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','RelabelSpikes','fig',fig);
	case 'UpdateEpochMenus', % Update the display of the Epoch menus to match the cluster info
		v = get(findobj(fig,'tag','Merge1Menu'),'value'); % which cluster number are we on? % formerly ClusterPropertyMenu
		str = get(findobj(fig,'tag','EpochsStartMenu'),'string');
		v_EpochStart = find(strcmp(ud.clusterinfo(v).EpochStart,str));
		v_EpochStop  = find(strcmp(ud.clusterinfo(v).EpochStop,str));
		set(findobj(fig,'tag','EpochsStartMenu'),'value',v_EpochStart);
		set(findobj(fig,'tag','EpochsStopMenu'), 'value',v_EpochStop);
	case {'EpochsStartMenu','EpochsStopMenu'}, % update the cluster info to match the Epoch menus
		v = get(findobj(fig,'tag','Merge1Menu'),'value'); % formerly ClusterPropertyMenu
		vstart = get(findobj(fig,'tag','EpochsStartMenu'),'value');
		vstop = get(findobj(fig,'tag','EpochsStopMenu'),'value');
		ud.clusterinfo(v).EpochStart = ud.EpochNames{vstart};
		ud.clusterinfo(v).EpochStop = ud.EpochNames{vstop};
		set(fig,'userdata',ud);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','Draw','fig',fig);
	case {'ViewEpochsStartMenu','ViewEpochsStopMenu'},
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','Draw','fig',fig);
	case 'AlgorithmMenu',
		v = get(findobj(fig,'tag','AlgorithmMenu'),'value');
		set(findobj(fig,'tag','AlgorithmSizeTxt'),'string',ud.algorithms(v).AlgorithmSizeTxt);
		set(findobj(fig,'tag','ClusterSizeEdit'),'string',ud.algorithms(v).ClusterSizeEdit);
	case 'EnableDisable',
		% is there really anything to do here?
	case 'EnableDisableEpochItems',
		itemlist = {'EpochsStartText','EpochsStartMenu','EpochsStopText','EpochsStopMenu',...
			'ViewEpochsStartText','ViewEpochsStartMenu','ViewEpochsStopMenu','ViewEpochsStopText'};
		for i=1:length(itemlist), 
			set(findobj(fig,'tag',itemlist{i}),'visible',vlt.data.onoff(length(ud.EpochStartSamples)>1));
		end;
	case 'MarkerSizeEdit',
		MarkerSizeString = get(findobj(fig,'tag','MarkerSizeEdit'),'string');
		ud.MarkerSize = str2num(MarkerSizeString);
		set(fig,'userdata',ud);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','DrawFeatures','fig',fig);
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
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','DrawSpikes','fig',fig);
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
				vlt.neuro.spikesorting.cluster_spikewaves_gui('command','AxesAutoBt','fig',fig); % repair the damage
			end;
		end;
		FixedAxesValues = axis;
		set(findobj(fig,'tag','AxesEdit'),'string',mat2str(FixedAxesValues));
	case 'AxesAutoBt',
		axes(findobj(fig,'tag','FeatureAxes'));
		axis auto;
		FixedAxesValues = axis;
		set(findobj(fig,'tag','AxesEdit'),'string',mat2str(FixedAxesValues));
	case 'FindVisibleSpikes', % spikes that are currently being viewed in the epoch, uses input variable 'indexes' if available
		viewepochsstartvalue = get(findobj(fig,'tag','ViewEpochsStartMenu'),'value');
		viewepochsstopvalue = get(findobj(fig,'tag','ViewEpochsStopMenu'),'value');
			% line below might be slow if number of spikes is large
		if exist('indexes')~=1,
			indexes = 1:size(ud.waves,3);
		end;
		[inds_visible,dummy,inds_notvisible] = vlt.signal.samplesinepochs(indexes, ud.EpochStartSamples, viewepochsstartvalue, viewepochsstopvalue);
		varargout{1} = inds_visible; 
		varargout{2} = inds_notvisible;
	case 'Draw',
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','DrawFeatures','fig',fig);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','DrawSpikes','fig',fig);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','UpdateMergeQualityMenu','fig',fig);
	case 'DrawFeatures',
		axes(findobj(fig,'tag','FeatureAxes'));
		cla;
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
			% only examine 'visible' spikes
			[inds_visible,inds_invisible] = vlt.neuro.spikesorting.cluster_spikewaves_gui('command','FindVisibleSpikes','fig',fig,'indexes',inds);
			inds = inds_visible; 
			% and also restrict for spikes that are 'present' in the cluster
			[inds_present,dummy,inds_notpresent] = vlt.signal.samplesinepochs(inds, ud.EpochStartSamples, ...
				find(strcmp(ud.clusterinfo(clusteridhere).EpochStart,ud.EpochNames)) , ...
				find(strcmp(ud.clusterinfo(clusteridhere).EpochStop,ud.EpochNames)) );
			inds = inds_present;
			hold on;
			if dim>=3,
				plot3(ud.F(inds,1),ud.F(inds,2),ud.F(inds,3),'.','color',thecolor,'MarkerSize',ud.MarkerSize);
				if ~isempty(inds_notpresent),
					plot3(ud.F(inds_notpresent,1),ud.F(inds_notpresent,2),ud.F(inds_notpresent,3),'.','color',ud.NotPresentColor,MarkerSize',ud.MarkerSize);
				end;
			elseif dim==2,
				plot(ud.F(inds,1),ud.F(inds,2),'.','color',thecolor,'MarkerSize',ud.MarkerSize);
				if ~isempty(inds_notpresent),
					plot(ud.F(inds_notpresent,1),ud.F(inds_notpresent,2),'.','color',ud.NotPresentColor,'MarkerSize',ud.MarkerSize);
				end;
			elseif dim==1,
				plot(ud.F(inds,1),ud.F(inds,1),'.','color',thecolor,'MarkerSize',ud.MarkerSize);
				if ~isempty(inds_notpresent),
					plot(ud.F(inds_notpresent,1),ud.F(inds_notpresent,1),'.','color',ud.NotPresentColor,'MarkerSize',ud.MarkerSize);
				end;
			end;
		end;
		box off; % good taste
		MarkerSizeString = int2str(ud.MarkerSize);
		set(findobj(fig,'tag','MarkerSizeEdit'),'string',MarkerSizeString);
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','AxesEdit','fig',fig); % adjust axis if necessary
		drawnow;
	case 'DrawSpikes',
		oldaxes = findobj(fig,'-regexp','tag','SpikeAxes*');
		try, delete(oldaxes); end;
		clusters = unique(ud.clusterids);
		if isnan(clusters(end)), clusters = clusters(1:find(isnan(clusters),1,'first')); end;  % take only 1 NaN from unique
		cluster_id_numbers = [];
		for i=1:length(ud.clusterinfo), % find corresponding clusterid numbers
			cluster_id_numbers(end+1) = str2num(ud.clusterinfo(i).number);
		end;

		[inds_visible,inds_invisible] = vlt.neuro.spikesorting.cluster_spikewaves_gui('command','FindVisibleSpikes','fig',fig);

		% column boundaries

		left_edge = 10+ud.windowfeaturewidth;
		right_edge = ud.windowwidth;
		middle_edge = (left_edge+right_edge)/2;
		ax_width = middle_edge - left_edge -15;

		% row boundaries

		num_rows = ceil(length(clusters)/2);
		axesrows = linspace(ud.windowheight-5, 5, num_rows+1);
		ax_height = axesrows(1)-axesrows(2);
		currentrow = 0;

		A = [];
		ax = {};

		for i=1:length(clusters),
			if ~isnan(clusters(i)),
				clusteridhere = find(cluster_id_numbers==clusters(i));
				inds = find(ud.clusterids==clusters(i));
				colorid = 1 + mod(i-1, size(ud.ColorOrder,1));
				thecolor = ud.ColorOrder(colorid,:);
			else,
				clusteridhere = find(isnan(cluster_id_numbers));
				inds = find(isnan(ud.clusterids));
				thecolor = ud.UnclassifiedColor;
			end;
			% restrict viewing to 'visible' spikes
			[inds_visible,inds_invisible] = vlt.neuro.spikesorting.cluster_spikewaves_gui('command','FindVisibleSpikes','fig',fig,'indexes',inds);
			inds = inds_visible;
			% restrict viewing to 'visible' spikes when the cluster is 'good'/'present'
			inds_present = vlt.signal.samplesinepochs(inds, ud.EpochStartSamples, ...
				find(strcmp(ud.clusterinfo(clusteridhere).EpochStart,ud.EpochNames)) , ...
				find(strcmp(ud.clusterinfo(clusteridhere).EpochStop,ud.EpochNames)) );
			inds = inds_present;
			if mod(i,2),
				currentrow = currentrow + 1; 
				ax{currentrow,1} = axes('units','normalized','position',...
					vlt.matlab.graphics.pixels2normalized([0 0 ud.windowwidth ud.windowheight],[left_edge axesrows(currentrow+1) ax_width ax_height]),...
					'tag',['SpikeAxes' int2str(i)]);
			else,
				ax{currentrow,2} = axes('units','normalized','position',...
					vlt.matlab.graphics.pixels2normalized([0 0 ud.windowwidth ud.windowheight],[middle_edge+10 axesrows(currentrow+1) ax_width ax_height]),...
					'tag',['SpikeAxes' int2str(i)]);
			end;
			vlt.neuro.spikesorting.plotspikewaves(ud.waves(:,:,inds),1:length(inds),'ColorOrder',thecolor,'RandomSubset',ud.RandomSubset,'RandomSubsetSize',ud.RandomSubsetSize);
			box off;
			axis off;
			A = [A ; axis ];
		end;
		% re-do axes
		currentrow = 0;
		for i=1:length(clusters),
			if mod(i,2),
				currentrow = currentrow + 1;
				axes(ax{currentrow,1});
			else,
				axes(ax{currentrow,2});
			end;
			axis([min(A(:,1)) max(A(:,2)) min(A(:,3)) max(A(:,4))]);
			set(gca,'tag',['SpikeAxes' int2str(i)]);
			hold on;
			plot(ud.spikewaves2NpointfeatureSampleList(1)*[1 1],[min(A(:,3)) max(A(:,4))],'--','color',[0.5 0.5 0.5]);
			plot(ud.spikewaves2NpointfeatureSampleList(2)*[1 1],[min(A(:,3)) max(A(:,4))],'--','color',[0.5 0.5 0.5]);
			plot(ud.spikewaves2pcaRange(1)*[1 1],[min(A(:,3)) max(A(:,4))],'--','color',[0.0 0.0 0.5]);
			plot(ud.spikewaves2pcaRange(2)*[1 1],[min(A(:,3)) max(A(:,4))],'--','color',[0.0 0.0 0.5]);
		end;
		vlt.neuro.spikesorting.cluster_spikewaves_gui('command','RelabelSpikes','fig',fig);
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
			inds = vlt.signal.samplesinepochs(inds, ud.EpochStartSamples, get(findobj(fig,'tag','ViewEpochsStartMenu'),'value'), get(findobj(fig,'tag','ViewEpochsStopMenu'),'value'));
                        inds = vlt.signal.samplesinepochs(inds, ud.EpochStartSamples, ...
                                find(strcmp(ud.clusterinfo(i).EpochStart,ud.EpochNames)) , ...
                                find(strcmp(ud.clusterinfo(i).EpochStop,ud.EpochNames)) );
			Number_match = length(inds);
			text(A(:,1), A(:,3)+0.9*A(:,4)-A(:,3), ud.clusterinfo(i).number, ...
				'horizontalalignment','left','fontweight','bold','fontsize',12);
			text(A(:,1)+1*(A(:,2)-A(:,1)), A(:,3)+0.1*(A(:,4)-A(:,3)),...
				['N=' int2str(Number_match) ', Q=' ud.clusterinfo(i).qualitylabel ],...
				'horizontalalignment','right');
		end;
	case 'DrawSelectedSpike',

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
					[inds,dummy,inds_notpresent] = vlt.signal.samplesinepochs(inds, ud.EpochStartSamples, ...
		                                find(strcmp(ud.clusterinfo(i).EpochStart,ud.EpochNames)) , ...
						find(strcmp(ud.clusterinfo(i).EpochStop,ud.EpochNames)) );
					ud.clusterids(inds_notpresent) = NaN;
					ud.clusterinfo(i).number_of_spikes = length(inds);
					ud.clusterinfo(i).meanshape = nanmean(ud.waves(:,:,inds),3);
				end;

				if any(isnan(ud.clusterids)), % if we have NaN clusterids, make sure there is corresponding clusterinfo
					A = isempty(ud.clusterinfo);
					if ~A,
						B = find(strncmp('NaN',{ud.clusterinfo.number},3));
					end;
					if A | isempty(B), % we need to add a clusterinfo for NaN
						ud.clusterinfo(end+1)=struct('number','NaN','qualitylabel','Unselected','number_of_spikes',sum(isnan(ud.clusterids)), ...
						'meanshape',nanmean(ud.waves(:,:,find(isnan(ud.clusterids))),3),'EpochStart',ud.EpochNames{1},'EpochStop',ud.EpochNames{end});
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
