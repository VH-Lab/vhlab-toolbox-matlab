function [hh,outputs]=polarplot_dir(angles, responses, varargin)
% POLARPLOT_DIR - Produces a polar plot of direction responses
%
%  [H,OUTPUTS]=vlt.neuro.vision.oridir.plot.polarplot_dir(ANGLES, RESPONSES, ...)
%
%  Produces a polar plot (using the third party library MMPOLAR)
%  of direction responses in direction space. The plot handle is
%  returned in H.  ANGLES should be direction angles in degrees,
%  and RESPONSES are the responses in appropriate units. 
%
%  OUTPUTS is a structure with the following fields:
%  'meanvector'              :  mean direction vector in the complex plane
%  'vectormag'               :  mean direction vector magnitude
%  'vectorpref'              :  vector direction preference in degrees
%  'dircircularvariance'     :  direction circular variance
%  'h_meanvector'            :  plot handle to the mean vector
%  'h_circularvariance'      :  plot handle to the dir circular variance vector
%
%  Additional name/value pairs can be provided as additional arguments:
%  'showmeanvector'          : 0/1 show mean direction vector (default 0)
%  'showdircircularvariance' : 0/1 show dir circular variance vector (default 0)
%                            :    (plots vector with length equal to 1-dircircular
%                            :     variance and angle equal to vector direction 
%                            :     preference)
%  'style'                   : 'compass' or 'cartesian', default 'compass'
%
%  See also: vlt.neuro.vision.oridir.dirspace2orispace, MMPOLAR, vlt.neuro.vision.oridir.plot.polarplot_ori
%

showmeanvector = 0;
showdircircularvariance = 0;
style = 'compass';

vlt.data.assign(varargin{:});

hh=mmpolar(vlt.math.deg2rad(angles([1:end 1])),responses([1:end 1]),...  % connects the last point to the first
	'k-o', ...
	'style',style,...
	'TTickDelta',45,'RGridLineWidth',1,'TGridLineWidth',1,'RGridLineStyle','-',...
	'RGridLineWidth',1,'RGridColor',0.67*[1 1 1],'TTickColor',0.67*[1 1 1],'TGridLineStyle','-',...
	'fontname','arial','border','off','fontsize',16);

outputs.meanvector = sum(responses(:).*exp(sqrt(-1)*mod(vlt.math.deg2rad(angles(:)),2*pi)));
outputs.vectormag = abs(outputs.meanvector);
%outputs.vectorpref = vlt.math.cartesian2compass(vlt.math.rad2deg(mod(angle(outputs.meanvector),2*pi)),0); no, the plotting function mmpolar will plot it properly
outputs.vectorpref = vlt.math.rad2deg(mod(angle(outputs.meanvector),2*pi));
outputs.dircircularvariance = vlt.neurovision.oridir.index.compute_dircircularvariance(angles(:)',responses(:)');
[outputs.dvco_di,outputs.dvco_pref,outputs.dvco_vec] = vlt.neurovision.oridir.index.compute_dirvecconstrainedori(angles(:)',responses(:)');
outputs.h_meanvector = [];
outputs.h_circularvariance = [];

if showmeanvector,
	hold on;
	outputs.h_meanvector = mmpolar(vlt.math.deg2rad(outputs.vectorpref)*[1 1], [0 outputs.vectormag],...
		'b-^', ...
		'style', style);
end;

if showdircircularvariance,
	hold on;
	outputs.h_circularvariance= mmpolar(vlt.math.deg2rad(outputs.vectorpref)*[1 1], [0 1-outputs.dircircularvariance],...
		'g-s', ...
		'style', style);
end;

ticklabels = mmpolar('TTickLabel');
newticklabels = {};
for i=1:length(ticklabels),
	goodvalues =  sort(find( (ticklabels{i}>=double('0')&ticklabels{i}<=double('9')) | ticklabels{i}=='-'));
	ticklabels{i} = ticklabels{i}(goodvalues);
	newticklabels{i} = [num2str(mod( str2num(ticklabels{i}),360)) '\circ'];
end;
mmpolar('TTickLabel',newticklabels');

