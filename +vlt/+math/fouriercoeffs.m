function [fc, freqs] = fouriercoeffs(data,si)

%  vlt.math.fouriercoeffs - find Fourier coefficients for data
%
%  Uses FFT to compute the Fourier coefficients for a vector of data.
%
%  [FC,FREQS]=vlt.math.fouriercoeffs(DATA,SI)
%
%  where DATA is a vector of data and SI is the sampling interval (in seconds),
%  returns FC the Fourier coefficients and FREQS, the frequency of
%  each coefficient.
%
%  The Fourier coefficients are defined [1] to be:
%    B0   = (1/T) * sum(data)   (returned in FC(1))
%    Bn   = (2/T) * integral(0,T,data.*cos(2*pi*n/T))  (returned in real(FC(n+1)))
%    An   = (2/T) * integral(0,T,data.*sin(2*pi*n/T))  (returned in imag(FC(n+1)))
%
%  Each entry of FC is the sum of Bn+An*sqrt(-1) so that
%  Bn = real(FC(n+1)) and An = imag(FC(n+1))
%
%  Note that these Fourier cofficients are normalized differently than those returned
%  by the Matlab function FFT.
%
%  [1]: _Waves_, Berkeley Physics Course Volume 3, Crawford, 1968
% 
%  See also:  FFT

fc = fft(data);

fc(1) = fc(1)/(length(data));
fc(2:end) = (2/(length(data)))*(real(fc(2:end))-sqrt(-1)*imag(fc(2:end)));
freqs = (0:length(data)-1)/(si*(length(data)-1));


