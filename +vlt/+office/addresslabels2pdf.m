function addresslabels2pdf(labels, varargin)
% ADDRESSLABELS2PDF - print address labels to a set of PDFs following a template
%
% vlt.office.addresslabels2pdf(LABELS, ...)
%
% This prints address labels LABELS to many pieces of figure 'paper'. 
% It follows the template described below. LABELS{i}{:} is a cell
% array that contains each line of text for each label.
%  
% This function accepts name/value pairs that modify its default behavior:
%
% Parameter (default)         | Description
% -------------------------------------------------------------------------
% units ('inches')            | The units to use
% first_label_Y (1.0)         | The location of the first label in X
% first_label_X (1.5025)      | The location of the first label in Y
% dX (2.75)                   | Offset between columns (center-to-center)
% dY (1)                      | Offset between rows (center-to-center)
% ncolumns (10)               | Number of columns per sheet
% nrows (3)                   | Number of rows per sheet
%                             |   (These are for Avery Labels 8160)
% fontsize (13)               | Fontsize to use

units = 'inches';
first_label_Y = 1.0;
first_label_X = 1.5025;
dX = 2.75;
dY = 1;
ncolumns = 3;
nrows = 10;
fontsize = 13;

figurecount = 0;

for i=1:numel(labels),
	if mod(i-1,nrows*ncolumns)==0, % need new figure

		if figurecount>0, % save the current figure
			p = get(f,'position');
			set(f,'position',[0 0 8.5 11]);
			axis([0 8.5 0 11]);
			set(f,'resize','off');
			saveas(f,[get(f,'tag') '.pdf']);
			set(f,'position',p);
		end

		figurecount = figurecount + 1;
		f = figure;
		set(f,'units',units,'PaperPosition',[0 0 8.5 11],'tag',['Label_Page' sprintf('%0.5d',figurecount)],'resize','off');
		ax=axes('units',units,'position',[0 0 8.5 11],'ydir','reverse');
		axes(ax);
	end;

	pos = i-(figurecount-1)*nrows*ncolumns;

	% number down first
	pos_y = 1 + mod(pos-1,nrows);
	pos_x = ceil(pos/nrows);

	hold on;
	t=text(first_label_X+(pos_x-1)*dX, ...
		first_label_Y+(pos_y-1)*dY,  ...
		labels{i}, ...
		'fontsize',fontsize,...
		'horizontalalignment','center',...
		'verticalalignment','middle');

	axis([0 8.5 0 11]);

end;

p = get(f,'position');
set(f,'position',[0 0 8.5 11]);
axis([0 8.5 0 11]);
set(f,'resize','off');
saveas(f,[get(f,'tag') '.pdf']);
set(f,'position',p);


