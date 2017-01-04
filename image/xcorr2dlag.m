function xc = xcorr2dlag(w1,w2,xlags,ylags)
% XCORR2DLAG - 2-d cross-correlation computed at specified lags
%
%   XC = XCORR2DLAG(W1,W2,XLAGS,YLAGS)
%
%  Computes cross-correlation of two-dimensional matricies
%  W1 and W2 at the specified lags in x (XLAGS) and in y
%  (YLAGS).  On most platforms this function runs a MEX file
%  written for speed and therefore there is no error checking to
%  make sure W1 and W2 are the same size and that XLAGS and YLAGS
%  are in bounds.  
%
%  XC is a matrix LENGTH(YLAGS)xLENGTH(XLAGS).

xc = [];
for x=1:length(xlags),
		x1b = max(1,1+xlags(x));
		x1e = min(size(w1,2),size(w1,2)+xlags(x));
		x2b = max(1,1-xlags(x));
		x2e = min(size(w1,2),size(w1,2)-xlags(x));
	for y=1:length(ylags),
		y1b = max(1,1+ylags(y));
		y1e = min(size(w1,1),size(w1,1)+ylags(y));
		y2b = max(1,1-ylags(y));
		y2e = min(size(w1,1),size(w1,1)-ylags(y));
		xc(y,x)=sum(sum(w1(y1b:y1e,x1b:x1e).*w2(y2b:y2e,x2b:x2e)));
	end;
end;
