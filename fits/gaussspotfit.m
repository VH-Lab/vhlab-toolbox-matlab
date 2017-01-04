function [mu, C, a, fit_responses] = gaussspotfit(xrange, yrange, x_ctr, y_ctr,radius,response)
% GAUSSSPOTFIT - Fit a 2d gaussian to data
%
%  [MU,C,AMP,SIZES,FIT_RESPONSES] = GAUSSSPOTFIT(XRANGE, YRANGE, X_CTR,Y_CTR,...
%                       RADIUS,RESPONSE)
%
%  Fits a 2d gaussian PDF to responses to circle stimulation at different positions.
%
%  INPUTS:
%    XRANGE and YRANGE specify the size of the stimulus field. They should be vectors:
%    (e.g., XRANGE = 0:800; YRANGE=0:600).
%    X_CTR, Y_CTR, RADIUS, and RESPONSE are vectors that describe the stimulus circles.
%    X_CTR and Y_CTR contain center locations in X and Y; RADIUS has the diameter
%    RESPONSE is the response of the system to that circle.
%  OUTPUTS:
%    MU - The mean of the best-fit gaussian PDF, in X and Y
%    C  - The covariance matrix of the best-fit gaussian PDF
%    AMP - The amplitude of the response for each circle size.
%    SIZES - The sizes that are associated with each amplitude.
%    FIT_RESPONSES - the fit responses

[X,Y] = meshgrid(xrange,yrange);

radii = unique(radius);

 % initial guesses
amp_initial = [];
for r=1:length(radii),
	inds = find(radius==radii(r));
	[amp_initial(r),themaxind] = max(response(inds));
	mu = [x_ctr(themaxind) y_ctr(themaxind)];
	C = radii(r).^2 * [1 0; 0 1];
end;

 % ellipse_params, 1 column per ellipse; [x_ctr, y_ctr, a, b, and rotation]
ellipse_params = [x_ctr(:)' ; y_ctr(:)'; radius(:)'; radius(:)'; 0*x_ctr(:)'];

Upper = [ max(xrange); max(yrange); 10*max(radii)^2; 10*(max(radii)^2); 10*max(radii)^2; Inf ];
Lower = [ min(xrange); min(yrange); 0; -10*(max(radii)^2); 0;0];
StartPoint = [ mu(1); mu(2); C(1);C(2);C(4); max(amp_initial)];

x = lsqcurvefit(@(x,xdata) ellipse_on_mvnpdf_x0(x,xdata,X,Y),StartPoint,ellipse_params,response,Lower,Upper);

fit_responses = ellipse_on_mvnpdf_x0(x,ellipse_params,X,Y);

mu = [x(1) x(2)];
C = [x(3) x(4);x(4) x(5)];
a = x(6);


