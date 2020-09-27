function syn_nums = modelelgetsyn(modelel, prelist, postlist)
% MODELELGETSYN - Return element number of synapses among particular neurons
%
%  SYN_NUMS = vlt.neuroscience.models.modelel.synapseel.modelelgetsyn(MODELEL, PRELIST, POSTLIST)
%
%  Return the model elements that correspond to synapses between elements
%  PRELIST and POSTLIST.  SYN_NUMS(i) will be the synapse between 
%  PRELIST(i) and POSTLIST(i), if they are both present and have a synapse.
%  Otherwise, the SYN_NUMS(i) will be NaN;

syn_nums = nan(size(prelist));

for i=1:length(modelel),
	% look at all synapses
	if isfield(modelel(i).model,'pre') & isfield(modelel(i).model,'post'),
		% okay, weve established it is a synapse
		% is it one we are looking for?
		z1 = find( (modelel(i).model.pre==prelist)&...
			(modelel(i).model.post == postlist));
		if ~isempty(z1),
			if ~isnan(syn_nums(z1)),
				error(['found more than 1 synapse from ' ...
					int2str(prelist(z1)) ' to ' ...
					int2str(postlist(z1)) '.']);
			end;
			syn_nums(z1) = i;
		end;
	end;
end;

