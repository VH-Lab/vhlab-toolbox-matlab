function [offset, double_gauss_params, dog_params, R_fit, rsquare] = double_gauss_DoG_fit(theta, sf, R)
% double_gauss_Dog_fit - Fits a double gaussian modulated by a difference of gaussians to data
%
%  [OFFSET, DOUBLE_GAUSS_PARAMS, DOG_PARAMS, RFIT, RSQUARE] = DOUBLE_GAUSS_DOG_FIT(THETA, SF, R)
%
%  (description of inputs/outputs here by Andrea)  
%

% gauss = fittype('double_gauss_DoG(theta_, sf_, [a b c d e], [0 a2 b2 c2 d2])',...
   % 'independent',{'theta_','sf_'},'coefficients',{'a','b','c','d','e','a2','b2','c2','d2'});
% fo = fitoptions(gauss);

gauss = fittype('double_gauss_DoG(theta_, sf_, a, [0 b c d e], [0 1 b2 c2 d2])',...
    'independent',{'theta_','sf_'},'coefficients',{'a','b','c','d','e','b2','c2','d2'});
fo = fitoptions(gauss);

[peak,loc] = max(R(:));

peak_theta = theta(loc);
peak_sf = sf(loc);

%fo.StartPoint = [mean(R(:)); peak; peak_theta; 25 ; peak; ...
  %  1; peak_sf; 0.5 ; 10*peak_sf],

fo.StartPoint = [0; peak; peak_theta; 25 ; peak; ...
     peak_sf; 0.5 ; peak_sf/10];

fo.Lower = [-abs(peak); 0;      0;    min(diff(unique(theta)))/2;  0;         0.01;  0;  0.01 ];
fo.Upper = [ abs(peak); 2*abs(peak); 4*pi; 180;                         2*abs(peak);    0.50;  1;  0.1  ];

gauss = setoptions(gauss,fo);
[values,values_gof] = fit([theta(:) sf(:)],R(:),gauss);

%double_gauss_params = [values.a values.b values.c values.d values.e];
%dog_params = [0 values.a2 values.b2 values.c2 values.d2];

offset = values.a;
double_gauss_params = [0 values.b values.c values.d values.e];
dog_params = [0 1 values.b2 values.c2 values.d2];

R_fit = double_gauss_DoG(theta,sf,offset,double_gauss_params,dog_params);

rsquare = values_gof.rsquare;
