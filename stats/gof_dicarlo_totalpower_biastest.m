function [gfNP,N,p] = gof_dicarlo_totalpower_biastest
% GOF_DICARLO_TOTALPOWER_BIASTEST
%
% The total power measure derived in GOF_DICARLO_TOTALPOWER has a bias that
% is explored here. One needs to read the code.
%
% Note that this function is named for a related measure in an appendix of a 1988 paper:
% DiCarlo JJ, Johnson KO, Hsaio SS. J Neurosci 1988:
% Structure of Receptive Fields in Area 3b of Primary Somatosensory Cortex in the Alert Monkey
% 

mymean = 0.2;
mystd = 0.1;
numsims = 10000;

N=unique(round(logspace(log10(4),log10(1000),100)));

p = [0 1 2];

gfNP = zeros(numel(N),numel(p));
gfNPstderr = zeros(numel(N),numel(p));

for m=1:numel(p),
	parfor i=1:numel(N),
		gf_raw = zeros(1,numsims);
		n = N(i);
		for s=1:numsims,
			data = mymean + mystd * randn(n,1);
			params = polyfit([1:n]',data(:),p(m));
			myfit = polyval(params,data);
			gf_raw(s) = gof_dicarlo_totalpower(data,myfit,1);
		end;
		gfNP(i,m) = mean(gf_raw(:));
		gfNPstderr(i,m) = stderr(gf_raw(:));
	end;
end;

colors = repmat(linspace(0,1,5)' , 1, 3);

figure;
for m=1:numel(p),
	mhere = m;
	hold on;
	errorbar(N,gfNP(:,mhere),gfNPstderr(:,mhere),gfNPstderr(:,mhere),'o-','color',colors(m,:));
end;
ylabel('Raw GOF');
xlabel('N');
box off

