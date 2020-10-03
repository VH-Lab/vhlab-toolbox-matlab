function ellipse_out = gauss2d_ellipse(mu, C, N)
% GAUSS2D_ELLIPSE Compute a fullwidth at half-weight ellipse from a 2d gaussian
%
%  ELLIPSE_OUT = vlt.math.gauss2d_ellipse(MU, C, [N])
%
%  Given a 2-d multivariate normal that is described with a mean MU
%  and covariance matrix C, return the size of the major and minor 
%  axes at half-height and points for an ellipse that circles the
%  mean at the location of the half-height contour.
%
%  The equation of the half max ellipse is:
%     (x-mu(1))^2 / a^2 + (y-mu(2))^2) / b^2 == 1
%
%  N is an optional argument (default 10) that determines the number
%  of points to include in each branch of the ellipse graph. (The
%  total number of points will be 2*N.)
%
%  The structure ELLIPSE_OUT contains the parameters of the ellipse:
%  Fieldname          | Description
%  -----------------------------------------------------------------
%  plot_ellipse       | Ellipse plot points (2 by 2*N); the first 
%                     |   row are the X points, the second rows are
%                     |   the Y points
%  a                  | The value of a in the ellipse equation
%  b                  | The value of b in the ellipse equation
%  major              | max(a,b) - the major axis
%  minor              | min(a,b) - the minor axis
%
%
%  w/ contribution by Shen Wang

if nargin<3, N = 10; end;

[V,D] = eig(C);
D = sqrt(diag(D));
[D_max,max_index] = max(D);
[D_min,min_index] = min(D);

phi_x = acos(dot(V(:,max_index),[1 0])/norm(V(:,max_index)));
phi_y = acos(dot(V(:,max_index),[0 1])/norm(V(:,max_index)));

if phi_y > pi / 2,
	phi = pi-phi_x;
else,
	phi = phi_x;
end;

k = 1/(2*det(C)*log(2));

theta_grid = linspace(0,2*pi,N);

a = sqrt((sin(phi)^4-cos(phi)^4)/(sin(phi)^2*C(1)*k-cos(phi)^2*C(4)*k));
b = sqrt((sin(phi)^4-cos(phi)^4)/(sin(phi)^2*C(4)*k-cos(phi)^2*C(1)*k));

ellipse_x_r  =   a*cos( theta_grid );
ellipse_y_r  =   b*sin( theta_grid );

R = [ cos(phi) -sin(phi); sin(phi) cos(phi) ];
plot_ellipse = R*[ellipse_x_r; ellipse_y_r] + repmat([mu(1); mu(2)], [1, N]);

major = max(a,b);
minor = min(a,b);

ellipse_out = vlt.data.var2struct('plot_ellipse','a','b','major','minor');
