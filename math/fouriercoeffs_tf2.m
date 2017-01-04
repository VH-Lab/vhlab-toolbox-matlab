function f = fouriercoeffs_tf(response, tf, SAMPLERATE)
% FOURIERCOEFFS_TF  Fourier Transform at a particular frequency.
%%	ft(response, tf, SAMPLERATE) is the product of response with
%	exp( 2*pi*i*tf/SAMPLERATE ). If tf is zero it returns the mean.
%%	If response is two-dimensional, ft operates on the columns and
%	returns a row vector.
%%	tf is expressed in whatever units SAMPLERATE is expressed in 
%	(I usually use Hz). 
%%	From Sooyoung Chung, from Matteo Carandini,modified slightly by
%   Steve Van Hooser

nsamples = size(response,1);
duration = nsamples/SAMPLERATE;

if tf == 0
	f = mean(response);
else
	correctnsamples=floor( SAMPLERATE * floor(duration * tf)/tf );
	if correctnsamples == 0, error('Correctnsamples is zero'); end
	expvec=exp(-(1:length(response))*2*pi*sqrt(-1)*tf/SAMPLERATE );
	f=(2/length(response)) * expvec * response(1:length(response),:);
end
