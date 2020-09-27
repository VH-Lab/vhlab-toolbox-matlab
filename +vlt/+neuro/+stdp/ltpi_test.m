function ltpi_test
% LTPI_TEST - Simple test function to test the ltpi_apply.m function
%
%  Test function - read code

 
pre = [0 4.9 5];
post =  [0 1 2 3 4];

non_integrated = vlt.neuro.stdp.ltpi_apply(pre,post,'T1',10);

integrated = 0;
for t=0:1e-4:10,
	integrated = integrated + ltp_apply(pre,post,'T0',t);
end;

disp(['non_integrated is ' num2str(non_integrated) ' while integrated is ' num2str(integrated) '.']);

