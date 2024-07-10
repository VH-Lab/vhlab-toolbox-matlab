function [mu, C, a, b, fit_responses, r_squared] = gaussspotfit_nopos_surr(xrange, yrange, radius, response)
% GAUSSSPOTFIT - Fit a 2d gaussian to data
%
%  [MU,C,AMP,B,FIT_RESPONSES, R_SQUARED] = vlt.fit.gaussspotfit_nopos_surr(XRANGE, YRANGE, RADIUS, RESPONSE)
%
%  Fits a 2d gaussian PDF with modulation to responses to circle / aperture stimulation.
%
%  The equation that is fit is STIMULUS(r) * AMP * G(r,MU,SIGMA) * (1+B*r)
%  The first half is an integrated Gaussian function (G(r,MU,SIGMA))
%  The second half is a modulating factor that depends linearly on the stimulus
%  diameter.
%  
%
%  INPUTS:
%    XRANGE and YRANGE specify the size of the stimulus field. They should be vectors:
%    (e.g., XRANGE = 0:800; YRANGE=0:600).
%    RADIUS is a vector that describes the radius of each stimulus. If the stimulus is a circle that 
%      is filled, RADIUS should be positive. If the stimulus is a circle that is empty (with the stimulus 
%      surrounding the center), the RADIUS should be negative. 
%    RESPONSE is a vector with the mean response to each stimulus.
%  OUTPUTS:
%    MU - Always [0 0]
%    C  - The covariance matrix of the best-fit gaussian PDF; always [C1 0 ; 0 C1]
%    AMP - The amplitude of the response
%    B - The modulating factor
%    FIT_RESPONSES - the fit responses
%    R_SQUARED - The error of the fit normalized by the square of the data around its mean

[X,Y] = meshgrid(xrange,yrange);

radii = unique(radius);

 % initial guesses
amp_initial = [];
[amp_initial,themaxind] = max(response);
C = radii(themaxind).^2 * [1 0; 0 1];

RR = max(radius(:));

% ellipse_params, 1 column per ellipse; [x_ctr, y_ctr, a, b, and rotation]
ellipse_params = [0*radius(:)'; 0*radius(:)';  abs(radius(:))'; abs(radius(:))'; 0*radius(:)'; 0*(radius(:)'>0)+(radius(:)'<0).*(-RR) ];

Upper = [ 2*max(radii)^2; Inf ; 0.5+0.5];
Lower = [ 0; 0; -0.5-0.5 ];
StartPoint = [ C(1)*10; amp_initial; 0];

x = lsqcurvefit(@(x,xdata) vlt.math.ellipse_on_mvnpdf_nopos_surr_x0(x,xdata,X,Y),StartPoint,ellipse_params,response(:),Lower,Upper);

fit_responses = vlt.math.ellipse_on_mvnpdf_nopos_surr_x0(x,ellipse_params,X,Y);

r_squared = 1 - sum((fit_responses-response(:)).^2) / sum((response(:) - nanmean(response(:))).^2);

mu = [0 0];
C = [x(1) 0 ; 0 x(1)];
a = x(2);
b = x(3);

