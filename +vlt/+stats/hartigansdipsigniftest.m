
function		[dip, p_value, xlow,xup]=HartigansDipSignifTest(xpdf,nboot)

%  function		[dip,p_value, xlow,xup]=HartigansDipSignifTest(xpdf,nboot)
%
% calculates Hartigan's DIP statistic and its significance for the empirical
% p.d.f  XPDF (vector of sample values).
%
% This routine calls the matlab routine 'HartigansDipTest' that actually
% calculates the DIP NBOOT is the user-supplied sample size of boot-strap
% Code by F. Mechler (27 August 2002)

% calculate the DIP statistic from the empirical pdf

% sort and normalize to be in 0..1
[dip,xlow,xup, ifault, gcm, lcm, mn, mj]=vlt.stats.hartigansdiptest(xpdf);
N=length(xpdf);

% calculate a bootstrap sample of size NBOOT of the dip statistic for a uniform pdf of sample size N (the same as empirical pdf)
boot_dip=[];
for i=1:nboot
   unifpdfboot=sort(unifrnd(0,1,1,N));
   [unif_dip]=vlt.stats.hartigansdiptest(unifpdfboot);
   boot_dip=[boot_dip; unif_dip];
end;
boot_dip=sort(boot_dip);
p_value=sum(dip<boot_dip)/nboot;

% Plot Boot-strap sample and the DIP statistic of the empirical pdf
figure(1); clf;
[hy,hx]=hist(boot_dip,100); 
bar(hx,hy,'k'); hold on;
plot([dip dip],[0 max(hy)*1.1],'r:');

