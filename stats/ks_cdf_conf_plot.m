function h = ks_cdf_conf_plot(Xvalues,minCDF,maxCDF,xmin,xmax)
% KS_CDF_CONF_PLOT - Plot gray patch of confidence around a CDF
%
%    H = KS_CDF_CONF_PLOT(XVALUES, MINCDF, MAXCDF, XMIN,XMAX);
%
%   Plots a gray 'patch' around a sample CDF indicating the confidence in
%   the true distribution.  
%
%   It is assumed the XVALUES, MINCDF, and MAXCDF are returned from
%   KS_CDF_CONF.  Use XMIN and XMAX to specify the minimum and maximum X values
%   used for the plot.

h = patch([xmin; Xvalues; xmax; xmax; Xvalues(end:-1:1); xmin],...
	[minCDF(1); minCDF; minCDF(end); maxCDF(end); maxCDF(end:-1:1); maxCDF(1)],0.5*ones(1,3))
