function [hh,outputs]=polarplot_ori(angles, responses, varargin)
% POLARPLOT_ORI - Produces a polar plot of orientation responses
%
%  [H,OUTPUTS]=vlt.neuro.vision.oridir.plot.polarplot_ori(ANGLES, RESPONSES, ...)
%
%  Produces a polar plot (using the third party library MMPOLAR)
%  of orientation responses in orientation space. The plot handle is
%  returned in H.  ANGLES should be orientation angles in degrees,
%  and RESPONSES are the responses in appropriate units. 
%
%  OUTPUTS is a structure with the following fields:
%     'meanvector'        :  mean orientation vector in the complex plane
%     'vectormag'         :  mean vector magnitude
%     'vectorpref'        :  vector preference in degrees
%     'circularvariance'  :  circular variance
%     'h_meanvector'      :  plot handle to the mean vector
%     'h_circularvariance':  plot handle to the circular variance vector
%
%  Additional name/value pairs can be provided as additional arguments:
%  'showmeanvector'          : 0/1 show mean orientation vector (default 0)
%  'showcircularvariance'    : 0/1 show circular variance vector (default 0)
%                            :    (plots vector with length equal to 1-circular
%                            :     variance and angle equal to orientation
%                            :     preference)
%  'style'                   : 'compass' or 'cartesian', default 'compass'
%
%  See also: vlt.neuro.vision.oridir.dirspace2orispace, MMPOLAR, vlt.neuro.vision.oridir.plot.polarplot_dir
%

showmeanvector = 0;
showcircularvariance = 0;
style = 'compass';

vlt.data.assign(varargin{:});

hh=mmpolar(2*vlt.math.deg2rad(angles([1:end 1])),responses([1:end 1]),...  % connects the last point to the first
	'k-o', ...
	'style',style,...
	'TTickDelta',45,'RGridLineWidth',1,'TGridLineWidth',1,'RGridLineStyle','-',...
	'RGridLineWidth',1,'RGridColor',0.67*[1 1 1],'TTickColor',0.67*[1 1 1],'TGridLineStyle','-',...
	'fontname','arial','border','off','fontsize',16);

outputs.meanvector = sum(responses(:).*exp(sqrt(-1)*2*mod(vlt.math.deg2rad(angles(:)),pi)));
outputs.vectormag = abs(outputs.meanvector);
outputs.vectorpref = vlt.math.rad2deg(mod(angle(outputs.meanvector)/2,pi));
outputs.circularvariance = vlt.neurovision.oridir.index.compute_circularvariance(angles(:)',responses(:)');
outputs.h_meanvector = [];
outputs.h_circularvariance = [];

if showmeanvector,
	hold on;
	outputs.h_meanvector = mmpolar(2*vlt.math.deg2rad(outputs.vectorpref)*[1 1], [0 outputs.vectormag],...
		'b-^', ...
		'style', style);
end;

if showcircularvariance,
	hold on;
	outputs.h_circularvariance= mmpolar(2*vlt.math.deg2rad(outputs.vectorpref)*[1 1], [0 1-outputs.circularvariance],...
		'g-s', ...
		'style', style);
end;

ticklabels = mmpolar('TTickLabel');
newticklabels = {};
for i=1:length(ticklabels),
	goodvalues =  sort(find( (ticklabels{i}>=double('0')&ticklabels{i}<=double('9')) | ticklabels{i}=='-'));
	ticklabels{i} = ticklabels{i}(goodvalues);
	newticklabels{i} = [num2str(mod( str2num(ticklabels{i}),360)/2) '\circ'];
end;
mmpolar('TTickLabel',newticklabels');
