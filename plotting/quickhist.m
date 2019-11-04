function [N,x] = quickhist(data, binedges)

bins = [-Inf binedges Inf];
x = [ binedges(1:end-1) ] +mean(diff(binedges))/2;
N = histc(data,bins);
N = N(2:end-2);