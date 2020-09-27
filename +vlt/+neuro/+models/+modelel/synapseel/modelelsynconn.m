function model = modelelsynconn(model, inds, W, protosyn)
% MODELELSYNCONN - Make synaptic connections among modelel elements
%
%   MODEL = vlt.neuroscience.models.modelel.synapseel.modelelsynconn(MODEL, INDS, W, PROTOSYN)
%
%   PROTOSYN can be a prototpe synapse or the number of a modelel element
%   in MODEL that should serve as a prototype synapse.
%
%   INDS is the subset of the modelel elements to operate on for connecting.
%   For example, if the neurons in your model are 1 2 3, you might set 
%   INDS to [1 2 3]. (This way you don't have to specify weights of connections
%   between elements that are not numbered 1 2 3).
%  
%   W(i,j) should be the weight of the synaptic connection from element
%   INDS(i) to element INDS(j). If 2 elements are not to be connected,
%   then NaN should be passed as the weight.

verbose = 0;

for i=1:size(W,1),
	for j=1:size(W,2),
		if ~isnan(W(i,j)),
			% create a synapse from ind(i) to ind(j)
			if verbose,
				disp(['Making synapse from ' ...
					int2str(inds(i)) ' to ' ...
					int2str(inds(j)) '.']);
			end;
			model(end+1) = protosyn;
			model(end).model.pre = inds(i);
			model(end).model.post = inds(j);
			model(end).model.Gmax = W(i,j);
			synapse_list = model(inds(j)).model.synapse_list;
			synapse_list(end+1) = length(model);
			model(inds(j)).model.synapse_list = synapse_list;
		end;
	end;
end;

