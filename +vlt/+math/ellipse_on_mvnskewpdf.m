function Y = ellipse_on_mvnpdf(xmesh, ymesh, ellipse_params, mu, sigma, alpha)
% ELLIPSE_ON_MVNPDF - Calcluate 'response' of an ellipse on skewed multivariate normal
%
%  Y=vlt.math.ellipse_on_mvnpdf(XMESH,YMESH,ELLIPSE_PARAMS,MU,SIGMA, ALPHA)
%
%  Computes the overlap of an ellipse on a multivariate normal distribution.
%
%  Inputs:
%    XMESH = The X coordinates over which to calculate the response
%    YMESH = The Y coordinates over which to calculate the response
%    ELLIPSE_PARAMS = a list of column vectors; each column describes 1 ellipse
%        the first row has the X_Ctr position, the second row has the Y_Ctr
%        position, the third row has the X axis vertex, the fourth row has the
%        Y axis vertex, and the fifth row has the rotation (in radians)
%    MU - The mean for the multivariate normal pdf; can be a column vector or row vector (see MVNPDF)
%    SIGMA - the covariance matrix for the multivariate normal pdf (must be 2x2, see MVNPDF)
%    ALPHA - 1x2, the skewness parameter (see vlt.math.mvnskewpdf)
%  Outputs:
%    Y - The response, in a column vector, for each ellipse
%
%  See also: vlt.image.inside_ellipse, vlt.math.mvnskewpdf

Y = zeros(size(ellipse_params,2),1);

try,
	mv = reshape(vlt.math.mvnskewpdf([xmesh(:) ymesh(:)],mu,sigma,alpha),size(xmesh,1),size(xmesh,2));
catch,
	sigma = [10000 0 ; 0 10000 ];  % make it lousy
	mv = reshape(vlt.math.mvnskewpdf([xmesh(:) ymesh(:)],mu,sigma,alpha),size(xmesh,1),size(xmesh,2));
end

for i=1:size(ellipse_params,2),
	Y(i) = sum(sum(...
			vlt.image.inside_ellipse(xmesh,ymesh,...
				ellipse_params(1,i),ellipse_params(2,i),...
				ellipse_params(3,i),ellipse_params(4,i),...
				ellipse_params(5,i)) .* mv ...
			));
end;

