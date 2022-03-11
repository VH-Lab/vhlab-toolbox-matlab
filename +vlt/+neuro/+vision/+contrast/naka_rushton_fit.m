function [rm,c50,n,s] = naka_rushton_fit(c, r, varargin)
%  naka_rushton Naka-Rushton fit (for contrast curves)
% 
%   [RM,C50] = vlt.neuro.vision.contrast.naka_rushton_fit(C,DATA)
% 
%   Finds the best fit to the Naka-Rushton function
%     R(c) = Rm*c/(C50+c)
%   where C is contrast (0-1), Rm is the maximum response, and C50 is the
%   half-maximum contrast.
%
%   [RM,C50,N] = vlt.neuro.vision.contrast.naka_rushton(C,DATA)
% 
%   Finds the best fit to the Naka-Rushton function
%     R(c) = Rm*c^n/(C50+c^n)
%   where C is contrast (0-1), Rm is the maximum response, and C50 is the
%   half-maximum contrast.
% 
%   [RM,C50,N,S] = vlt.neuro.vision.contrast.naka_rushton(C,DATA)
%   Finds the best fit to the Naka-Rushton function
%     R(c) = Rm*c^n/(C50^(s*n)+c^(s*n))
%   where C is contrast (0-1), Rm is the maximum response, and C50 is the
%   half-maximum contrast, and s is a saturation factor.
%   
%   References:
%     Naka_Rushton fit was first described in 
%     Naka, Rushton, J.Physiol. London 185: 536-555, 1966
%     and used to fit contrast data of cortical cells in  
%     Albrecht and Hamilton, J. Neurophys. 48: 217-237, 1982
%     The saturation form was described in Peirce 2007 J Vision
%
% This function also takes additional arguments in the form of name-value
% pairs:
% |-----------------------------------------------------------------|
% | Parameter (default)       | Description                         |
% |---------------------------|-------------------------------------|
% | init_rmax (max of r)      | Initial rmax search point           |
% | min_rmax (0)              | Minimum rmax value                  |
% | max_rmax (Inf)            | Maximum rmax value                  |
% | initc50 (contrast value   | Initial C50 search point            |
% |    with response closest  |                                     |
% |    to the empirical max/2)|                                     |
% | min_c50 (low/2)           | Minimum C50 value (low is the lowest|
% |                           |    contrast tested                  |
% | max_c50 (1)               | Maximum value of C50                |
% | init_N (1)                | Initial value for N                 |
% | min_N (0.1)               | Minimum value of N                  |
% | max_N (5)                 | Maximum value of N                  |
% | init_S (1)                | Initial value for S                 |
% | min_S (1)                 | Minumum value of S                  |
% | max_S (2.5)               | Maximum value of S                  |
% -------------------------------------------------------------------
%
% Example:
%   c = [0:0.05:1];
%   rmax_in = 10; c50_in = 0.45; N_in = 1.5; s_in = 1;
%   r = rmax_in * vlt.fit.naka_rushton_func(c,c50_in,N_in,s_in);
%   [rmax,c50,N,s] = vlt.neuro.vision.contrast.naka_rushton_fit(c,r);
%   r_fit = rmax * vlt.fit.naka_rushton_func(c,c50,N,s);
%   figure;
%   plot(c,r,'-o');
%   hold on;
%   plot(c,r_fit,'r-x');
%   xlabel('Contrast'); ylabel('Response'); box off;
%

c = c(:); % switch to columns
r = r(:); % switch to columns

init_rmax = max(r);
min_rmax = 0;
max_rmax = Inf;

rMid = ((max(r)-min(r))/2) + min(r);
[dummy,rMidIndex] = min(abs(r-rMid));
initC50 = c(rMidIndex(1));

min_c50 = min(c)/2;
max_c50 = 1;
init_N = 1;
min_N = 0.1;
max_N = 5;
init_S = 1;
min_S = 1;
max_S = 2.5;

if nargout<3,
    max_N = 1;
    min_N = 1;
end;

if nargout<4,
    min_S = 1;
    max_S = 1;
end;

vlt.data.assign(varargin{:});

% Set search parmeters
              %Rmax          c50          n   s
initParams =  [init_rmax initC50 init_N init_S];
minParams  =  [min_rmax  min_c50 min_N min_S];
maxParams  =  [max_rmax  max_c50 max_N max_S];
    
    % Set fit options 
fo = fitoptions('Method','NonlinearLeastSquares', 'Lower',minParams',...
     'Upper', maxParams, 'StartPoint',initParams, 'MaxIter',4000);
 
    % Define the fit equation
ft = fittype(@(rmax,c50,n,s,c) rmax * (c.^(n))./ (c50^(s*n)+c.^(s*n)),...
     'independent',{'c'},'coefficients',{'rmax','c50','n','s'}, 'options',fo); 
 
    % Solve for the fit (f).  Also get goodness-of-fit stats (g) 
    %    and output values about iteration information (o)
 [f, g, o]  = fit(c,r,ft,fo); 
 
 rm = f.rmax;
 c50 = f.c50;
 n = f.n;
 s = f.s;
