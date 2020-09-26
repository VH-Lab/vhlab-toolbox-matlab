function D = createdirkernel(x, t, spFreq, spPhase, Tf, dir, space_gauss, time_de, ABSNORM)

% CREATEDIRKERNEL - Create a model direction-selective kernel
%
%  D = CREATEDIRKERNEL(X, T, SPFREQ, SPHASE, TF, DIR, SPACE_GAUSS, TIME_DE, ABSNORM)
%
%  Creates a model direction-selective kernel
%
%       X should be a vector indicating the spatial positions to create, in degrees
%          (example: 0:0.1:10 creates 100 positions in increments of 0.1 degrees)
%       T should be the time values of the kernel to create (kernel is assumed to
%          be constant in each bin)
%          (example: 0:0.001:0.5 is 0.5 seconds in 0.001s steps)
%       SPFREQ is the spatial frequency preference of the kernel (say 0.1 cycles per degree)
%       SPPHASE is the spatial phase pref of the grating (between 0 and 2*pi)
%       TF is the temporal frequency of drifting (in Hz)
%       DIR is the slant direction (1 is left, -1 is right, 0 for no slant)
%       SPACE_GAUSS is a 2 element vector for gaussian envelope [mean and variance]
%       TIME_DE is a 3 element vector describing a double exponential function
%           TIME_DE = [ onset tau1 tau2], where G>0 only for T>offset, and
%           then G=((tau1*tau2)/(tau1-tau2))*(exp(-t/tau1) - exp(-t/tau2))
%           (rougly speaking, tau1 is the onset time constant, tau2 is offset)
%       ABSNORM -- if this parameter is not empty ([]) then the kernel will be
%       normalized so the optimal stimulus will produce a response of ABSNORM.
%
%  

[X,T] = meshgrid(x,t);

D = sin(-dir*2*pi*Tf.*T+spPhase+2*pi*spFreq.*X);

if nargin>6,
	if ~isempty(space_gauss),
		% apply space gaussian
		D = D.*exp(-((X-space_gauss(1)).^2)./space_gauss(2));
	end;
end;

if nargin>7,
    	% apply time double exponential
	if ~isempty(time_de),
		D = D.*(double(T>=time_de(1)).*double_exp(T-time_de(1),time_de(2),time_de(3)));  
	end;
end;

if nargin>8,
	full_contrast_D = D/max(D(:));
	D = D * (ABSNORM/((t(2)-t(1))*(x(2)-x(1))*sum(D(:).*full_contrast_D(:))));
end;

