function dO= pseudorandomorder(N, trials)
% PSEUDORANDOMORDER - random order where all stims are represented in each trial
%    
%  ORDER = vlt.stats.pseudorandomorder(STIMS, TRIALREPS)
%
%  Returns (in ORDER) a random order of stimulus presentation for stimuli numbered 1 to
%  STIMS.  Each trial (of which there are TRIALREPS) will have exactly 1 
%  presentation of each stimulus.

if N>1,
	p=[0:1/(N-1):1];
else,
	p=[];
end;

dO = randperm(N);

for i=2:trials,
	if N==1,
		dO = [ dO 1 ];
	else,
		r = rand(1,1);
		f=find(p(1:end-1)<r&p(2:end)>=r);
		n=[ 1:dO(end)-1 dO(end)+1:N];
		n=n(f);
		d=[ 1:n-1 n+1:N ];
		di = randperm(N-1);
		dO = [dO n d(di)];
	end;
end;


