# vlt.math.dog2dogf

```
  vlt.math.dog2dogf - convert difference of gaussian parameters to difference of gaussian Fourier transform parameters
 
  P_DOGF = vlt.math.dog2dogf(P_DOG)
 
  Given parameters for a difference of gaussians function: P_DOG = [ a1 b1 a2 b2], where
  vlt.math.dog(X,P_DOG) = [ a1*exp(-X.^2/(2*b1^2) - a2*exp(-X.^2/(2*b2^2)) ], 
  this function computes the parameters for calculating the curve in frequency space (in cycles / unit x).
  
  The Fourier transform of vlt.math.dog(X,P_DOG) is 
  sqrt(2*pi)*[a1*b1*exp(-0.5*b1^2*(2*pi)^2*f^2)-a1*b2*exp(-0.5*b2^2*(2*pi)^2*f^2)]
 
  This function is itself a difference of gaussian function. Therefore, to express these values in 
  terms of the original P_DOG, the parameters are converted to be
  P_DOGF = [sqrt(2*pi)*a1*b1 1/(2*pi*b1) sqrt(2*pi)*a2*b2 1/(2*pi*b2)]
 
  Through the miracle of math, this function is also it's own inverse:
  p_dog = vlt.math.dog2dofg(vlt.math.dog2dogf(p_dog))
 
  See also: vlt.math.dog
 
  Example:
    x = -50:0.1:50; % space, in degrees of visual angle
    p_dog = [ 1 5 0.5 10]
    y = vlt.math.dog(x,p_dog);
    figure;
    subplot(2,2,1); 
    plot(x,y); xlabel('Space (degrees)'); ylabel('Response (sp/s)'); box off;
    subplot(2,2,2);
    % plot the actual Fourier transform
    [Y,f] = vlt.math.fouriercoeffs(y(:),x(2)-x(1));
    plot(f,abs(Y),'bx-'); xlabel('Frequency (cycles/deg)'); ylabel('Abs response (sp/s)'); box off;
    set(gca,'xlim',[0 0.25]);
    % plot the calculated version
    p_dogf = vlt.math.dog2dogf(p_dog);
    Y2 = vlt.math.dog(f,p_dogf); % convert from radial frequency to cycles
    Y2 = [Y2(1) 2*Y2(2:end)] /(x(end)-x(1)); % convert to same units as fourier_coeffs 
    hold on;
    plot(f,Y2,'go-');

```
