function [c,pts] = cov_of_cloud(std1, std2, rotation, numpoints)
% COV_OF_CLOUD - generate a cloud of gaussian points and compute covariance matrix
%
% [C,PTS] = vlt.math.cov_of_cloud(STD1, STD2, ROTATION, NUMPOINTS)
%
% Sometimes you just want to generate a cloud of gaussian points, rotate them,
% and compute the covariance matrix. You know you should be able to directly
% calculate the covariance matrix, but you have a grant due, and you've got
% to move fast.
%
% Example:
%
%  [c,pts] = vlt.math.cov_of_cloud(2,0.04,1,1000);
%  figure;
%  subplot(2,2,1);
%  plot(pts(:,1),pts(:,2),'o');
%  subplot(2,2,2);
%  [X,T] = meshgrid([0:0.1:10],[0:0.001:0.3]);
%  Z = X * 0;
%  Z = Z + reshape(mvnpdf([X(:) T(:)], mu,sigma{i}), size(X,1),size(X,2));
%  pcolor(X,T,Z);
%  colormap jet;
%  caxis([-max(Z(:)) max(Z(:))]);
%  shading flat
%
%

pts = [ randn(numpoints,1)*std1 randn(numpoints,1)*std2 ];
pts = pts * vlt.math.rot2d(vlt.math.deg2rad(rotation));
c = cov(pts);

