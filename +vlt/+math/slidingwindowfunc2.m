function [Yn,Xn] = slidingwindowfunc2(X, Y, start, stepsize, stop, windowsize,func,zeropad)
% SLIDINGWINDOWFUNC2 - Sliding window analysis for 1-dimensional data
%
%  [Yn,Xn] = SLIDINGWINDOWFUNC2(X,Y,START,STEPSIZE,STOP,WINDOWSIZE,...
%             FUNC,ZEROPAD)
%
%  Slides a window of WINDOWSIZE across the data and performs
%  the function FUNC on the set of ordered pairs defined in 
%  X and Y.  The window starts at location START and stops at
%  location STOP on X.  STEPSIZE determines how far the window is
%  advanced at each step.
%
%  FUNC should be a string describing the function to be used.For example:
%  'mean',  or 'median'.  
%
%  If ZEROPAD is 1, then a 0 is coded if no points are found within a
%       given window.
%  If ZEROPAD is 0, and if no points are found within a given window, no
%       Xn or Yn point is added for that window.
%
%  Xn is the center location of each window and Yn is the result of the
%  function in each window.

Xn = []; Yn = [];
for i=start:stepsize:stop-windowsize, % step the window
	INDs = find(X>=i&X<i+windowsize); % find all time points in window
	if zeropad|~isempty(INDs),
		Xn(end+1) = mean([i i+windowsize]); % window center location in Xn
	end;
	if ~isempty(INDs), % if we have values, evaluate the window function
		eval(['Yn(end+1)=' func ' (Y(INDs));']);
        y = Y(INDs)';
	end;
	if zeropad&isempty(INDs), Yn(end+1) = 0; end;
end;
