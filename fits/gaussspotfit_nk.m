function [mu, C, a, c50, N, fit_responses] = gaussspotfit(xrange, yrange, x_ctr, y_ctr,radius,response)
% GAUSSSPOTFIT - Fit a 2d gaussian to data
%
%  [MU,C,AMP,C50, N, FIT_RESPONSES] = GAUSSSPOTFIT_NK(XRANGE, YRANGE, X_CTR,Y_CTR,...
%                       RADIUS,RESPONSE)
%
%  Fits a 2d gaussian PDF to responses to circle stimulation at different positions, with
%  response amplitude modulated by the Naka-Rushton function.
%
%  INPUTS:
%    XRANGE and YRANGE specify the size of the stimulus field. They should be vectors:
%    (e.g., XRANGE = 0:800; YRANGE=0:600).
%    X_CTR, Y_CTR, RADIUS, and RESPONSE are vectors that describe the stimulus circles.
%    X_CTR and Y_CTR contain center locations in X and Y; RADIUS has the diameter (SV NOTE: Did I write this?? Do I really mean diameter?)
%    RESPONSE is the response of the system to that circle.
%  OUTPUTS:
%    MU - The mean of the best-fit gaussian PDF, in X and Y
%    C  - The covariance matrix of the best-fit gaussian PDF
%    AMP - The amplitude of the response for each circle size.
%    C50 - 50% point of Naka Rushton response
%    N - N power of Naka Rushton response
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

Upper = [ max(xrange); max(yrange); 10*max(radii)^2; 10*(max(radii)^2); 10*max(radii)^2; Inf ; max(amp_initial); 5];
Lower = [ min(xrange); min(yrange); 0; -10*(max(radii)^2); 0; 0 ; 1 ; 0.5];
StartPoint = [ mu(1); mu(2); C(1);C(2);C(4); max(amp_initial); 1; max(amp_initial)/3];

x = lsqcurvefit(@(x,xdata) ellipse_on_mvnpdf_nk_x0(x,xdata,X,Y),StartPoint,ellipse_params,response,Lower,Upper);

fit_responses = ellipse_on_mvnpdf_nk_x0(x,ellipse_params,X,Y);

mu = [x(1) x(2)];
C = [x(3) x(4);x(4) x(5)];
a = x(6);
c50 = x(7);
N = x(8);

