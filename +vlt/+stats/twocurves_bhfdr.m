function [adjusted_p, raw_p] = twocurves_bhfdr(curve1_examples, curve2_examples)
% TWOCURVES_BHFDR - compare significance between 2 curves using the Benjamini-Hochberg false discovery rejection
%
% [ADJUSTED_P, RAW_P] = vlt.stats.twocurves_bhfdr(CURVE1_EXAMPLES, CURVE2_EXAMPLES)
%
% Given two data sets (CURVEN_EXAMPLES, which trace out a curve with each curve observation in a column vector),
% this function calculates RAW_P, the raw, uncorrected p value of a TTEST2 between the curves, and the adjusted
% p value ADJUSTED_P using the Behmamini-Hochberg (1995) procedure by calling MAFDR.
%
%

raw_p = [];
adjusted_p = [];

for i=1:size(curve1_examples,1), % for each row, calculate p value
	[h,raw_p(i)] = ttest2(curve1_examples(i,:),curve2_examples(i,:));
end;

[adjusted_p] = mafdr(raw_p,'BHFDR',true);
