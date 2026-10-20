classdef test_lme_factorial < matlab.unittest.TestCase
    % TEST_LME_FACTORIAL - tests for vlt.stats.lme_factorial and vlt.stats.plot_lme_factorial

    properties
        Tbl
    end

    methods (TestMethodSetup)
        function makeData(testCase)
            % 2 x 2 design: Condition is between animals, Treatment is within animals,
            % neurons are nested in animals, several observations per neuron.
            % Neuron names are reused across animals to check the nesting.
            rng(1);
            rows = {};
            animal = 0;
            conditions = {'ctrl','sh'};
            treatments = {'GFP','DREADDs'};
            for c=1:2
                for a=1:5
                    animal = animal + 1;
                    animalEffect = randn*0.5;
                    for t=1:2
                        for n=1:3
                            neuronEffect = randn*0.5;
                            for k=1:6
                                density = 5 + 1*(c==2) + 0.5*(t==2) + 1*(c==2 && t==2) + ...
                                    animalEffect + neuronEffect + randn*0.5;
                                rows(end+1,:) = {density, sprintf('image%d',n+3*(t-1)), ...
                                    1000+animal, conditions{c}, treatments{t}}; %#ok<AGROW>
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
        function testFit(testCase)
            [lme,newTable,stats] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},...
                'referenceCategories',{'ctrl','GFP'});
            testCase.verifyClass(lme,'LinearMixedModel');
            testCase.verifyEqual(height(newTable),height(testCase.Tbl));
            testCase.verifyEqual(stats.groupVarNames,{'AnimalID','NeuronID_in_AnimalID'});
            % 10 animals x 6 neurons each are distinct units even though names repeat
            testCase.verifyEqual(numel(categories(newTable.NeuronID_in_AnimalID)),60);
            testCase.verifyEqual(stats.factorLevels{1},{'ctrl','sh'});
            testCase.verifyEqual(stats.factorLevels{2},{'GFP','DREADDs'});
            testCase.verifyEqual(height(stats.cellMeans),4);
            testCase.verifyEqual(stats.cellMeans.Label,["ctrl / GFP";"ctrl / DREADDs";"sh / GFP";"sh / DREADDs"]);
            testCase.verifyEqual(stats.cellMeans.n_AnimalID,[5;5;5;5]);
            testCase.verifyEqual(stats.cellMeans.n_NeuronID,[15;15;15;15]);
            testCase.verifyTrue(any(strcmp(stats.anovaTable.Term,'Condition:Treatment')));
            testCase.verifyEqual(height(stats.contrasts),4); % simple effects in a 2x2
            testCase.verifyTrue(all(stats.contrasts.pAdjusted>=stats.contrasts.pValue));
            % cell mean estimates should be close to the raw cell means
            for c=1:4
                raw = mean(newTable.Density(stats.cellIndexes{c}));
                testCase.verifyEqual(stats.cellMeans.Estimate(c),raw,'AbsTol',0.5);
            end
        end

        function testRankAndLog(testCase)
            [~,~,stats] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},'rankOrder',true);
            testCase.verifyEqual(stats.transform,'rank');
            [~,~,stats] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},'logData',true);
            testCase.verifyEqual(stats.transform,'log10');
            testCase.verifyTrue(any(strcmp(stats.cellMeans.Properties.VariableNames,'EstimateOriginalUnits')));
        end

        function testPlot(testCase)
            [lme,newTable,stats] = vlt.stats.lme_factorial(testCase.Tbl,'Density',...
                {'Condition','Treatment'},{'AnimalID','NeuronID'},...
                'referenceCategories',{'ctrl','GFP'});
            f = figure('Visible','off');
            testCase.addTeardown(@() close(f));
            [h,plotInfo] = vlt.stats.plot_lme_factorial(lme,newTable,stats,'yLabel','Density');
            testCase.verifyNotEmpty(h);
            testCase.verifyEqual(numel(plotInfo.xCenter),60);
            testCase.verifyEqual(size(plotInfo.cellBoundaries),[4 2]);
        end
    end
end
