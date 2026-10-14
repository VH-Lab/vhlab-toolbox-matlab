function tests = test_simple_batch
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    % Create a temporary directory for test files
    testCase.TestData.tempDir = tempname;
    mkdir(testCase.TestData.tempDir);

    % simple_batch changes directory, so store the starting folder
    testCase.TestData.originalDir = pwd;

    % Store the original path
    testCase.TestData.originalPath = path;

    % Create a dummy batch file
    testCase.TestData.batchFile = fullfile(testCase.TestData.tempDir, 'batch.txt');

    % Job details
    testCase.TestData.jobClaimFile = fullfile(testCase.TestData.tempDir, 'job.claim');
    testCase.TestData.saveFile = fullfile(testCase.TestData.tempDir, 'output.mat');
    testCase.TestData.errorFile = fullfile(testCase.TestData.tempDir, 'error.mat');

    % Write the batch file
    fid = fopen(testCase.TestData.batchFile, 'wt');
    fprintf(fid, 'jobclaimfile\tpathtorun\tcommandtorun\tsavefile\terrorsave\n');
    fprintf(fid, '%s\t%s\t%s\t%s\t%s\n', ...
        testCase.TestData.jobClaimFile, ...
        testCase.TestData.tempDir, ...
        'a=1;b=2;c=a+b;', ...
        testCase.TestData.saveFile, ...
        testCase.TestData.errorFile);
    % A second job whose directory does not exist. simple_batch errors when it
    % cannot cd there, which ends its infinite loop right after the first job
    % runs, without waiting in vlt.time.dowait and without shadowing any function.
    testCase.TestData.missingDir = fullfile(testCase.TestData.tempDir, 'doesNotExist');
    fprintf(fid, '%s\t%s\t%s\t%s\t%s\n', ...
        fullfile(testCase.TestData.tempDir, 'job2.claim'), ...
        testCase.TestData.missingDir, ...
        'a=1;b=2;c=a+b;', ...
        fullfile(testCase.TestData.tempDir, 'output2.mat'), ...
        fullfile(testCase.TestData.tempDir, 'error2.mat'));
    fclose(fid);
end

function teardownOnce(testCase)
    % Restore the original folder and path
    cd(testCase.TestData.originalDir);
    path(testCase.TestData.originalPath);
    % Clean up the temporary directory
    rmdir(testCase.TestData.tempDir, 's');
end

function test_job_execution(testCase)
    % Run the batch function and expect it to stop at the second job's missing directory
    try
        vlt.batch.simple_batch(testCase.TestData.batchFile);
        % If it reaches here, the loop wasn't broken, which is a failure
        testCase.verifyFail('The infinite loop in simple_batch was not terminated as expected.');
    catch ME
        % Verify that the loop ended on the second job's missing directory
        testCase.verifySubstring(ME.message, ['Could not change to directory ' testCase.TestData.missingDir], ...
            'The process was terminated by an unexpected error.');
    end

    % Now, verify the results of the job execution

    % Verify that the output file was created
    testCase.verifyTrue(exist(testCase.TestData.saveFile, 'file') == 2, 'Output file was not created.');

    % Load the output file and check the variables
    vars = load(testCase.TestData.saveFile);
    testCase.verifyEqual(vars.c, 3, 'Incorrect result in the output file.');

    % Verify that the job claim file was created
    testCase.verifyTrue(exist(testCase.TestData.jobClaimFile, 'file') == 2, 'Job claim file was not created.');

    % Verify that the error file was NOT created
    testCase.verifyFalse(exist(testCase.TestData.errorFile, 'file') == 2, 'Error file was created unexpectedly.');
end