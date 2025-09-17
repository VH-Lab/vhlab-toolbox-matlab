function test_hashmatlabvariable()
% TEST_HASHMATLABVARIABLE - Test for vlt.data.hashmatlabvariable
%
    % Test case 1: MD5 hash
    A = randn(5,3,2);
    h1 = vlt.data.hashmatlabvariable(A);
    h2 = vlt.data.hashmatlabvariable(A);
    assert(strcmp(h1, h2), 'MD5 hashes should be the same for the same data');

    B = randn(5,3,2);
    h3 = vlt.data.hashmatlabvariable(B);
    assert(~strcmp(h1, h3), 'MD5 hashes should be different for different data');

    % Test case 2: pm_hash/crc (if available)
    if exist('pm_hash') == 2,
        h1_crc = vlt.data.hashmatlabvariable(A, 'algorithm', 'pm_hash/crc');
        h2_crc = vlt.data.hashmatlabvariable(A, 'algorithm', 'pm_hash/crc');
        assert(h1_crc == h2_crc, 'CRC hashes should be the same for the same data');

        h3_crc = vlt.data.hashmatlabvariable(B, 'algorithm', 'pm_hash/crc');
        assert(h1_crc ~= h3_crc, 'CRC hashes should be different for different data');
    else
        warning('pm_hash not found, skipping CRC hash test.');
    end

    disp('All tests for vlt.data.hashmatlabvariable passed.');
end
