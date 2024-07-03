function ops = plot_lme_category_options(options)
% PLOT_LME_CATEGORY_OPTIONS - set display options for PLOT_LME_CATEGORY
%
% OPS = PLOT_LME_CATEGORY_OPTIONS(...)
%
% Returns a structure with display options for the function
% PLOT_LME_CATEGORY.
%
% This function takes name/value pairs that modify the default behavior:
% -----------------------------------------------------------------------
% | Parameters (default)         | Description:                         |
% |------------------------------|--------------------------------------|
% | colors (default plot colors) | An Nx3 array of colors to use for    |
% |                              |   the plots. Colors repeat if there  |
% |                              |   are more than N conditions.        |
% | within_category_space (1)    | X-axis spacing between groups within |
% |                              |   a category.                        |
% | across_category_space (2)    | X-axis spacing between categories    |
% | category_mean_color ([0 0 0])| Color of category mean bars          |
% | category_mean_linewidth (4)  | Linewidth for category mean bars     |
% | group_mean_color ([0 0 0])   | Color of the group mean bars         |
% | group_mean_linewidth (2)     | Linewidth for group mean bars        |
% | point_marker_size (8)        | Marker size for individual points    |
% | point_marker_shape ('o')     | Marker shape                         |
% | boxstate ('off')             | Box state for graph                  |
% | islog10 (0)                  | Is the data log10(original_data)?    |
% |                              |   If so, transform it back.          |
% | isranked (0)                 | Is the data ranked (0/1)?            |
% | plot_original_data (1)       | If data is ranked (non-parametric)   |
% |                              |   should we plot original data (1) or|
% |                              |   should we plot the ranks (0)?      |
% | sort_random_effects (1)      | Should we plot random effects in     |
% |                              |   ascending order of effect size?    |
% -----------------------------------------------------------------------
%

arguments
	options.colors (:,3) double = vlt.plot.colorlist()
	options.within_category_space (1,1) double = 1
	options.across_category_space (1,1) double = 2
	options.category_mean_color (1,3) double = [0 0 0]
	options.category_mean_linewidth (1,1) double = 4
	options.group_mean_color (1,3) double = [0 0 0]
	options.group_mean_linewidth (1,1) double = 2
	options.point_marker_size (1,1) double = 8
	options.point_marker_shape (1,1) char = 'o'
	options.boxstate (1,:) char {mustBeMember(options.boxstate,{'on','off'})} = 'off'
	options.islog10 (1,:) logical = 0
	options.isranked (1,:) logical = 0
	options.plot_original_data (1,:) logical = 1
	options.sort_random_effects (1,:) logical = 1
	options.Y_label {mustBeText(options.Y_label)} = ''

end % arguments

ops = options;


