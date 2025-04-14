function [fileList, isDir] = manifest(folderPath, options) % Added isDir output
%manifest Generates a hierarchical list of files and directories.
%   [fileList, isDir] = manifest(folderPath) returns a cell array of
%   relative paths and a corresponding logical vector indicating if each
%   entry is a directory. Paths are relative to the PARENT directory of
%   folderPath.
%
%   [fileList, isDir] = manifest(folderPath, ReturnFullPath=true) returns
%   full, absolute paths and the corresponding logical isDir vector.
%
%   The list is sorted hierarchically in a depth-first manner, with
%   siblings at any level sorted alphabetically.
%
%   Input Arguments:
%       folderPath - Path to the directory to scan (string or char vector).
%                    Must be an existing folder.
%
%   Optional Name-Value Arguments:
%       ReturnFullPath - Scalar logical/numeric or empty (default: false).
%                        If true or 1, returns full absolute paths.
%                        If false, 0, or [] (default), returns paths
%                        relative to the parent of folderPath.
%
%   Output Arguments:
%       fileList   - Cell array of strings, containing relative or full paths.
%       isDir      - Logical column vector, same size as fileList. isDir(i)
%                    is true if fileList(i) represents a directory, false otherwise.
%
%   Example:
%       % Create a temporary directory structure for testing
%       baseTestDir = fullfile(pwd, 'test_manifest_base');
%       targetDir = fullfile(baseTestDir, 'target_folder');
%       if exist(baseTestDir, 'dir'), rmdir(baseTestDir, 's'); end
%       mkdir(baseTestDir); mkdir(targetDir); mkdir(fullfile(targetDir, 'subdir_a'));
%       fclose(fopen(fullfile(targetDir, 'file_f.txt'), 'w'));
%       fclose(fopen(fullfile(targetDir, 'subdir_a', 'file_b.txt'), 'w'));
%
%       % Generate relative paths and isDir flags
%       [relList, isDirFlags] = manifest(targetDir);
%       disp('Relative Manifest & isDir:');
%       disp([relList num2cell(isDirFlags)]);
%       % Expected: 'target_folder/file_f.txt' 0; 'target_folder/subdir_a' 1; 'target_folder/subdir_a/file_b.txt' 0
%
%       % Generate full paths and isDir flags
%       [fullList, isDirFlagsFull] = manifest(targetDir, ReturnFullPath=true);
%       disp('Full Path Manifest & isDir:');
%       disp([fullList num2cell(isDirFlagsFull)]);
%
%       % Clean up
%       rmdir(baseTestDir, 's');
%
%   See also: dir, fullfile, fileparts, mustBeFolder, arguments, sort, cellfun, arrayfun, startsWith, strrep, char

arguments
    folderPath {mustBeTextScalar, mustBeFolder}
    options.ReturnFullPath {mustBeScalarOrEmpty, mustBeNumericOrLogical} = false
end

% --- Initialize Outputs ---
fileList = {};
isDir = logical([]); % Initialize as empty logical column

% --- Determine desired output format ---
returnFullPathFlag = ~isempty(options.ReturnFullPath) && logical(options.ReturnFullPath(1));

% Removed disp statements as per previous request

try
    % --- Step 1: Get all items recursively ---
    searchPattern = fullfile(folderPath, '**', '*');
    allFilesStruct = dir(searchPattern);

    % --- Step 2: Filter out '.' and '..' ---
    isDot = strcmp({allFilesStruct.name}, '.') | strcmp({allFilesStruct.name}, '..');
    allFilesStruct = allFilesStruct(~isDot); % Filter the struct array

    if isempty(allFilesStruct)
        % disp('No files or subdirectories found (excluding . and ..).'); % Removed
        return; % Return empty fileList and isDir
    end

    % --- Step 3: Construct Full Paths and Extract isDir Flags ---
    fullPaths = arrayfun(@(s) fullfile(s.folder, s.name), allFilesStruct, 'UniformOutput', false);
    isDirFlagsRaw = [allFilesStruct.isdir]; % Extract logical flags
    isDirFlagsRaw = isDirFlagsRaw(:);       % Ensure column vector

    % --- Step 4: Sort Hierarchically (Depth-First using Modified Paths) ---
    if isempty(fullPaths)
         sortedFullPaths = {};
         sortedIsDirFlags = logical([]); % Keep isDir consistent
    else
         sepChar = char(1);
         if isstring(fullPaths)
            fullPaths = cellstr(fullPaths); % Ensure cell array for loop
         end
         sortablePaths = cell(size(fullPaths));
         for i = 1:numel(fullPaths)
             sortablePaths{i} = strrep(fullPaths{i}, filesep, sepChar);
         end
         [~, sortIdx] = sort(sortablePaths);

         % Apply the sort order to both paths and flags
         sortedFullPaths = fullPaths(sortIdx);
         sortedIsDirFlags = isDirFlagsRaw(sortIdx); % Apply same order to flags
    end

    % --- Step 5: Format Output Paths and Finalize isDir Vector ---
    if returnFullPathFlag
        % Return full paths and their corresponding sorted flags
        fileList = sortedFullPaths;
        isDir = sortedIsDirFlags;
    else
        % Convert sorted full paths to relative paths AND keep isDir flags aligned
        parentOfFolderPath = fileparts(folderPath);
        prefixToRemove = fullfile(parentOfFolderPath, '');
        lenPrefix = strlength(char(prefixToRemove));

        % Preallocate final outputs (maximum possible size)
        fileListRelative = cell(size(sortedFullPaths));
        isDirRelative = false(size(sortedFullPaths)); % Use logical for isDir
        count = 0;

        for i = 1:numel(sortedFullPaths)
            currentFullPath = char(sortedFullPaths{i});
            relativePath = '';

            if startsWith(currentFullPath, prefixToRemove)
                if strlength(currentFullPath) > lenPrefix
                   relativePath = currentFullPath(lenPrefix + 1 : end);
                   if ~isempty(relativePath) && startsWith(relativePath, filesep)
                       relativePath = relativePath(2:end);
                   end
                else
                   continue; % Skip if path is identical to prefix
                end

                % If a valid relative path was generated, store it and its flag
                if ~isempty(relativePath)
                    count = count + 1;
                    fileListRelative{count} = relativePath;
                    isDirRelative(count) = sortedIsDirFlags(i); % Store corresponding flag
                end
            else
                 warning('Path "%s" did not start with expected parent prefix "%s". Skipping.', currentFullPath, prefixToRemove);
                 continue;
            end
        end % end for loop

        % Trim the final outputs to the actual count
        fileList = fileListRelative(1:count);
        isDir = isDirRelative(1:count);
        isDir = isDir(:); % Ensure column vector output for isDir

    end % end if returnFullPathFlag

catch ME
    warning('An error occurred while creating the manifest for "%s":\n%s', ...
            char(folderPath), ME.message);
    % Optionally clear outputs on error
    % fileList = {};
    % isDir = logical([]);
    rethrow(ME);
end

end % function manifest