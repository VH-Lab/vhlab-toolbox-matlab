function [Xm,Ym,Zm,Im] = vector2mesh(x,y,z,varargin)
% vlt.math.vector2mesh - convert a mesh grid from a vector representation back to a mesh set of matrixes
%
% [Xm,Ym,Zm,Im] = vlt.math.vector2mesh(X,Y,Z,...)
%
% Builds a mesh representation of two coordinate vectors X and Y. Xm and Ym will be
% matrixes that are NxM, where N is the number of elements in X and M is the number of
% elements in Y. The value of Z(i) for a given X(i) and Y(i) will be placed in at Z(j,k)
% where j is the jth entry of the unique values of X, and k is the kth entry of the unique
% values of Y.  The index value i will be placed at position j, k.
%
% This function takes name/value pairs that modify its functionality.
% |---------------------------------|-----------------------------------------------|
% | tolerance (0)                   | How much tolerance should be given for values |
% |                                 |   of x or y to be considered equal?           |
% |---------------------------------|-----------------------------------------------|
%
% Example:
%   [Xm_,Ym_] = meshgrid([0:0.1:1],[0:0.2:1]);
%   Zm_ = sin(2*pi*Xm_) + cos(2*pi*Ym_);
%   x = Xm_(:); % convert to vectors
%   y = Ym_(:); % convert to vectors
%   z = Zm_(:); % convert to vectors
%
%   [Xm,Ym,Zm,Im] = vlt.math.vector2mesh(x,y,z); % convert back
% 
%   Xm_ == Xm  % they are equal
%   Ym_ == Ym  % they are equal
%   Zm_ == Zm  % they are equal
%   Im 
%   figure; surf(Xm_,Ym_,Zm_)
%   figure; surf(Xm,Ym,Zm)
% 

tolerance = 0;

vlt.data.assign(varargin{:});

if tolerance==0,
	xu = unique(x);
	yu = unique(y);
else,
	xu = uniquetol(x,tolerance);
	yu = uniquetol(y,tolerance);
end;

Xm = NaN(numel(yu),numel(xu));
Ym = NaN(numel(yu),numel(xu));
Zm = NaN(numel(yu),numel(xu));
Im = NaN(numel(yu),numel(xu));

for i=1:numel(xu),
	for j=1:numel(yu),
		if tolerance==0,
			index = find(x==xu(i) & y==yu(j));
		else,
			index = find(abs(x-xu(i))<tolerance  & abs(y-yu(j))<tolerance);
		end;
		if numel(index)>1,
			error(['More than one value of x=' num2str(xu(i)) ' and y=' num2str(yu(j)) '.']);
		elseif numel(index)==1, 
			Im(j,i) = index;
			Xm(j,i) = xu(i);
			Ym(j,i) = yu(j);
			Zm(j,i) = z(index);
		else, % if 0, nothing to do; point is already labeled as NaN on initialization
		end;

	end;
end;


