function geometric_identities_tests
% GEOMETRIC_IDENTITIES_TESTS  - Tests some mathematical geometric identities
% 
%   Displays several geometric identities and tests their validity for several random 
%   samples. (Of course, not a proof, but a check of some of our proofs).
%
%




disp('Now testing: sum(n*z^(n)); n goes from 1 to N-1');
disp('N=10, z is 10 random numbers')

Z = randn(10,1);
N = 10;
n = 1:(N-1);

answers = [];

for zi = 1:length(Z),
	z = Z(zi);
	answers(zi,1) = sum(n.*z.^n);
	answers(zi,2) = z*(1-z^(N-1))/((1-z)^2) - (N-1)*(z^N)/(1-z);
end;

disp(['Performance matrix: (z, actual sum, identity equation, difference)']);
 
disp([Z answers diff(answers,[],2)]);

disp('High resolution view of differences:');
disp(diff(answers,[],2))



disp('Now testing autocorrelation of pulse with width 2N samples');

Z = randn(10,1);
N = 10;
n = 1:(N-1);
alpha = 1;

answers = [];

for zi = 1:length(Z),
	z = Z(zi);
	answers(zi,1) = (alpha/N)*(N+sum((N-n).*(z.^n+z.^(-n))));
	answers(zi,1) = (alpha/N)*(N+sum((N-n).*(z.^n+z.^(-n))));

	answers(zi,2) = (alpha/N)*(N+N*( ...
		(z*(1-z^(N-1)))/(1-z)+ z^(-1)*((1-z^(-(N-1)))/(1-z^(-1)))) - ...
			( (z*(1-z^(N-1))/(1-z)^2) - (N-1)*z^N/(1-z)) - ...
			(z^(-1)*(1-z^(-(N-1)))/(1-z^(-1))^2 - (N-1)*z^(-N)/(1-z^(-1))) ...
		);

	answers(zi,2) = ((alpha)/(N)) * z^(1-N) * (-1+z^N)^2 / (z-1)^2;
end;


disp(['Performance matrix: (z, actual sum, identity equation, difference)']);
 
disp([Z answers diff(answers,[],2)]);

disp('High resolution view of differences:');
disp(diff(answers,[],2))
