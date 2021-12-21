function [s,c_criterion] = contrastfit2sensitivity(nkparameters, criterion)
% CONTRASTFIT2SENSITIVITY - Compute contrast sensitivity
%
%  [S,C_CRITERON] = vlt.neuro.vision.contrast.indexes.contrastfit2sensitivity(...
%	NKPARAMETERS, CRITERION)
%
%  Given Naka-Rushton fit parameters (either [Rm C50], [Rm C50 N], or [Rm C50 N S])
%  computes the first contrast C_CRITERION where the response exceeds CRITERION.
%  The sensitivity S = 1/C_CRITERION is also computed.
%
%  If there is no response that exceeds the criterion, then the sensitivity S is 0
%  and the C_CRITERION is Inf.
%
%  Example:
%    c = 0:0.1:1;
%    rm = 10;
%    c50 = 0.3;
%    r = rm*vlt.fit.naka_rushton_func(c,c50);
%    figure;
%    plot(c,r,'b-');
%    xlabel('Contrast'); ylabel('Response'); box off;
%    [s,c_criterion] = vlt.neuro.vision.contrast.indexes.contrastfit2sensitivity([rm c50],2);
%    hold on
%    A = axis;
%    plot(c_criterion*[1 1],A([3 4]),'k-');
%    title(['Contrast sensitivity is ' num2str(s) '.']);
%

cfit = 0:0.0001:1; % high resolution view

rm = nkparameters(1);
c50 = nkparameters(2);
n = 1;
s = 1;

if numel(nkparameters)>2,
	n = nkparameters(3);
end;

if numel(nkparameters)>3,
	s = nkparameters(4);
end;

r = rm*vlt.fit.naka_rushton_func(cfit,c50,n,s);

index = find(r>=criterion,1,'first');

if isempty(index),
	c_criterion = Inf;
else,
	c_criterion = cfit(index);
end;

s = 1/c_criterion;
