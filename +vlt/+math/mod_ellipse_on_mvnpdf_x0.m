function Y = ellipse_on_mvnpdf_x0(x0, ellipse_params, xmesh,ymesh)
% ELLIPSE_ON_MVNPDF_X0 - Calcluate 'response' of an ellipse on multivariate normal
%
%  Y=vlt.math.ellipse_on_mvnpdf_x0(X,ELLIPSE_PARAMS,XMESH,YMESH)
%
%  Computes the overlap of an ellipse on a multivariate normal distribution.
%
%  This form facilitates passing to LSQCURVEFIT because the parameters MU and
%  SIGMA are all passed in a vector, X0
%
%  Inputs:
%    X0 - A vector with the multivariate normal parameters
%        MU=[X0(1) X0(2)] : The mean for the multivariate normal pdf
%        SIGMA=[X0([3 4]);XO([4 5])] - the covariance matrix for the multivariate normal pdf
%        ALPHA = X0(6) - scale factor
%        MOD_AMP = X0(7) - scale factor for modulating surround
%        MOD_SIGMA = X0(8) - scale factor for SIGMA to determine surround
%        
%    ELLIPSE_PARAMS = a list of column vectors; each column describes 1 ellipse
%        the first row has the X_Ctr position, the second row has the Y_Ctr
%        position, the third row has the X axis vertex, the fourth row has the
%        Y axis vertex, and the fifth row has the rotation (in radians)
%    XMESH = The X coordinates over which to calculate the response
%    YMESH = The Y coordinates over which to calculate the response
%  Outputs:
%    Y - The response, in a column vector, for each ellipse
%
%  See also: vlt.image.inside_ellipse, MVNPDF

mu = [x0(1) x0(2)];
sigma = [x0(3) x0(4) ; x0(4) x0(5)];

amp = x0(6);
mod_amp = x0(7);
mod_sigma = x0(8);

Y = amp*vlt.math.mod_ellipse_on_mvnpdf(xmesh,ymesh,ellipse_params,mu,sigma,mod_amp,mod_sigma);

