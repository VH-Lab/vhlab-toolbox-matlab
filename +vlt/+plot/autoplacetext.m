function h = autoplacetext(textstring, varargin)
% AUTOPLACETEXT - Automatically place text within the current axes
%
%  H = vlt.plot.autoplacetext(TEXTSTRING)
%
%  At the present time, this function places the text string 
%  TEXTSTRING (which can be a simple string, or a cell list of 
%  strings) at the location 80% high, 50% centered, in the current
%  axes.
%
%  This function could be improved to examine the axes and 
%  put the text in a "non-busy" location.

a = axis;
y_text = 0.8 * a(4) + 0.2 * a(3);
x_text = 0.5 * (a(1) + a(2));

h=text(x_text,y_text,textstring,'horizontalalignment','center');
