function p = compute_directionsignificancedotproduct(angles, rates)
% COMPUTE_DIRECTIONSIGNIFICANCEDOTPRODUCT Direction tuning significance using dot product with empirical orientation preference
%
%
%  P = COMPUTE_DIRECTIONSIGNIFIANCEDOTPRODUCT(ANGLES, RATES)
%
%  This function calculates the probability that the "true" direction tuning
%  vector of a neuron has non-zero length. It performs this by empirically
%  determing the unit orientation vector, and then computing the dot
%  product of the direction vector for each trial onto the overall orientation
%  vector, and then looking to see if the average is non-zero.
%
%  Inputs:  ANGLES is a vector of direction angles at which the response has
%           been measured. 
%           RATES is the response of the neuron in to each angle; each row
%           should contain responses from a different trial.
%  Output:  P the probability that the "true" direction tuning vector is
%           non-zero.
%
%  See: Mazurek, Kagan, Van Hooser 2014;  Frontiers in Neural Circuits
%
 
angles = angles(:)'; % make sure we are in columns 

avg_rates = mean(rates,1);

 % Step 1: Find the unit orientation vector in direction space

ot_vec = avg_rates*transpose(exp(sqrt(-1)*2*mod(angles*pi/180,pi)));

 % now this is the unit orientation vector in direction space
ot_vec = exp(sqrt(-1)*angle(ot_vec)/2);

 % Step 2: compute the direction vectors for each trial

dir_vec = rates*transpose(exp(sqrt(-1)*mod(angles*pi/180,2*pi)));

 % Step 3: now compute the trial by trial dot products (really the square of the dot product)

dot_prods = ([real(dir_vec) imag(dir_vec)] * [real(ot_vec) imag(ot_vec)]');

 % now compute p value

[h,p] = ttest(dot_prods);
