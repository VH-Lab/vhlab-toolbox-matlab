classdef test_probOfSuper < matlab.unittest.TestCase
    methods (Test)
        function testBasicSuperiority(testCase)
            % B > A completely
            A = [1; 2; 3];
            B = [4; 5; 6];
            p = vlt.stats.probOfSuper(A, B);
            testCase.verifyEqual(p, 1, 'AbsTol', 1e-10);

            % A > B completely (B inferior)
            p = vlt.stats.probOfSuper(B, A);
            testCase.verifyEqual(p, 0, 'AbsTol', 1e-10);
        end

        function testEquality(testCase)
            % A and B identical
            A = [1; 2; 3];
            B = [1; 2; 3];
            p = vlt.stats.probOfSuper(A, B);
            testCase.verifyEqual(p, 0.5, 'AbsTol', 1e-10);
        end

        function testMixed(testCase)
            % A = [1], B = [0, 2]
            % Pairs: (1,0) -> B<A; (1,2) -> B>A.
            % B>A count = 1. Total = 2. P = 0.5.
            A = [1];
            B = [0; 2];
            p = vlt.stats.probOfSuper(A, B);
            testCase.verifyEqual(p, 0.5, 'AbsTol', 1e-10);

            % A = [1, 3], B = [2]
            % Pairs: (1,2) -> B>A; (3,2) -> B<A.
            % P = 0.5.
            A = [1; 3];
            B = [2];
            p = vlt.stats.probOfSuper(A, B);
            testCase.verifyEqual(p, 0.5, 'AbsTol', 1e-10);

            % A = [1], B = [2, 3]
            % Pairs: (1,2), (1,3) -> Both B>A. P=1.
            A = [1];
            B = [2; 3];
            p = vlt.stats.probOfSuper(A, B);
            testCase.verifyEqual(p, 1, 'AbsTol', 1e-10);
        end

        function testTies(testCase)
            % A = [1], B = [1]
            % P = 0.5
            A = [1];
            B = [1];
            p = vlt.stats.probOfSuper(A, B);
            testCase.verifyEqual(p, 0.5, 'AbsTol', 1e-10);

            % A = [1], B = [1, 2]
            % Pairs: (1,1) -> 0.5; (1,2) -> 1.
            % P = (0.5 + 1) / 2 = 0.75.
            A = [1];
            B = [1; 2];
            p = vlt.stats.probOfSuper(A, B);
            testCase.verifyEqual(p, 0.75, 'AbsTol', 1e-10);
        end

        function testNaNs(testCase)
            A = [1; NaN];
            B = [2];
            % Should result in A=[1], B=[2]. P=1.
            p = vlt.stats.probOfSuper(A, B);
            testCase.verifyEqual(p, 1, 'AbsTol', 1e-10);

            A = [1];
            B = [2; NaN];
            p = vlt.stats.probOfSuper(A, B);
            testCase.verifyEqual(p, 1, 'AbsTol', 1e-10);

            A = [NaN];
            B = [1];
            % A empty after NaN removal -> NaN
            p = vlt.stats.probOfSuper(A, B);
            testCase.verifyTrue(isnan(p));
        end

        function testEmpty(testCase)
            A = [];
            B = [1];
            p = vlt.stats.probOfSuper(A, B);
            testCase.verifyTrue(isnan(p));

            A = [1];
            B = [];
            p = vlt.stats.probOfSuper(A, B);
            testCase.verifyTrue(isnan(p));
        end

        function testInputShapes(testCase)
            % Row vectors
            A = [1, 2, 3];
            B = [4, 5, 6];
            p = vlt.stats.probOfSuper(A, B);
            testCase.verifyEqual(p, 1, 'AbsTol', 1e-10);
        end
    end
end
