function folderPath = toolboxdir()
% TOOLBOXDIR Returns the root directory of the vlt toolbox
%
% FOLDERPATH = vlt.toolboxdir()
%
% Returns the absolute path to the root directory of the vlt toolbox.
% This function is useful for locating resources within the toolbox
% structure regardless of the current working directory.
%
% Outputs:
%   FOLDERPATH - A string containing the absolute path to the root
%                directory of the vlt toolbox
%
% Example:
%   root_dir = vlt.toolboxdir();
%   disp(['vlt toolbox is installed at: ' root_dir]);
%
% See also:
%   FILEPARTS, MFILENAME
%

    folderPath = fileparts(fileparts(mfilename('fullpath')));
end