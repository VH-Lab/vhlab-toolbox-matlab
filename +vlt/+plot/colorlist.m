function c = colorlist(N, varargin)
% COLORLIST - Grab a color or group of colors from a list
%
%   C = vlt.plot.colorlist
%
%      Returns an Nx3 list of colors. By default, this function
%  returns the normal 7 colors that Matlab uses as the default
%  ColorOrder for new axes.
%  
%     or
%
%   C = vlt.plot.colorlist(N)
% 
%      Returns a 1x3 color chosen from the color list. The Nth
%  entry is chosen. If N is greater than the number of colors in the
%  list, the selection 'wraps around' back to the beginning of the list.    
%
% This function also takes name/value pairs that extend its
% functionality:
% Parameter (default)    | Description 
% ------------------------------------------------------
% ColorList (7x3 default | The color list to choose from
%              axes      |    Examples: jet(256), gray(256)
%             ColorOrder)|
% DoNotWrap (0)          | Directs the function not to wrap the
%                        |    selection around the list if N
%                        |    is greater than the number of colors.
%                        |    Instead, an error will occur.
%

 % default parameters

ColorList = [         0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];
DoNotWrap = 0;

vlt.data.assign(varargin{:});  % add any user-specified parameters

if nargin==0,
	c = ColorList;
else,
	m = 1+mod(N-1,size(ColorList,1));
	c = ColorList(m,:);
end;

