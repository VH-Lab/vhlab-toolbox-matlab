function [h,plot_info] = plot_lme_category(lme_, newtable, categories_name, Y_name, reference_category, group, varargin)
% LME_CATEGORY - calculate a mixed linear model for a variable measured in different fixed categories and random effects across group
%
% [H,PLOT_INFO] = PLOT_LME_CATEGORY(LME_, LMETABLE, CATEGORIES_NAME, Y_NAME, REFERENCE_CATEGORY, GROUP_NAME,...);
%
% Plot (in the current axes) the data in a random effects model. Each data point
% in the table LMETABLE column Y_NAME is plotted by GROUP and CATEGORY. The
% LME model mean value for each group and category is shown with a horizontal bar.
% The category means are shown with a thick horizontal bar and the standard
% error of the mean is shown as a thick vertical bar.
%
% Note that there is no Y_OP input to this function. Any Y_OP was already applied
% in the call to vlt.stats.lme_category.
%
% This function takes name/value pairs that modify the default behavior.
% See also: PLOT_LME_CATEGORY_OPTIONS, vlt.stats.plot_lme_category_options
% 
% Example:
%  load carsmall
%  tbl = table(Mfg,Model_Year,Model,MPG);
%  Y_op = 'Y'; % just use Y
%  % compute standard linear mixed effects model
%  [lme,newtable] = vlt.stats.lme_category(tbl,'Model_Year','MPG',Y_op,'70','Mfg',0);
%  figure;
%  [h,plot_info]=vlt.stats.plot_lme_category(lme,newtable,'Model_Year','MPG','70','Mfg');
%  box off;
%

arguments
	lme_ (1,1) LinearMixedModel
	newtable table
	categories_name (1,:) char
	Y_name (1,:) char
	reference_category (1,:) char
	group (1,:) char
end
arguments (Repeating)
	varargin
end

vo = vlt.stats.plot_lme_category_options(varargin{:}); % viewing options

x_center = [];
x = {};
y = {};
condition = [];
group_label = [];
rand_effect = [];
offset_effect = [];
condition_effect = [];
condition_boundaries = [];

Y_name_fixed = 'Y_data_for_fit';

 % plot categories in order

cc = lme_.Coefficients;

cats = categories(newtable.(categories_name));

[b,bnames,bstats] = randomEffects(lme_);

if vo.sort_random_effects,
	[b,b_order] = sort(b);
	bnames = bnames(b_order,:);
	bstats = bstats(b_order,:);
end;

bnames_levels = bnames.Level;

current_spot = 1;

for i=1:numel(cats),
	current_within = 0;
	% how many groups in this category?
	condition_boundaries(end+1,[1 2]) = [current_spot NaN];
	for j=1:numel(bnames_levels),
		grp = newtable.(group);
		% catch the unusual situation that grp is a char matrix
		if isa(grp,'char'),
			grp=mat2cell(grp,ones(size(grp,1),1),size(grp,2));
			for k=1:size(grp,1),
				grp{k} = strtrim(grp{k});
			end;
		end;
		I_ = find(cats{i}==newtable.(categories_name) & strcmp(bnames_levels{j},grp));
		if ~isempty(I_),
			n_here = numel(newtable(I_,:).(Y_name_fixed));
			random_xaxis_offsets = (rand(n_here,1) - 0.5)/2;
			x{end+1} = current_spot + vo.within_category_space*0.5 + random_xaxis_offsets;
			x_center(end+1) = current_spot + vo.within_category_space*0.5;
			if vo.isranked & vo.plot_original_data,
				Y = newtable(I_,:).('original_data');
			else,
				Y = newtable(I_,:).(Y_name_fixed);
			end;
			y{end+1} = Y; % Y_op already evaluated
			condition(end+1) = i;
			group_label(end+1) = j;
			rand_effect(end+1) = b(j);
			offset_effect(end+1) = cc.Estimate(1);
			if i>1,
				condition_effect(end+1) = cc.Estimate(i);
			else,
				condition_effect(end+1) = 0;
			end;
			if vo.isranked & vo.plot_original_data,
			end;
			current_spot = current_spot + vo.within_category_space;
		end;
	end;
	condition_boundaries(end,2) = current_spot;
	current_spot = current_spot + vo.across_category_space;
