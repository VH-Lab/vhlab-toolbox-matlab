function [merged_graph, indexes, numnewnodes] = mergegraph(G1, G2, nodenumbers2_1)
% MERGEGRAPH - merge adjacency matrixes of 2 graphs
%
% [MERGED_GRAPH, INDEXES, NUMNEWNODES] = MERGEGRAPH(G1, G2, NODENUMBERS2_1)
%
% Creates a merged graph from two overlapping adjacency matrixes
% G1 and G2. G#(i,j) is the weight of the connection from node
% i to j for each graph. NODENUMBERS2_1 are the node index values
% of the nodes of G2 in G1. If any entries of NODENUMBERS2_1 are
% greater than the number of nodes of G1, then they are assumed to
% be nodes that are not present in G1, but they will be added in the
% new graph.
%
% INDEXES is a structure array of the entries that make up the new
% panels of the merged adjacency matrix MERGED_GRAPH. The fields
% 'upper_right', 'lower_left', and 'lower_right' have the index values
% of G2 that are taken to fill out the graph. For 'lower_right', the
% matrix is square and full, and the index values are the locations in
% G2. For 'lower_left' and 'upper_right', the matrixes may be sparse
% if there are nodes in G1 that are not in G2. So the index values
% have two fields: 'merged' (the index values of the panel in the merged
% matrix) and 'G2' (the corresponding index values in G2). 
% 
%
% Note that in performing this merge, the connections among the nodes of
% G1 are NOT modified. So this function is not a means of providing additional
% information about the connectivity of those nodes.
%
% See also: DIGRAPH
%
% Example: 
%            G1 = [ 1 1 1 ; 0 1 0; 0 0 1 ]; 
%            G2 = [ 1 1 ; 0 1 ];
%            nodenumbers2_1 = [ 1 4 ];
%            [G3,indexes,numnewnodes] = mergegraph(G1,G2,nodenumbers2_1);
%            lower_right = G2(indexes.lower_right);
%            lower_left = zeros(numnewnodes,size(G1,1));
%            upper_right = zeros(size(G1,1),numnewnodes);
%            lower_left(indexes.lower_left.merged) = G2(indexes.lower_left.G2);
%            upper_right(indexes.upper_right.merged) = G2(indexes.upper_right.G2);
%            G4 = [ G1 upper_right; lower_left lower_right ];
%            G3==G4 % it does
%

n1 = size(G1,1);
n2 = size(G2,1);

newnodes_index = find(nodenumbers2_1>n1);
oldnodes_index = find(nodenumbers2_1<=n1);

if isempty(newnodes_index)
	error(['At least one of the nodes of G2 must be not present in G1.']);
end;

newnodes = nodenumbers2_1(newnodes_index);
oldnodes = nodenumbers2_1(oldnodes_index);

numnewnodes = numel(newnodes);

if ~eqlen(sort(newnodes-n1),1:numnewnodes),
	error(['New nodes must be in increasing numerical order with no gaps in index values from the existing nodes.']);
end

 % what are the connections from newnodes to the existing nodes?

lower_right = G2([newnodes_index],[newnodes_index]);
indexes.lower_right = sub2ind(size(G2),[newnodes_index],[newnodes_index]);

lower_left = zeros(numel(newnodes),n1);
lower_left( (newnodes-n1),oldnodes ) = G2( [newnodes_index], [oldnodes_index] );

indexes.lower_left.G2 = [];
if ~isempty(oldnodes),
	indexes.lower_left.merged = sub2ind(size(lower_left),(newnodes-n1),oldnodes);
	indexes.lower_left.G2 =     sub2ind(size(G2),[newnodes_index], [oldnodes_index] );
end;

upper_right = zeros(n1,numel(newnodes));
upper_right( oldnodes, (newnodes-n1)) = G2( [oldnodes_index], [newnodes_index] );

indexes.upper_right.G2 = [];

if ~isempty(oldnodes),
	indexes.upper_right.merged = sub2ind(size(lower_left),(newnodes-n1),oldnodes);
	indexes.upper_right.G2 =     sub2ind(size(G2),[newnodes_index], [oldnodes_index] );
end

merged_graph = [G1 upper_right ; lower_left lower_right];

