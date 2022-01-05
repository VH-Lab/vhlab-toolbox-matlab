function fi = fitindexes(respstruct, fitterms)
% FITINDEXES - compute contrast fit index values from a response structure
%
% FI = vlt.neuro.vision.contrast.index.fitindexes(RESPSTRUCT, FITTERMS)
%
%  RESPSTRUCT is a structure  of response properties with fields:
% |------------------------------------------------------------------|
% | Field     | Description                                          |
% |------------------------------------------------------------------|
% | curve     |   4xnumber of contrasts tested,                      |
% |           |     curve(1,:) is contrasts tested                   |
% |           |     curve(2,:) is mean response at each contrast     |
% |           |     curve(3,:) is standard deviation at each contrast|
% |           |     curve(4,:) is standard error at each contrast    |
% | ind       |   cell list of individual trial responses for each   |
% |           |     contrast                                         |
% | blankresp |   1x3 vector of mean control response, mean control  |
% |           |     response standard deviation, and mean control    |
% |           |     response standard error.
% |------------------------------------------------------------------|
%
% FITTERMS is the number of terms to include in the Naka-Rushton Fit
%  (R = RM * C.^N/(C.^(N*S)+c50^.(N*S))
%
% |------------------------------------------------------------------|
% | FITTERMS  | Description                                          |
% |------------------------------------------------------------------|
% |    2      | Uses only RM and C50 (N and S are 1)                 |
% |    3      | Uses only RM, C50, and N (S is 1)                    |
% |    4      | Uses RM, C50, N, and S                               |
% |------------------------------------------------------------------|
%
% Returns a structure FI with fields:
%
% |------------------------------------------------------------------|
% | Field                  | Description                             |
% |------------------------------------------------------------------|
% | fit_parameters         | [RM C50 N S]  Naka Rushton fit params   |
% |                        |   N and S are left off if FITTERMS<3,4  |
% | fit                    | 2x101 matrix; first row is contrasts    |
% |                        |   0:0.01:1; second row is fit of        |
% |                        |   responses for those contrasts         | 
% | r2                     | Fit r^2 value                           |
% | empirical_C50          | Empirical fit contrast that gives 50% of|
% |                        |   response to 100% contrast (differs    |
% |                        |   from C50 of the fit b/c max response  |
% |                        |   is not usually at 100% contrast)      |
% | relative_max_gain      | Relative maximum gain (Heimel et al.    |
% |                        |   2005)                                 |
% | saturation_index       | Saturation index (only meaningful for   |
% |                        |   fits including S but provided always) |
% | sensitivity            | 1x10 vector of contrast sensitivity with|
% |                        |   criteria of [1 ... 10] standard       |
% |                        |   deviations of the control response.   |
% |                        |   If the standard deviation of the      |
% |                        |   control response is 0, then it is     |
% |                        |   recalculated assuming the response is |
% |                        |   1 unit on one trial.                  |
% |------------------------------------------------------------------|
%


n = 1;
s = 1;
cfit = 0:0.01:1;

stddev_control = respstruct.blankresp(2);

if stddev_control==0,
	stddev_control = std([1 zeros(1,numel(respstruct.ind{1}))]);
end;

switch fitterms,
	case 2,
		[rm,c50] = vlt.neuro.vision.contrast.naka_rushton_fit(...
			respstruct.curve(1,:),respstruct.curve(2,:));
		fit_parameters = [rm c50];
		responses_fit = rm*vlt.fit.naka_rushton_func(cfit,c50);
		responses_fit_c=rm*vlt.fit.naka_rushton_func(respstruct.curve(1,:),c50);
	case 3,
		[rm,c50,n] = vlt.neuro.vision.contrast.naka_rushton_fit(...
			respstruct.curve(1,:),respstruct.curve(2,:));
		fit_parameters = [rm c50 n];
		responses_fit = rm * vlt.fit.naka_rushton_func(cfit,c50,n);
		responses_fit_c=rm*vlt.fit.naka_rushton_func(respstruct.curve(1,:),c50,n);
	case 4,
		[rm,c50,n,s] = vlt.neuro.vision.contrast.naka_rushton_fit(...
			respstruct.curve(1,:),respstruct.curve(2,:));
		fit_parameters = [rm c50 n s];
		responses_fit = rm * vlt.fit.naka_rushton_func(cfit,c50,n,s);
		responses_fit_c=rm*vlt.fit.naka_rushton_func(respstruct.curve(1,:),c50,n,s);
	otherwise,
		error(['FITTERMS must be 2,3, or 4.']);
end;

responses_fit = responses_fit(:)'; % make sure a row vector

fit = [cfit; responses_fit];

r2 = 1- sum((responses_fit_c-respstruct.curve(2,:)).^2) / ...
	sum((respstruct.curve(2,:)-mean(respstruct.curve(2,:))).^2);

empirical_C50 = vlt.neuro.vision.contrast.indexes.contrastfit2c50(cfit,responses_fit);

relative_max_gain = vlt.neuro.vision.contrast.indexes.contrastfit2relativemaximumgain(cfit,...
	responses_fit);

saturation_index = vlt.neuro.vision.contrast.indexes.contrastfit2saturationindex(cfit,...
	responses_fit);

criterion_multipliers = [1:10];
sensitivity = 0 * criterion_multipliers;
for i=1:numel(criterion_multipliers),
	sensitivity(i) = vlt.neuro.vision.contrast.indexes.contrastfit2sensitivity(...
		fit_parameters,criterion_multipliers(i)*stddev_control);
end;


fi = vlt.data.var2struct('fit_parameters','fit','r2','empirical_C50',...
	'relative_max_gain','saturation_index','sensitivity');


