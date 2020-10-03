function movetoback(plot_h)

% vlt.plot.movetoback - Move a plot to the "back" of the "paper"
%
%  vlt.plot.movetoback(PLOT_H)
%
%  Moves the pot specified by the plot handle PLOT_H to
%  the "back" of the "paper" in the current axis.
%
%  Example:
%      figure; hold on;
%      h1 = plot([0 1],[0 1],'k','linewidth',2);
%      h2 = plot([0.5 0.5],[0 1],'r','linewidth',2);
%      % at this point, the red line in h2 is "above"
%      % the black line in h1
%      vlt.plot.movetoback(h2);
%      % now the red line is in "back"
%
%  PLOT_H can be a single handle or an array of handles.

if length(plot_h)>1,
	for i=1:length(plot_h),
		vlt.plot.movetoback(plot_h(i));
	end;
else,
	C = get(gca,'children');
	g = find(C==plot_h);
	if isempty(g), error(['Plot handle specified is not a child of the current axis']);
	else,
		C = C([1:g-1 g+1:end g]);
		set(gca,'children',C);
	end;
end;


