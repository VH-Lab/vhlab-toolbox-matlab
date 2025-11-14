classdef findfilegroupsTest < matlab.unittest.TestCase

    properties
        testDir
    end

    methods(TestMethodSetup)
        function createTestDir(testCase)
            testCase.testDir = tempname;
            mkdir(testCase.testDir);

            % Test case 1: simple wildcard matching
            mkdir(fullfile(testCase.testDir, 'test1'));
            fclose(fopen(fullfile(testCase.testDir, 'test1', 'a.ext'), 'w'));
            fclose(fopen(fullfile(testCase.testDir, 'test1', 'b.ext'), 'w'));
            mkdir(fullfile(testCase.testDir, 'test1', 'sub'));
            fclose(fopen(fullfile(testCase.testDir, 'test1', 'sub', 'c.ext'), 'w'));

            % Test case 2: co-occurring files
            mkdir(fullfile(testCase.testDir, 'test2'));
            fclose(fopen(fullfile(testCase.testDir, 'test2', 'myfile.ext1'), 'w'));
            fclose(fopen(fullfile(testCase.testDir, 'test2', 'myfile.ext2'), 'w'));
            mkdir(fullfile(testCase.testDir, 'test2', 'sub'));
            fclose(fopen(fullfile(testCase.testDir, 'test2', 'sub', 'another.ext1'), 'w')); % no pair

            % Test case 3: common substring
            mkdir(fullfile(testCase.testDir, 'test3'));
            fclose(fopen(fullfile(testCase.testDir, 'test3', 'myfile_A.ext1'), 'w'));
            fclose(fopen(fullfile(testCase.testDir, 'test3', 'myfile_A.ext2'), 'w'));
            fclose(fopen(fullfile(testCase.testDir, 'test3', 'myfile_B.ext1'), 'w')); % no pair
            mkdir(fullfile(testCase.testDir, 'test3', 'sub'));
            fclose(fopen(fullfile(testCase.testDir, 'test3', 'sub', 'myfile_C.ext1'), 'w'));
            fclose(fopen(fullfile(testCase.testDir, 'test3', 'sub', 'myfile_C.ext2'), 'w'));
        end
    end

    methods(TestMethodTeardown)
        function removeTestDir(testCase)
            if exist(testCase.testDir,'dir')
                rmdir(testCase.testDir,'s');
            end
        end
    end

    methods(Test)

        function test_wildcard_search(testCase)
            fileparameters = {'.*\.ext$'};
            filelist = vlt.file.findfilegroups(fullfile(testCase.testDir, 'test1'), fileparameters);
            testCase.verifyEqual(numel(filelist), 3);

            expected_files = { ...
                fullfile(testCase.testDir, 'test1', 'a.ext'), ...
                fullfile(testCase.testDir, 'test1', 'b.ext'), ...
                fullfile(testCase.testDir, 'test1', 'sub', 'c.ext') ...
            };

            % Flatten filelist for comparison
            found_files = cellfun(@(x) x{1}, filelist, 'UniformOutput', false);
            testCase.verifyEqual(sort(found_files), sort(expected_files));
        end

        function test_cooccurring_files(testCase)
            fileparameters = {'myfile.ext1', 'myfile.ext2'};
            filelist = vlt.file.findfilegroups(fullfile(testCase.testDir, 'test2'), fileparameters);
            testCase.verifyEqual(numel(filelist), 1);

            expected_group = { ...
                fullfile(testCase.testDir, 'test2', 'myfile.ext1'), ...
                fullfile(testCase.testDir, 'test2', 'myfile.ext2') ...
            };
            testCase.verifyEqual(sort(filelist{1}), sort(expected_group));
        end

        function test_common_substring(testCase)
            fileparameters = {'myfile_#\.ext1', 'myfile_#\.ext2'};
            filelist = vlt.file.findfilegroups(fullfile(testCase.testDir, 'test3'), fileparameters);
            testCase.verifyEqual(numel(filelist), 2);

            expected_group1 = { ...
                fullfile(testCase.testDir, 'test3', 'myfile_A.ext1'), ...
                fullfile(testCase.testDir, 'test3', 'myfile_A.ext2') ...
            };
            expected_group2 = { ...
                fullfile(testCase.testDir, 'test3', 'sub', 'myfile_C.ext1'), ...
                fullfile(testCase.testDir, 'test3', 'sub', 'myfile_C.ext2') ...
            };

            % The order of groups is not guaranteed
            found_groups = {sort(filelist{1}), sort(filelist{2})};
            expected_groups = {sort(expected_group1), sort(expected_group2)};

            testCase.verifyTrue( ...
                (isequal(found_groups{1}, expected_groups{1}) && isequal(found_groups{2}, expected_groups{2})) || ...
                (isequal(found_groups{1}, expected_groups{2}) && isequal(found_groups{2}, expected_groups{1})) ...
            );
        end

        function test_search_depth(testCase)
            fileparameters = {'.*\.ext$'};
            filelist = vlt.file.findfilegroups(fullfile(testCase.testDir, 'test1'), fileparameters, 'SearchDepth', 0);
            testCase.verifyEqual(numel(filelist), 2); % Should not find file in 'sub'
        end

    end
end
