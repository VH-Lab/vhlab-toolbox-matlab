function di = compute_dirvecdotorivec( angles, rates )
% COMPUTE_DIRVECDOTORIVEC - Direction index based on dot product with computed orientation vector
%
%     DI = vlt.neuro.vision.oridir.index.compute_dirvecdotorivec( ANGLES, RATES )
%
%     Takes ANGLES in degrees, and RATES is the response to each angle
%     in a row vector.
%
%     DI is a modified vector index; the function first finds the empirical
%     orientation vector and then computes dot product of direction vector with 
%     unit orentation vector
%

ot_vec = rates*transpose(exp(sqrt(-1)*2*mod(angles*pi/180,pi)));

 % this is the unit orientation vector
ot_vec = exp(sqrt(-1)*angle(ot_vec)/2);

dir_vec = rates/sum(abs(rates))*transpose(exp(sqrt(-1)*mod(angles*pi/180,2*pi)));

di = sqrt(abs([real(ot_vec) imag(ot_vec)] * [real(dir_vec) imag(dir_vec)]'));

