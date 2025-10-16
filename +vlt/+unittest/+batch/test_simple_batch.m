function tests = test_simple_batch
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    % Create a temporary directory for test files
    testCase.TestData.tempDir = tempname;
    mkdir(testCase.TestData.tempDir);

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
    fclose(fid);

    % Create a mock vlt.time.dowait that will throw an error to break the loop
    mockPath = fullfile(testCase.TestData.tempDir, '+vlt', '+time');
    mkdir(mockPath);
    addpath(testCase.TestData.tempDir); % Add parent of +vlt to path

    fid = fopen(fullfile(mockPath, 'dowait.m'), 'wt');
    fprintf(fid, 'function dowait(t)\n    error("TEST:LoopBreak", "Loop broken by mock dowait.");\nend\n');
    fclose(fid);
end

function teardownOnce(testCase)
    % Restore the original path
    path(testCase.TestData.originalPath);
    % Clean up the temporary directory
    rmdir(testCase.TestData.tempDir, 's');
end

function test_job_execution(testCase)
    % Run the batch function and expect it to be interrupted by our mock dowait
    try
        vlt.batch.simple_batch(testCase.TestData.batchFile);
        % If it reaches here, the loop wasn't broken, which is a failure
        testCase.verifyFail('The infinite loop in simple_batch was not terminated as expected.');
    catch ME
        % Verify that we caught the specific error we threw from the mock function
        testCase.verifyEqual(ME.identifier, 'TEST:LoopBreak', 'The process was terminated by an unexpected error.');
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