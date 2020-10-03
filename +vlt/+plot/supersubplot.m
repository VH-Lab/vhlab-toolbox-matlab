function ax_h = supersubplot(fig, m, n, p)
% SUPERSUBPLOT - Organize axes across multiple figures
%
%  AX_H=vlt.plot.supersubplot(FIG, M, N, P)
%
%  Returns a set of axes that can be arranged across multiple
%  figures.
%
%  Inputs:
%      FIG - figure number of the first figure in series
%      M - The number of rows of plots in each figure
%      N - the number of columns of plots in each figure
%      P - the plot number to use, where the numbers go
%            from left to right, top to bottom, and then
%            continue across figures.
%
%  Outputs: AX_H - the axes handle
%
%  Example:
%       fig = figure;
%       ax = vlt.plot.supersubplot(fig,3,3,12);
%       % will return a subplot in position 3
%       % on a second figure
%    
%  See also: SUBPLOT, AXES


if isempty(fig), fig = figure; end; % make it if it's an empty variable
if ~ishandle(fig), fig = figure; end; % make it if it's not a good figure
ud = get(fig,'userdata'); % read the userdata field, which is for our use
if isempty(ud), ud = fig; end;

figure_number = ceil(p/(m*n)); % round up to nearest integer

if length(ud)<figure_number,
    ud(figure_number) = figure;
else,
    figure(ud(figure_number));
end;

plotnumber = p - m*n*(figure_number-1);

set(fig,'userdata',ud);

ax_h = subplot(m,n,plotnumber);
