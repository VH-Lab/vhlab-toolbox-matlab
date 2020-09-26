function [mu, C, a, mod_amp, mod_sigma, fit_responses] = gaussspotfit_mod(xrange, yrange, x_ctr, y_ctr,radius,response)
% GAUSSSPOTFIT - Fit a 2d gaussian to data
%
%  [MU,C,AMP,MOD_AMP, MOD_SIGMA, SIZES,FIT_RESPONSES] = vlt.fit.gaussspotfit(XRANGE, YRANGE, X_CTR,Y_CTR,...
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
%    C  - The covariane matrix of the best-fit gaussian PDF
%    AMP - The amplitude of the response for each circle size.
%    MOD_AMP - The amplitude of the surround modulation (multiplicative)
%    SIZES - The sizes that are associated with each amplitude.
%    FIT_RESPONSES - the fit responses

[X,Y] = meshgrid(xrange,yrange);

radii = unique(radius);

 % use the non surround version for initial guesses

[mu, C, amp_initial] = vlt.fit.gaussspotfit(xrange, yrange, x_ctr, y_ctr,radius,response);

 % ellipse_params, 1 column per ellipse; [x_ctr, y_ctr, a, b, and rotation]
ellipse_params = [x_ctr(:)' ; y_ctr(:)'; radius(:)'; radius(:)'; 0*x_ctr(:)'];

%Upper = [ max(xrange); max(yrange); 10*max(radii)^2; 10*(max(radii)^2); 10*max(radii)^2; Inf; 10000; 10];
%Lower = [ min(xrange); min(yrange); 0; -10*(max(radii)^2); 0;0;-10000;1];
Upper = [ 1.01*[mu(1); mu(2); C(1); C(2); C(4); amp_initial;]; Inf; 10];
Lower = [ 0.99*[mu(1); mu(2); C(1); C(2); C(4); amp_initial;]; -Inf;1];
StartPoint = [ mu(1); mu(2); C(1);C(2);C(4); amp_initial; 0; 1.1];

x = lsqcurvefit(@(x,xdata) vlt.math.mod_ellipse_on_mvnpdf_x0(x,xdata,X,Y),StartPoint,ellipse_params,response,Lower,Upper);

fit_responses = vlt.math.mod_ellipse_on_mvnpdf_x0(x,ellipse_params,X,Y);

mu = [x(1) x(2)];
C = [x(3) x(4);x(4) x(5)];
a = x(6);
mod_amp = x(7);
mod_sigma = x(8);


