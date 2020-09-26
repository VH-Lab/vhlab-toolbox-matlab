function n = matlabvers
% MATLABVERS - return the Matlab version
%
% N = MATLABVERS
%
% Returns the Matlab version. This function is a shortcut for
%    A = VER('MATLAB');
%    N = A.Version;
%
% Example: 
%   n = matlabvers();
%

a = ver('matlab');
n = a.Version;
