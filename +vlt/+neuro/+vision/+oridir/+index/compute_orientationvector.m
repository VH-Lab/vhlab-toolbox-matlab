function vector = compute_orientationvector( angles, rates )

% vlt.neuro.vision.oridir.index.compute_orientationvector
%     VECTOR = vlt.neuro.vision.oridir.index.compute_orientationvector( ANGLES, RATES )
%
%     Takes ANGLES in degrees and returns the orientation vector:
%
%     vector = (rates*transpose(exp(sqrt(-1)*2*mod(angles*pi/180,pi))))/N
%
%     The vector is normalized by a factor of N, which is 2 if the angles
%     go all the way around the clock (that is, they sample from 0 to 360)
%     as opposed to from 0 to 180 (N = 1).
%   
%     no interpolation done

if max(angles)>180, N = 2; else, N = 1; end;
vector = (rates*transpose(exp(sqrt(-1)*2*mod(angles*pi/180,pi))))/N;
