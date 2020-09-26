function vlt_build


dirname = ['/Users/vanhoosr/Documents/matlab/tools/vhlab-toolbox-matlab'];

m=vlt.matlab.mfiledirinfo(dirname);

rt = vlt.matlab.packagenamereplacementtable(m,'/Users/vanhoosr/Documents/matlab/tools/vhlab-toolbox-matlab','vlt');

search_replace = { ...
	'.datastructures.' '.data.' ...
	'.matlab_graphics.' '.matlab.graphics.' ...
	'.fits', '.fit', ...
	'.plotting.','.plot.' ...
	'.user_interface.' '.ui.' ...
	'.paths.','.path',
};

for i=1:numel(rt),
	for j=1:2:numel(search_replace),
		rt(i).replacement = strrep(rt(i).replacement,search_replace{j},search_replace{j+1});
	end;
end;

fuse = vlt.matlab.findfunctionusedir('/Users/vanhoosr/Documents/MATLAB/tools/vhlab-toolbox-matlab/+vlt/',m);

status = vlt.matlab.replacefunction(fuse,rt);

keyboard;
