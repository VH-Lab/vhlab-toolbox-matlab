classdef testind2subD < matlab.unittest.TestCase
    % testind2subD - tests for vlt.data.ind2subD
    %
    %

    properties
    end

    methods (Test)

        function test_ind2subD_simple(testCase)
            % a simple 2-d test
            sz = [10 11];
            indexes = 1:prod(sz);

            [I,J] = ind2sub(sz,indexes);

            I_vlt = vlt.data.ind2subD(sz,indexes,1);
            J_vlt = vlt.data.ind2subD(sz,indexes,2);

            testCase.verifyEqual(uint64(I(:)),I_vlt(:));
            testCase.verifyEqual(uint64(J(:)),J_vlt(:));
        end

        function test_ind2subD_3d(testCase)
            % a simple 3-d test
            sz = [5 6 7];
            indexes = 1:prod(sz);

            [I,J,K] = ind2sub(sz,indexes);

            I_vlt = vlt.data.ind2subD(sz,indexes,1);
            J_vlt = vlt.data.ind2subD(sz,indexes,2);
            K_vlt = vlt.data.ind2subD(sz,indexes,3);

            testCase.verifyEqual(uint64(I(:)),I_vlt(:));
            testCase.verifyEqual(uint64(J(:)),J_vlt(:));
            testCase.verifyEqual(uint64(K(:)),K_vlt(:));
        end

        function test_ind2subD_invalid_dim(testCase)
            % test invalid dimension
            sz = [5 6 7];
            indexes = 1;

            testCase.verifyError(@() vlt.data.ind2subD(sz, indexes, 4), '');
            testCase.verifyError(@() vlt.data.ind2subD(sz, indexes, 0), '');
        end

    end
end