end;

if vo.isranked & vo.plot_original_data,
	original_data = newtable.('original_data');
	[u,u_indexes] = unique(original_data);
	ranked_data = newtable.(Y_name_fixed);
end;

h = [];

for i=1:numel(x),
	color_here = vo.colors(1 + mod(condition(i),size(vo.colors,1)),:);
	dummytable = cell2table(repmat({cats{condition(i)}},numel(x{i}),1),'VariableNames',{'Condition'});
	dummytable2 = cell2table(repmat({bnames_levels{group_label(i)}},numel(x{i}),1),'VariableNames',{'Group'});
	h(end+1) = plot(x{i},y{i},vo.point_marker_shape,'color',color_here,'markersize',vo.point_marker_size);
	DataTipTempl = get(h(end),'DataTipTemplate');
	DataTipTempl.DataTipRows(end+1) = dataTipTextRow('Condition',dummytable.Condition);
	DataTipTempl.DataTipRows(end+1) = dataTipTextRow('Group',dummytable2.Group);
	hold on;

	group_mean_value = rand_effect(i)+offset_effect(i)+condition_effect(i);
	if vo.isranked & vo.plot_original_data,
		group_mean_value = interp1(ranked_data(u_indexes),original_data(u_indexes),...
			group_mean_value,'linear');
	end;

	h(end+1) = plot(x_center(i)+[-0.5 0.5],group_mean_value*[1 1],...
		'-','color',vo.group_mean_color,'linewidth',vo.group_mean_linewidth);
	dummytable = cell2table(repmat({cats{condition(i)}},2,1),'VariableNames',{'Condition'});
	dummytable2 = cell2table(repmat({bnames_levels{group_label(i)}},2,1),'VariableNames',{'Group'});
	DataTipTempl = get(h(end),'DataTipTemplate');
	DataTipTempl.DataTipRows(end+1) = dataTipTextRow('Condition',dummytable.Condition);
	DataTipTempl.DataTipRows(end+1) = dataTipTextRow('Group',dummytable2.Group);
end;

intercept = cc.Estimate(1);

for i=1:numel(cats),
	condition_value = cc.Estimate(i)+intercept*(i>1);
	condition_stderr_bar = [-1 1] * cc.SE(i) + condition_value;
	if vo.isranked & vo.plot_original_data,
        if ~isempty(u_indexes),
		    X = interp1(ranked_data(u_indexes),original_data(u_indexes),...
			    [condition_value condition_stderr_bar],...
			    'linear');
		    condition_value = X(1);
		    condition_stderr_bar = X(2:3);
        end;
	end;
	h(end+1) = plot(condition_boundaries(i,:),[1 1]*condition_value,...
		'linewidth',vo.category_mean_linewidth,...
		'color',vo.category_mean_color);
	vlt.plot.movetoback(h(end));
	h(end+1) = plot(mean(condition_boundaries(i,:))*[1 1],condition_stderr_bar,...
		'linewidth',vo.category_mean_linewidth,...
		'color',vo.category_mean_color); 
	vlt.plot.movetoback(h(end));
end;

plot_info = vlt.data.var2struct('x_center','x','y','condition','group_label','rand_effect','offset_effect',...
	'condition_effect','condition_boundaries','cats','bnames_levels','vo');

if vo.islog10,
	for i=1:numel(h),
        set(h(i),'Ydata',10.^get(h(i),'Ydata'));
	end;
    set(gca,'yscale','log');
end;

A = axis;

axis([1-vo.within_category_space condition_boundaries(end,2)+vo.within_category_space A(3) A(4)]);

eval(['box ' vo.boxstate]);

ylabel(vo.Y_label);

set(gca,'xtick',mean(condition_boundaries,2),'xticklabel',cats);

