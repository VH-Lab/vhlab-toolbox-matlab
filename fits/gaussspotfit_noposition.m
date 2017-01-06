function [mu, C, a, fit_responses] = gaussspotfit_noposition(xrange, yrange, x_ctr, y_ctr,radius,response)
% GAUSSSPOTFIT - Fit a 2d gaussian to data
%
%  [MU,C,AMP,SIZES,FIT_RESPONSES] = GAUSSSPOTFIT_NOPOSITION(XRANGE, YRANGE, RADIUS, RESPONSE)
%
%  Fits a 2d gaussian PDF to responses to circle / aperture stimulation.
%
%  INPUTS:
%    XRANGE and YRANGE specify the size of the stimulus field. They should be vectors:
%    (e.g., XRANGE = 0:800; YRANGE=0:600).
%    X_CTR, Y_CTR, RADIUS, and RESPONSE are vectors that describe the stimulus circles.
%    RESPONSE is the response of the system to that circle.
%  OUTPUTS:
%    MU - Always [0 0]
%    C  - The covariance matrix of the best-fit gaussian PDF; always [C1 0 ; 0 C1]
%    AMP - The amplitude of the response for each circle size.
%    SIZES - The sizes that are associated with each amplitude.
%    FIT_RESPONSES - the fit responses

[X,Y] = meshgrid(xrange,yrange);

radii = unique(radius);

 % initial guesses
amp_initial = [];
[amp_initial,themaxind] = max(response(inds));
C = radii(themaxind).^2 * [1 0; 0 1];

 % ellipse_params, 1 column per ellipse; [x_ctr, y_ctr, a, b, and rotation]
ellipse_params = [x_ctr(:)' ; y_ctr(:)'; radius(:)'; radius(:)'; 0*x_ctr(:)'; ((radius(:)')>0)-1 ] ;

Upper = [ 10*max(radii)^2; Inf ];
Lower = [ 0; 0];
StartPoint = [ C(1); max(amp_initial)];

x = lsqcurvefit(@(x,xdata) ellipse_on_mvnpdf_noposition_x0(x,xdata,X,Y),StartPoint,ellipse_params,response,Lower,Upper);

fit_responses = ellipse_on_mvnpdf_noposition_x0(x,ellipse_params,X,Y);

mu = [0 0];
C = [x(1) 0 ; 0 x(1)];
a = x(2);


