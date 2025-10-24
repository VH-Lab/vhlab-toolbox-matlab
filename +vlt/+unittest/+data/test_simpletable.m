classdef test_simpletable < matlab.unittest.TestCase
    methods (Test)
        function test_simpletable_basic(testCase)
            oldcategories = [ 0:pi/2:2*pi ];
            oldsimpletable = [ 1:5 ];
            X2 = [ 0:pi/4:2*pi];
            Y2 = [ 1:0.5:5 ] + 5;
            [newtable,newcats] = vlt.data.simpletable(oldsimpletable,oldcategories,Y2,X2);

            expected_cats = [0, pi/4, pi/2, 3*pi/4, pi, 5*pi/4, 3*pi/2, 7*pi/4, 2*pi];

            expected_table = [ ...
                1.0000,    NaN,   2.0000,      NaN,   3.0000,      NaN,   4.0000,      NaN,   5.0000; ...
                6.0000, 6.5000,   7.0000,   7.5000,   8.0000,   8.5000,   9.0000,   9.5000,  10.0000 ...
                ];

            testCase.verifyEqual(newcats, expected_cats, 'AbsTol', 1e-10);
            testCase.verifyEqual(newtable, expected_table, 'AbsTol', 1e-10);
        end

        function test_simpletable_no_new_categories(testCase)
            oldcategories = [1 2 3];
            oldsimpletable = [10 20 30];
            X2 = [1 3];
            Y2 = [100 300];
            [newtable,newcats] = vlt.data.simpletable(oldsimpletable,oldcategories,Y2,X2);

            expected_cats = [1 2 3];
            expected_table = [ 10 20 30; 100 NaN 300];

            testCase.verifyEqual(newcats, expected_cats);
            testCase.verifyEqual(newtable, expected_table);
        end

        function test_simpletable_empty_old(testCase)
            oldcategories = [];
            oldsimpletable = [];
            X2 = [1 2 3];
            Y2 = [10 20 30];
            [newtable,newcats] = vlt.data.simpletable(oldsimpletable,oldcategories,Y2,X2);

            expected_cats = [1 2 3];
            expected_table = [10 20 30];

            testCase.verifyEqual(newcats, expected_cats);
            testCase.verifyEqual(newtable, expected_table);
        end
    end
end
