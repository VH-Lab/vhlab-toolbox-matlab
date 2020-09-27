function [Y, FX, FY, R, FR] = fouriercoeffs_2d(X, pixelsize)
% FOURIERCOEFFS_2D - calculate Fourier coeffients for 2-d fourier analysis
%
% [Y, FX, FY, R, FR] = vlt.math.fouriercoeffs_2d(X, PIXELSIZE)
%
% Given a 2-dimensional signal X (such as an image) and the pixel size in meters (PIXELSIZE), then
% the following are computed:
% 
%  Y = shifted discrete 2d fourier transform of X (shifted with fftshift)
%      These coefficients are normalized so that a*exp(-sqrt(-1)*2*pi*n/T)) has coefficient of a
%      This differs from the default normalization (none) of the discrete 2d fourier transform
%  FX - the frequencies examined in the first dimension (shifted)
%  FY - the frequencies examined in the second dimension (shifted)
%  R - the Fourier cofficients at fixed radii
%  FR - the Fourier frequencies at fixed radii
%
%  A progress bar is shown during radial averaging.
%
%  Example:
%     % a grating
%     X_1 = 0:0.001:1; % 1 mm steps to 1 meter
%     X_2 = 0:0.001:1; % 1 mm steps to 1 meter
%     f1 = 3; % 3 cycles per meter
%     f2 = 10; % 10 cycles per meter
%     f3 = 5; % 5 cycles per meter
%     [X1,X2] = meshgrid(X_1,X_2);
%     X = 1 + 0.5 * sin(2*pi*f1*X1);
%     vlt.plot.imagedisplay(X);
% 
%     X_ = 1+ 0.5 * sin(2*pi*f2*X2+2*pi*f3*X1) + X;
%     vlt.plot.imagedisplay(X_);
%     [Y,FX,FY,R,FR] = vlt.math.fouriercoeffs_2d(X,0.001);
%     [Y_,FX_,FY_,R_,FR_] = vlt.math.fouriercoeffs_2d(X_,0.001);
%     figure; 
%     plot(FR,abs(R),'mo'); % average spatial frequency tuning across all directions
%     hold on; 
%     plot(FR_,abs(R_),'bo');  % average spatial frequency tuning across all directions
%     xlabel('Spatial frequency (cycles/unit)');
%     ylabel('Magnitude');
%     

[M, N, ~] = size(X);

freqs_y = (0:size(X,1)-1)/(pixelsize*(size(X,1)-1));
freqs_x = (0:size(X,2)-1)/(pixelsize*(size(X,2)-1));

[FX,FY] = meshgrid(freqs_x,freqs_y);

FX = fftshift(FX);
FY = fftshift(FY);
Y_ = 2 * fft2(X) / (M*N); % use factor of 2 to normalize so coefficient of a * sin(2*pi*t+t0) is a rather than a/2
Y_(1,1) = Y_(1,1)/2;      % but don't do this for the DC component
Y = fftshift(Y_);

R2 = FX.^2 + FY.^2;

[u_sorted, sorted_indexes] = sort(R2(:));
u = unique(u_sorted);

u_sorted(end+1) = Inf;
sorted_indexes(end+1) = NaN;

R = zeros(1,numel(u));
FR = zeros(1,numel(u));

progressbar('Performing radial averaging...');

	% there's GOT to be a faster way of doing this; maybe try using bwlabel

search_start = 1;

for i=1:numel(u),
	if 0, % this is NOT faster
		end_local = find(u_sorted(search_start:end) > u(i), 1, 'first');
		end_run = search_start-1 + end_local;
		inds = sorted_indexes(search_start:end_run);
		search_start = end_run+1;
	else,
		inds = find(R2(:)==u(i));
	end;
	FR(i) = sqrt(u(i));
	R(i) = mean(Y(inds));
	if mod(i,1000)==0,
		progressbar(i/numel(u));
	end;
end;

progressbar(1);


