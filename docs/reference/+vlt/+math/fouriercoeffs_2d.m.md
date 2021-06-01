# vlt.math.fouriercoeffs_2d

  FOURIERCOEFFS_2D - calculate Fourier coeffients for 2-d fourier analysis
 
  [Y, FX, FY, R, FR] = vlt.math.fouriercoeffs_2d(X, PIXELSIZE)
 
  Given a 2-dimensional signal X (such as an image) and the pixel size in meters (PIXELSIZE), then
  the following are computed:
  
   Y = shifted discrete 2d fourier transform of X (shifted with fftshift)
       These coefficients are normalized so that a*exp(-sqrt(-1)*2*pi*n/T)) has coefficient of a
       This differs from the default normalization (none) of the discrete 2d fourier transform
   FX - the frequencies examined in the first dimension (shifted)
   FY - the frequencies examined in the second dimension (shifted)
   R - the Fourier cofficients at fixed radii
   FR - the Fourier frequencies at fixed radii
 
   A progress bar is shown during radial averaging.
 
   Example:
      % a grating
      X_1 = 0:0.001:1; % 1 mm steps to 1 meter
      X_2 = 0:0.001:1; % 1 mm steps to 1 meter
      f1 = 3; % 3 cycles per meter
      f2 = 10; % 10 cycles per meter
      f3 = 5; % 5 cycles per meter
      [X1,X2] = meshgrid(X_1,X_2);
      X = 1 + 0.5 * sin(2*pi*f1*X1);
      vlt.plot.imagedisplay(X);
  
      X_ = 1+ 0.5 * sin(2*pi*f2*X2+2*pi*f3*X1) + X;
      vlt.plot.imagedisplay(X_);
      [Y,FX,FY,R,FR] = vlt.math.fouriercoeffs_2d(X,0.001);
      [Y_,FX_,FY_,R_,FR_] = vlt.math.fouriercoeffs_2d(X_,0.001);
      figure; 
      plot(FR,abs(R),'mo'); % average spatial frequency tuning across all directions
      hold on; 
      plot(FR_,abs(R_),'bo');  % average spatial frequency tuning across all directions
      xlabel('Spatial frequency (cycles/unit)');
      ylabel('Magnitude');
