function out = showmypwd(filename, filename2)
% SHOWMYPWD - show the file tree at the present working directory
%
% OUT = SHOWMYPWD()
%
% Plot a graph of the file tree relative to the present working directory.
% The graph is plotted in the current axes.
%

is_initial_call = 0;

if nargin==0,
	filename = pwd;
	is_initial_call = 1;
end;

[parentdir, thename, ext] = fileparts(filename);

if is_initial_call,
	nodenames = {filename};
    nodelabels = {filename};
else,
	nodenames = {filename};%{[thename ext]};
    nodelabels = {[thename ext]};
end;

G = sparse([0]);

d = dir(filename);

for i=1:numel(d),
	if ~ (strcmp(d(i).name,'.') | strcmp(d(i).name,'..')),
		nodenames{end+1} = [filename filesep d(i).name];
        nodelabels{end+1} = d(i).name;
		G(numel(nodenames),1) = 0;
		G(1,numel(nodenames)) = 1;
		if d(i).isdir,
			out_here = showmypwd(fullfile(filename,d(i).name), filename);
			% now, insert the node names
            if numel(out_here.nodenames)>1,
    			nodenames = cat(2,nodenames,out_here.nodenames(2:end));
                nodelabels = cat(2,nodelabels,out_here.nodelabels(2:end));
                Gnew1 = [ G [zeros(size(G,1)-1,size(out_here.G,1)-1); out_here.G(1,2:end)] ];
                Gnew2 = [ zeros(size(out_here.G,1)-1,size(G,2) ) out_here.G(2:end,2:end)];
                G = [Gnew1; Gnew2];
            end;
		end;
	end;
end;

out.G = G;
out.nodenames = nodenames;
out.nodelabels = nodelabels;

if is_initial_call,
	dG = digraph(out.G,out.nodenames);
	h = plot(dG,'Layout','layered');
    labelnode(h,1:numel(out.nodenames),out.nodelabels);

end;


