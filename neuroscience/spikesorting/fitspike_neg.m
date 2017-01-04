function [params, fitshape] = fitspike_neg(spikewaveform, center_range, negwidth, poswidth, postoffset, offset)

% this function is under development, not good

 % step 1: fit negative-going peak

f = fittype('gauss1');
fo = fitoptions(f);

f = fittype('a1*exp( ((x-b1).^2)./(2*c1^2))+a2*exp( ((x-(b1+n+b2)).^2)./(2*c2^2))','problem',n);

[m,min_index] = min(spikewaveform);

fo.Lower = [ m min(center_range) min(negwidth) ];
fo.Upper = [ 0 max(center_range) max(negwidth) ];
fo.StartPoint = [ min(spikewaveform)-mean(offset) min_index mean(negwidth) ];

f = setoptions(f,fo);

[c,gof] = fit([1:length(spikewaveform)]', spikewaveform(:), f);

keyboard;

fitwave = c([1:length(spikewaveform)]');
subspikewaveform = spikewaveform(:) - fitwave; % subtract this part

 % step 2: fit the positive-going after potential

f2 = fittype('gauss1');
fo2 = fitoptions(f);

[mx,max_index] = max(subspikewaveform(round(c.b1):end));
max_index = max_index + round(c.b1)-1;

fo2.Lower = [0 c.c1+postoffset min(poswidth) ];
fo2.Upper = [max(spikewaveform) max(center_range)+c.b1+postoffset max(poswidth)];

f2 = setoptions(f2,fo2);

[c2,gof2] = fit([1:length(spikewaveform)]', subspikewaveform(:), f2);

params = cat(2,coeffvalues(c),coeffvalues(c2));

fitshape = c(1:length(spikewaveform)) + c2(1:length(spikewaveform));
