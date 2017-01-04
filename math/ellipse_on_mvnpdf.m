function Y = ellipse_on_mvnpdf(xmesh, ymesh, ellipse_params, mu, sigma)
% ELLIPSE_ON_MVNPDF - Calcluate 'response' of an ellipse (or elliptical aperture) on multivariate normal
%
%  Y=ELLIPSE_ON_MVNPDF(XMESH,YMESH,ELLIPSE_PARAMS,MU,SIGMA)
%
%  Computes the overlap of an ellipse (or an elliptical aperature) on a
%  multivariate normal distribution.
%
%  Inputs:
%    XMESH = The X coordinates over which to calculate the response
%    YMESH = The Y coordinates over which to calculate the response
%    ELLIPSE_PARAMS = a list of column vectors; each column describes 1 ellipse
%        the first row has the X_Ctr position, the second row has the Y_Ctr
%        position, the third row has the X axis vertex, the fourth row has the
%        Y axis vertex, and the fifth row has the rotation (in radians)
%        The sixth row is optional; if it is 0, then the ellipse is a filled
%        ellipse. If it is -N, then the ellipse describes the aperature of
%        stimulation. The aperture is taken to be carved out of a larger circle of
%        diameter N.
%    MU - The mean for the multivariate normal pdf; can be a column vector or row vector (see MVNPDF)
%    SIGMA - the covariance matrix for the multivariate normal pdf (must be 2x2, see MVNPDF)
%    Note that the PDF is scaled by the step size of the mesh; it is assumed that
%    the mesh step size is constant.
%  Outputs:
%    Y - The response, in a column vector, for each ellipse
%
%  See also: INSIDE_ELLIPSE, MVNPDF

Y = zeros(size(ellipse_params,2),1);


if size(ellipse_params,1)<6,
	ellipse_params(6,:) = zeros(1,size(ellipse_params,2));
end;

try,
	mv = reshape(mvnpdf([xmesh(:) ymesh(:)],mu,sigma),size(xmesh,1),size(xmesh,2));
catch,
	sigma = [10000 0 ; 0 10000 ];  % make it lousy
	mv = reshape(mvnpdf([xmesh(:) ymesh(:)],mu,sigma),size(xmesh,1),size(xmesh,2));
end

  % normalize by dXdY
area = meshgridarea(xmesh,ymesh);
mv = mv.*area;

for i=1:size(ellipse_params,2),
	stimulus = inside_ellipse(xmesh,ymesh,...
				ellipse_params(1,i),ellipse_params(2,i),...
				ellipse_params(3,i),ellipse_params(4,i),...
				ellipse_params(5,i));
	if ellipse_params(6,i)<0, 
		% it is an aperture
		bigstimulus = inside_ellipse(xmesh,ymesh,...
				ellipse_params(1,i),ellipse_params(2,i),...
				-ellipse_params(6,i),-ellipse_params(6,i),...
				ellipse_params(5,i));
		stimulus = bigstimulus - stimulus; 
	end;
	Y(i) = sum(sum(stimulus.*mv));
end;

