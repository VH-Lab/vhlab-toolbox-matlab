

recompute = 0;

if recompute,
	[Wt,Wt_err,shifts_t,lambda_t,corrs_t] = vlt.neuroscience.stdp.stdp_tripletvscorrelation;
	[Wr,Wr_err,shifts_r,freqs_r,lambda_r] = vlt.neuroscience.stdp.stdp_tripletvsratecorrelation;
end;


 % 

t_titles = {'Shift = -10ms', 'Shift = +10ms'};
for i=1:2,
	figure;
	legend_str = {};
	s=i;
	cols = jet(size(Wt,2));
	for j=1:size(Wt,2),
		errorbar(corrs_t,squeeze(Wt(s,j,:)),squeeze(Wt_err(s,j,:)),...
			'o-','color',cols(j,:),'linewidth',2);
		hold on;
		set(gca,'linewidth',1,'fontsize',14,'fontname','arial');
		box off;
		legend_str{end+1} = ['\lambda = ' num2str(lambda_t(j)) ];
	end;
	ylabel('\DeltaWeight');
	xlabel('Correlation');
	title(t_titles{i});
	legend(legend_str);
end;


r_titles = {'Shift = -10ms', 'Shift = +10ms'};
slist = [2 4];
for i=1:2,
	figure;
	legend_str = {};
	s=slist(i);
	cols = jet(size(Wr,3));
	for j=1:size(Wr,3),
		errorbar(freqs_r,squeeze(Wr(s,:,j)),squeeze(Wr_err(s,:,j)),...
			'o-','color',cols(j,:),'linewidth',2);
		hold on;
		set(gca,'linewidth',1,'fontsize',14,'fontname','arial');
		box off;
		legend_str{end+1} = ['\lambda = ' num2str(lambda_r(j)) ];
	end;
	ylabel('\DeltaWeight');
	xlabel('Rate modulation frequency');
	title(r_titles{i});
	legend(legend_str);
end;


  % make heat map of changes for rate/correlation

X = [-corrs_t(end:-1:2) corrs_t ];
Y = [ lambda_t ];
Z = [ squeeze(Wt(1,:,end:-1:2)) squeeze(Wt(2,:,:)) ];

figure;
set(gca,'fontsize',14,'fontname','arial');
[c,h] = contour(X,Y,Z);
clabel(c,h,'fontsize',12,'fontname','arial');
colorbar;
box off;

map = [  [ repmat([0 0],32,1) linspace(1,0,32)'] ; [  linspace(0,1,32)' repmat([0 0],32,1) ]];

 % attempt 2
figure;
set(gcf,'color',[1 1 1]);
pcolor(X,Y,Z)
shading flat
colorbar
hold on;
[c,h] = contour(X,Y,Z,'color',0*[1 1 1],'linewidth',2);
clabel(c,h,'fontsize',12,'fontname','arial','color',0*[1 1 1],'fontweight','bold');


