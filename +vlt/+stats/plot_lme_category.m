function [h,plot_info] = plot_lme_category(lme_, newtable, categories_name, Y_name, reference_category, group,varargin)
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
% This function takes name/value pairs that modify the default behavior:
% -----------------------------------------------------------------------
% | Parameters (default)         | Description:                         |
% |------------------------------|--------------------------------------|
% | colors (default plot colors) | An Nx3 array of colors to use for    |
% |                              |   the plots. Colors repeat if there  |
% |                              |   are more than N conditions.        |
% | within_category_space (1)    | X-axis spacing between groups within |
% |                              |   a category.                        |
% | across_category_space (2)    | X-axis spacing between categories    |
% | category_mean_linewidth (2)  | Linewidth for category mean lines    |
% | boxstate ('off')             | Box state for graph                  |
% | islog10 (0)                  | Is the data log10(original_data)?    |
% |                              |   If so, transform it back.          |
% -----------------------------------------------------------------------
% 
% Example:
%  load carsmall
%  tbl = table(Mfg,Model_Year,Model,MPG);
%  % compute standard linear mixed effects model
%  [lme,newtable] = vlt.stats.lme_category(tbl,'Model_Year','MPG','70','Mfg',0);
%  figure;
%  [h,plot_info]=vlt.stats.plot_lme_category(lme,newtable,'Model_Year','MPG','70','Mfg');
%  box off;
%

colors = [         0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840 ];

within_category_space = 1;
across_category_space = 2;

category_mean_linewidth = 2;

boxstate = 'off';
islog10 = 0;

vlt.data.assign(varargin{:});

x_center = [];
x = {};
y = {};
condition = [];
group_label = [];
rand_effect = [];
offset_effect = [];
condition_effect = [];
condition_boundaries = [];


 % plot categories in order

cc = lme_.Coefficients;

cats = categories(newtable.(categories_name));

[b,bnames,bstats] = randomEffects(lme_);

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
			n_here = numel(newtable(I_,:).(Y_name));
			random_xaxis_offsets = (rand(n_here,1) - 0.5)/2;
			x{end+1} = current_spot + within_category_space*0.5 + random_xaxis_offsets;
			x_center(end+1) = current_spot + within_category_space*0.5;
			y{end+1} = newtable(I_,:).(Y_name);
			condition(end+1) = i;
			group_label(end+1) = j;
			rand_effect(end+1) = b(j);
			offset_effect(end+1) = cc.Estimate(1);
			if i>1,
				condition_effect(end+1) = cc.Estimate(i);
			else,
				condition_effect(end+1) = 0;
			end;
			current_spot = current_spot + within_category_space;
		end;
	end;
	condition_boundaries(end,2) = current_spot;
	current_spot = current_spot + across_category_space;
end;

h = [];

for i=1:numel(x),
	color_here = colors(1 + mod(condition(i),size(colors,1)),:);
	dummytable = cell2table(repmat({cats{condition(i)}},numel(x{i}),1),'VariableNames',{'Condition'});
	dummytable2 = cell2table(repmat({bnames_levels{group_label(i)}},numel(x{i}),1),'VariableNames',{'Group'});
	h(end+1) = plot(x{i},y{i},'o','color',color_here);
	DataTipTempl = get(h(end),'DataTipTemplate');
	DataTipTempl.DataTipRows(end+1) = dataTipTextRow('Condition',dummytable.Condition);
	DataTipTempl.DataTipRows(end+1) = dataTipTextRow('Group',dummytable2.Group);
	hold on;
	h(end+1) = plot(x_center(i)+[-0.5 0.5],(rand_effect(i)+offset_effect(i)+condition_effect(i))*[1 1],...
		'-','color',[0 0 0]);
	dummytable = cell2table(repmat({cats{condition(i)}},2,1),'VariableNames',{'Condition'});
	dummytable2 = cell2table(repmat({bnames_levels{group_label(i)}},2,1),'VariableNames',{'Group'});
	DataTipTempl = get(h(end),'DataTipTemplate');
	DataTipTempl.DataTipRows(end+1) = dataTipTextRow('Condition',dummytable.Condition);
	DataTipTempl.DataTipRows(end+1) = dataTipTextRow('Group',dummytable2.Group);
end;

intercept = cc.Estimate(1);

for i=1:numel(cats),
	h(end+1) = plot(condition_boundaries(i,:),[1 1]*cc.Estimate(i)+intercept*(i>1),'linewidth',category_mean_linewidth,...
		'color',[0 0 0]);
	h(end+1) = plot(mean(condition_boundaries(i,:))*[1 1],[-1 1]*cc.SE(i) + cc.Estimate(i)+intercept*(i>1),...
		'linewidth',category_mean_linewidth,'color',[0 0 0]);
end;

plot_info = vlt.data.var2struct('x_center','x','y','condition','group_label','rand_effect','offset_effect',...
	'condition_effect','condition_boundaries','cats','bnames_levels');

if islog10,
	for i=1:numel(h),
        set(h(i),'Ydata',10.^get(h(i),'Ydata'));
	end;
    set(gca,'yscale','log');
end;

A = axis;

axis([1-within_category_space condition_boundaries(end,2)+within_category_space A(3) A(4)]);

eval(['box ' boxstate]);

ylabel(Y_name,'interp','none');

set(gca,'xtick',mean(condition_boundaries,2),'xticklabel',cats);

