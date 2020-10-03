function [nodes,g] = dependency_graph(dependency_struct)
% DEPENDENCY_GRAPH - create a directed graph that describes dependencies among strings
%
% [NODES,G] = vlt.graph.dependency_graph(DEPENDENCY_STRUCT)
%
% Given a DEPENDENCY_STRUCT with fields 'name' (indicating the string name) and a structure named
% 'dependencies' that has field names with other named strings, this function returns a set of nodes
%  NODES with node names and a directed graph G indicating the dependencies.
%

nodes = {dependency_struct.name};

for i=1:numel(dependency_struct),
	fn = fieldnames(dependency_struct(i).dependencies);
	nodes = cat(2,nodes,fn);
end;

nodes = unique(nodes);

G = inf(nodes);

for i=1:numel(dependency_struct),
	node_spot_a = find(strcmp(dependency_struct(i).name,nodes));
	fn = fieldnames(dependency_struct(i).dependencies);
	for j=1:numel(fn),
		node_spot_b = find(strcmp(fn{j},nodes));
		G(node_a,node_b) = 1;
	end
end

