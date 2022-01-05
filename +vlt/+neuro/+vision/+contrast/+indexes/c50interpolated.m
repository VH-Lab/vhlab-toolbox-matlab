function c50i = c50interpolated(contrast, responses)
% C50INTERPOLATED - find the value of C50 through interpolation
%
% C50I = C50INTERPOLATED(CONTRAST, RESPONSES)
%
% Given RESPONSES (N-point vector) and the corresponding stimulus
% CONTRAST values (N-point vector), return the contrast that gives
% the half maximum value via linear interpolation.
%
% The units of CONTRAST should be between 0 and 1. If values larger than
% 1 are given, then it is assumed that CONTRAST is being given in units of
% percent, and CONTRAST is divided by 100. C50I will then be returned in units
% of percent.
%
% Note that this interpolated C50 does not equal the C50 of a Naka-Rushton equation.
%
% Example:
%    c = 0:0.01:1;
%    c50 = 0.2;
%    r = 10*vlt.fit.naka_rushton_func(c, c50);
%    figure;
%    plot(c,r,'-o');
%    xlabel('Contrast'); ylabel('Response'); box off;
%    c50i = vlt.neuro.vision.contrast.indexes.c50interpolated(c,r);
%    hold on;
%    A = axis;
%    plot([c50i c50i],[A(3) A(4)],'k--');

if ~isvector(contrast),
	error('CONTRAST input must be a vector.');
end;

if ~isvector(responses),
	error('RESPONSES input must be a vector.');
end;

units_are_percent = max(contrast(:)) > 1; % are we in percent?

if units_are_percent,
	contrast = contrast / 100; % convert to 0..1
end;

xx=0:0.01:1;
yy=interp1(contrast,responses,xx,'linear');
[CmaxR,i] = max(yy);
[j,c50R] = vlt.data.findclosest(yy,CmaxR/2);
c50i = xx(j);

if units_are_percent,
	c50i = c50i * 100;
end;


