function vi = oridir_vectorindexes(respstruct)
% ORIDIR_VECTORINDEX - compute orientation/direction vector indexes
%
% VI = vlt.neuro.vision.oridir.index.oridir_vectorindexes(RESPSTRUCT)
%
% Computes orientation/direction index vector values from a response structure RESP.
%
%  RESPSTRUCT is a structure  of response properties with fields:
%  Field    | Description
%  -----------------------------------------------------------------------------
%  curve    |    4xnumber of directions tested,
%           |      curve(1,:) is directions tested (degrees, compass coords.)
%           |      curve(2,:) is mean responses
%           |      curve(3,:) is standard deviation
%           |      curve(4,:) is standard error
%  ind      |    cell list of individual trial responses for each direction
%
%
% Returns a structure VI with fields:
% Field                           | Description
% ----------------------------------------------------------------------------------------
% ot_HotellingT2_p                |   Hotelling's T^2 test of orientation vector data
% ot_pref                         |   Angle preference in orientation space
% ot_circularvariance             |   Magnitude of response in orientation space (see Ringach et al. 2002)
% ot_index                        |   Orientation index ( (pref-orth)/pref) )
% tuning_width                    |   Vector tuning width (see help vlt.neuro.vision.oridir.index.compute_tuningwidth)
% dir_HotellingT2_p               |   Hotelling's T^2 test of direction vector data
% dir_pref                        |   Angle preference in direction space
% dir_circularvariance            |   Direction index in vector space
% dir_dotproduct_sig_p            |   P value of dot product direction vector significance
%                                 |     method of Mazurek et al. 2014


vi = [];

% fill with nans
vi.ot_HotellingT2_p = nan;
vi.ot_pref = nan;
vi.ot_circularvariance = nan;
vi.ot_index = nan;
vi.tuning_width = nan;
vi.dir_HotellingT2_p = nan;
vi.dir_pref = nan;
vi.dir_circularvariance = nan;
vi.dir_dotproduct_sig_p = nan;

hasdirection = 0;

maxresp = [];
fdtpref = [];
circularvariance = [];
tuningwidth = [];

resp = respstruct.curve;

angles = resp(1,:);

[maxresp,if0]=max(resp(2,:));
otpref = [resp(1,if0)];

if max(angles)<=180,
	tuneangles = [angles angles+180];
	tuneresps = [resp(2,:) resp(2,:)];
	tuneerr = [resp(4,:) resp(4,:)];
else,
	hasdirection = 1;
	tuneangles = angles;
	tuneresps = resp(2,:);
	tuneerr = resp(4,:);
end;

smallest_n = Inf;

for i=1:numel(respstruct.ind),
	smallest_n = min(smallest_n, numel(find(~isnan(respstruct.ind{i}))));
end;

allresps = [];

for i=1:numel(respstruct.ind),
	indshere = find(~isnan(respstruct.ind{i}));
	allresps(:,i) = vlt.data.colvec(respstruct.ind{i}(indshere(1:smallest_n)));
end;

if size(allresps,1)>0,

	% in orientation space
	vecresp_ot = (allresps*transpose(exp(sqrt(-1)*2*mod(angles*pi/180,pi))));
	[h2,vi.ot_HotellingT2_p]=vlt.stats.hotellingt2test([real(vecresp_ot) imag(vecresp_ot)],[0 0]);
	vi.ot_pref = mod(180/pi*angle(mean(vecresp_ot)),180);
	%vecotmag = abs(mean(vecresp));

	if hasdirection,
		% in direction space
		vecdirresp = (allresps*transpose(exp(sqrt(-1)*mod(angles*pi/180,2*pi))));
		[h3,vi.dir_HotellingT2_p]=vlt.stats.hotellingt2test([real(vecdirresp) imag(vecdirresp)],[0 0]);
		vi.dir_pref = mod(180/pi*angle(mean(vecdirresp)),360);
		%vecdirmag = abs(mean(vecdirresp));
		%vecdirind = abs(mean(vecdirresp))/maxresp;
		vi.dir_dotproduct_sig_p = vlt.neuro.vision.oridir.index.compute_directionsignificancedotproduct(angles,allresps);
	end;
end;

vi.ot_circularvariance = vlt.neuro.vision.oridir.index.compute_circularvariance(tuneangles,tuneresps);
vi_ot_index = vlt.neuro.vision.oridir.index.compute_orientationindex(tuneangles,tuneresps);
vi.tuning_width = vlt.neuro.vision.oridir.index.compute_tuningwidth(tuneangles,tuneresps);

if hasdirection,
	vi.dir_circularvariance = vlt.neuro.vision.oridir.index.compute_dircircularvariance(tuneangles,tuneresps);
	vi.dir_index = vlt.neuro.vision.oridir.index.compute_directionindex(angles,resp(2,:));
end;


