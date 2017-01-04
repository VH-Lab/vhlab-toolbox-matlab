function [h_lines,h_text] = ROI_3dplot2d(cc, textsize, color, line_tag, text_tag, zdim)
% ROI_3DPLOT2D - Plot 3d ROIs on a 2-d image
%
%  [H_LINES, H_TEXT] = ROI_3DPLOT2D(CC, TEXTSIZE, COLOR, LINE_TAG, TEXT_TAG, ZDIM)
%
%  Inputs:
%     CC- An array of ROIS returned in CC by BWCONNCOMP
%     TEXTSIZE - The size font that should be used to
%                label the numbers (0 for none)
%     COLOR - The color that should be used, in [R G B] format (0...1)
%     LINE_TAG - A text string that is used to tag the line plots
%     TEXT_TAG - A text string that is used to tag the text
%
%  Outputs:
%     H_LINES - Handle array of line plots
%     H_TEXT - Handle array of text plots 
%                

h_lines = [];
h_text = [];
hold on; % make sure the plot is held
for i=1:cc.NumObjects,
	[dummy,perim2d] = ROI_3d2dprojection(cc.PixelIdxList{i},cc.ImageSize, zdim);

	for j=1:length(perim2d),
		if size(unique(perim2d{j},'rows'),1)==1,  % if a single point, flare it out
			perim2d{j}(1:5,2) = perim2d{j}(1,2) + [-0.5 -0.5 0.5 0.5  -0.5]';
			perim2d{j}(1:5,1) = perim2d{j}(1,1) + [-0.5 +0.5 0.5 -0.5 -0.5]';
		end;
		h_lines(end+1) = plot(perim2d{j}(:,2),perim2d{j}(:,1),...
			'linewidth',2,'color',color,'tag',line_tag);
		center_x = mean(perim2d{j}(:,2)); % get x center
		center_y = mean(perim2d{j}(:,1)); % get y center
		h_text(end+1) = text(center_x,center_y,int2str(i),...
			'horizontalalignment','center','color',color,'tag',text_tag);
	end;
end;

