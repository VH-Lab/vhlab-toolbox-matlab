function [indexes] = neighborindexes(imsize, index, conn)
% NEIGHBORINDEXES - identify pixel index values that border a pixel
%
% INDEXES = NEIGHBORINDEXES(IMSIZE, INDEX, [CONN])
%
% Returns the index values of all pixels that neighbor a pixel specified
% by the index value INDEX in an image of size IMSIZE. CONN is the connectivity
% to be used.
%
% If CONN is not specified and if IMSIZE is 2-dimensional, then CONN is
% 8, indicating all horizontal, vertical, and oblique neighbors.
%
% If CONN is not specified and if IMSIZE is 3-dimensional, then CONN is
% 26, indicating all horizontal, vertical, above, below, and all obliques are
% considered neighbors.
%
% Currently, other modes for CONN are not supported (but feel free to add
% any of these and send a pull request).
%
% Note that INDEXES may have fewer elements than 26 or 8 if the pixel
% described by INDEX is on a border.
%
% Example:
%    A = zeros(6,6,3)
%    I = neighborindexes(size(A),sub2ind(size(A),3,3,2))
%    A(sub2ind(size(A),3,3,2)) = 2;
%    A(I) = 1  % 1s are neighbors, 2 is seed
%
% Example 2:
%    A = zeros(6,6,3)
%    I = neighborindexes(size(A),sub2ind(size(A),3,1,2))
%    A(sub2ind(size(A),3,1,2)) = 2;
%    A(I) = 1  % 1s are neighbors, 2 is seed
%
% Example 3:
%    A = zeros(5,5)
%    I = neighborindexes(size(A),sub2ind(size(A),2,1))
%    A(sub2ind(size(A),2,1)) = 2;
%    A(I) = 1  % 1s are neighbors, 2 is seed
%    
%

indexes = [];
dim = numel(imsize);

if dim~=2 & dim~=3,
	error(['Right now IMSIZE must be 2- or 3-dimensional.']);
end;

if nargin<3,
	if dim==3,
		conn = 26;
	else,
		conn = 8;
	end;
end;

if dim==3,
	if conn~=26,
		error(['I only know 26-connectivity right now.']);
	end;

	if conn==26,
		[I,J,K] = ind2sub(imsize,index);
		for i = max(I-1,1):min(I+1,imsize(1)),
			for j = max(J-1,1):min(J+1,imsize(2)),
				for k = max(K-1,1):min(K+1,imsize(3)),
					if ~((i==I)&(j==J)&(k==K)),
						indexes(end+1) = sub2ind(imsize,i,j,k);
					end;
				end;
			end;
		end;
	end;
else, % it is 2

	if conn~=8,
		error(['I only know 8-connectivity right now.']);
	end;

	if conn==8,
		[I,J] = ind2sub(imsize,index);
		for i = max(I-1,1):min(I+1,imsize(1)),
			for j = max(J-1,1):min(J+1,imsize(2)),
				if ~((i==I)&(j==J)),
					indexes(end+1) = sub2ind(imsize,i,j);
				end;
			end;
		end;
	end;
end;

