# vlt.math.fouriercoeffs_tf

```
  FOURIERCOEFFS_TF  Fourier Transform at a particular frequency.
 	ft(response, tf, SAMPLERATE) is the product of response with
 	exp( 2*pi*i*tf/SAMPLERATE ). If tf is zero it returns the mean.
 	If response is two-dimensional, ft operates on the columns and
 	returns a row vector.
 	tf is expressed in whatever units SAMPLERATE is expressed in 
 	(I usually use Hz). Only the data within an integer number of periods 
 	are considered.
 	From Sooyoung Chung, from Matteo Carandini,modified slightly by
    Steve Van Hooser

```
