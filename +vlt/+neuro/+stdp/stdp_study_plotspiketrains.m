function stdp_study_plotspiketrains
 % plot spike-timing examples at different correlations, rates

N = 100;
tres = 0.001;

shifts = [-0.010 0.010]; % 10ms, pre/post shift
lambda = [ 0.1 1 10 20 40 50 ]; % mean rates
corrs = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];  % correlations

trainfig=figure;
set(trainfig,'color',[1 1 1]);

corrfig=figure;
set(corrfig,'color',[1 1 1]);

for i=1:3,

	switch i,
		case 1, s = 2; l = 2; c = 11;
		case 2, s = 2; l = 2; c = 6;
		case 3, s = 2; l = 2; c = 3;
	end;
	
	figure(trainfig);
	subplot(3,1,i);
	pre = vlt.neuroscience.spiketrains.spiketrain_poisson_n(lambda(l),N,tres);
	post = vlt.neuroscience.spiketrains.spiketrain_timingcorrelated(pre+shifts(s),corrs(c));
	vlt.neuroscience.spiketrains.spiketimes_plot(pre,'color',[0 0 1]);
	hold on;
	vlt.neuroscience.spiketrains.spiketimes_plot(post,'color',[0 1 0],'hashcenter',-0.5);
	box off;
	axis([0 10 -1 1])
	set(gca,'ytick',[]);

	figure(corrfig);
	subplot(2,2,i);
	[corr,lags] = vlt.neuroscience.spiketrains.spiketimes_correlation(pre,post,0.005,0.1);
	corr = 100 * corr / length(pre);
	bar(lags,corr,'k');
	box off;
	axis([-0.100 0.100 0 100]);
	
end;

trainfig=figure;
set(trainfig,'color',[1 1 1]);

corrfig=figure;
set(corrfig,'color',[1 1 1]);

for i=1:3,

	switch i,
		case 1, s = 2; l = 2; c = 9;
		case 2, s = 2; l = 3; c = 9;
		case 3, s = 2; l = 5; c = 9;
	end;
	
	figure(trainfig);
	subplot(3,1,i);
	pre = vlt.neuroscience.spiketrains.spiketrain_poisson_n(lambda(l),N,tres);
	post = vlt.neuroscience.spiketrains.spiketrain_timingcorrelated(pre+shifts(s),corrs(c));
	vlt.neuroscience.spiketrains.spiketimes_plot(pre,'color',[0 0 1]);
	hold on;
	vlt.neuroscience.spiketrains.spiketimes_plot(post,'color',[0 1 0],'hashcenter',-0.5);
	box off;
	axis([0 10 -1 1])
	set(gca,'ytick',[]);

	figure(corrfig);
	subplot(2,2,i);
	[corr,lags] = vlt.neuroscience.spiketrains.spiketimes_correlation(pre,post,0.005,0.1);
	corr = 100 * corr / length(pre);
	bar(lags,corr,'k');
	box off;
	axis([-0.100 0.100 0 100]);
	
end;

trainfig=figure;
set(trainfig,'color',[1 1 1]);

corrfig=figure;
set(corrfig,'color',[1 1 1]);

lambda = [ 0.1 1 10 20 40 50 ]; % mean rates
freqs = [0.1 0.5 1 5 10 20 30 50 100 150 200];
shifts = [-0.020 -0.010 0 0.010 0.020];

T = 0:0.001:100;

for i=1:3,
	switch i,
		case 1, s = 4; l = 3; f = 3;
		case 2, s = 4; l = 3; f = 5;
		case 3, s = 4; l = 6; f = 9;
	end;

        if shifts(s)<0,
                preshift = -shifts(s);
		postshift = 0;
        else,
                postshift = shifts(s);
		preshift = 0;
        end;
	
	figure(trainfig);
	subplot(3,1,i);
	pre = preshift+T(find(rand(size(T))<(tres*lambda(l)*sin(2*pi*freqs(f)*T))));
	post = postshift+T(find(rand(size(T))<(tres*lambda(l)*sin(2*pi*freqs(f)*T))));
	vlt.neuroscience.spiketrains.spiketimes_plot(pre,'color',[0 0 1]);
	hold on;
	vlt.neuroscience.spiketrains.spiketimes_plot(post,'color',[0 1 0],'hashcenter',-0.5);
	box off;
	axis([0 10 -1 1])
	set(gca,'ytick',[]);

	figure(corrfig);
	subplot(2,2,i);
	[corr,lags] = vlt.neuroscience.spiketrains.spiketimes_correlation(pre,post,0.005,0.1);
	corr = 100 * corr / length(pre);
	bar(lags,corr,'k');
	box off;
	axis([-0.100 0.100 0 100]);
end;

trainfig=figure;
set(trainfig,'color',[1 1 1]);

corrfig=figure;
set(corrfig,'color',[1 1 1]);

for i=1:3,
	switch i,
		case 1, s = 4; l = 2; f = 5;
		case 2, s = 4; l = 3; f = 5;
		case 3, s = 4; l = 5; f = 5;
	end;

        if shifts(s)<0,
                preshift = -shifts(s);
		postshift = 0;
        else,
                postshift = shifts(s);
		preshift = 0;
        end;
	
	figure(trainfig);
	subplot(3,1,i);
	pre = preshift+T(find(rand(size(T))<(tres*lambda(l)*sin(2*pi*freqs(f)*T))));
	post = postshift+T(find(rand(size(T))<(tres*lambda(l)*sin(2*pi*freqs(f)*T))));
	vlt.neuroscience.spiketrains.spiketimes_plot(pre,'color',[0 0 1]);
	hold on;
	vlt.neuroscience.spiketrains.spiketimes_plot(post,'color',[0 1 0],'hashcenter',-0.5);
	box off;
	axis([0 10 -1 1])
	set(gca,'ytick',[]);

	figure(corrfig);
	subplot(2,2,i);
	[corr,lags] = vlt.neuroscience.spiketrains.spiketimes_correlation(pre,post,0.005,0.1);
	corr = 100 * corr / length(pre);
	bar(lags,corr,'k');
	box off;
	axis([-0.100 0.100 0 100]);
end;

