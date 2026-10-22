classdef test_lme_factorial_power < matlab.unittest.TestCase
    % TEST_LME_FACTORIAL_POWER - tests for vlt.stats.power.lme_factorial_power

    properties
        Tbl
    end

    methods (TestMethodSetup)
        function makeData(testCase)
            % 2 x 2 design: Condition between animals, Treatment within animals,
            % neurons nested in animals
            rng(2);
            rows = {};
            animal = 0;
            conditions = {'ctrl','sh'};
            treatments = {'GFP','DREADDs'};
            for c=1:2
                for a=1:4
                    animal = animal + 1;
                    animalEffect = randn*0.5;
                    for t=1:2
                        for n=1:2
                            neuronEffect = randn*0.5;
                            for k=1:5
                                rows(end+1,:) = {5 + animalEffect + neuronEffect + randn, ...
                                    sprintf('image%d',n+2*(t-1)), 1000+animal, conditions{c}, treatments{t}}; %#ok<AGROW>
                            end
                        end
                    end
                end
            end
            testCase.Tbl = cell2table(rows,'VariableNames',...
                {'Density','NeuronID','AnimalID','Condition','Treatment'});
        end
    end

    methods (Test)
        function testInteractionPower(testCase)
            results = vlt.stats.power.lme_factorial_power(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},[3 6],[0 4],...
                'referenceCategories',{'ctrl','GFP'},'numSimulations',20,...
                'useParallel',false,'doPlot',false,'verbose',false);
            testCase.verifyEqual(size(results.powerMatrix),[2 2]);
            testCase.verifyEqual(results.test.term,'Condition:Treatment');
            testCase.verifyEqual(results.pilot.betweenFactors,{'Condition'});
            testCase.verifyEqual(results.effectPattern.EffectPattern,[0;0;0;1]);
            % a zero effect should rarely be significant; a large effect usually should be
            testCase.verifyLessThan(results.powerMatrix(2,1),0.3);
            testCase.verifyGreaterThan(results.powerMatrix(2,2),results.powerMatrix(2,1));
            testCase.verifyEqual(height(results.requiredSubjects),2);
        end

        function testContrastAndUnits(testCase)
            results = vlt.stats.power.lme_factorial_power(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},4,2,...
                'referenceCategories',{'ctrl','GFP'},...
                'testContrast',["sh / GFP","sh / DREADDs"],'nUnitsPerSubject',3,'nObsPerUnit',2,...
                'numSimulations',10,'useParallel',false,'doPlot',false,'verbose',false);
            testCase.verifyEqual(results.test.type,'contrast');
            testCase.verifyEqual(numel(results.powerMatrix),1);
        end

        function testContrastDraws(testCase)
            contrasts = struct('name', {'C1','C3','S1'}, ...
                'weights', {[-1 1 0 0], [1 -1 -1 1], [0 0 -1 1]}, ...
                'direction', {'greater','less','none'}, 'margin', {NaN, NaN, 1});
            results = vlt.stats.power.lme_factorial_power(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},[3 5],0,...
                'referenceCategories',{'ctrl','GFP'},'testContrasts',contrasts,...
                'numSimulations',10,'useParallel',false,'doPlot',false,'verbose',false);
            d = results.contrastDraws;
            testCase.verifyEqual(d.names, ["C1","C3","S1"]);
            testCase.verifyEqual(size(d.estimate), [10 3 2]);
            testCase.verifyEqual(height(results.contrastPower), 2);
            % shifting the true values: huge effects in the predicted directions always succeed
            cp = vlt.stats.power.contrast_power_from_draws(d.estimate(:,:,2), d.se(:,:,2), ...
                d.df(:,:,2), [100 -100 0; 0 0 0], contrasts);
            testCase.verifyEqual(cp.powerEach(1,1:2), [1 1]);
            testCase.verifyEqual(cp.powerAll(1), 1);
            testCase.verifyLessThanOrEqual(cp.powerAll(2), min(cp.powerEach(2,1:2)));
            testCase.verifyTrue(isnan(cp.powerEquivalent(1,1)));
            testCase.verifyTrue(cp.powerEquivalent(1,3) >= 0 && cp.powerEquivalent(1,3) <= 1);
        end

        function testContrastPowerFromSyntheticDraws(testCase)
            % known draws: estimates N(0,1), SE 1, very large DF (normal tests)
            rng(3);
            n = 20000;
            estimate = randn(n,2);
            se = ones(n,2);
            df = 1e6*ones(n,2);
            contrasts = struct('name', {'A','B'}, 'direction', {'greater','none'}, 'margin', {NaN, 3});
            cp = vlt.stats.power.contrast_power_from_draws(estimate, se, df, [0 0; 2.8 0], contrasts);
            % no effect: one-directional success ~ alpha/2; two-sided ~ alpha
            testCase.verifyEqual(cp.powerEach(1,1), 0.025, 'AbsTol', 0.006);
            testCase.verifyEqual(cp.powerEach(1,2), 0.05, 'AbsTol', 0.008);
            % effect of 2.8 SE: power ~ 0.80
            testCase.verifyEqual(cp.powerEach(2,1), 0.80, 'AbsTol', 0.02);
            % equivalence with margin 3 SE and true value 0: power ~ 2*Phi(3-1.645)-1 = 0.82
            testCase.verifyEqual(cp.powerEquivalent(1,2), 0.82, 'AbsTol', 0.02);
        end

        function testOneGroupingLevel(testCase)
            % with only subjects as random effects, nObsPerUnit sets observations per subject per cell
            results = vlt.stats.power.lme_factorial_power(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID'},[3 5],[0 2],...
                'referenceCategories',{'ctrl','GFP'},'testTerm','Treatment','nObsPerUnit',4,...
                'numSimulations',10,'useParallel',false,'doPlot',false,'verbose',false);
            testCase.verifyEqual(size(results.powerMatrix),[2 2]);
            testCase.verifyEqual(numel(results.pilot.sigmas),2);
            testCase.verifyTrue(any(strcmp(results.requiredSubjects.Properties.VariableNames,...
                'nSubjectsPerGroupFor80Percent')));
        end
    end
end
