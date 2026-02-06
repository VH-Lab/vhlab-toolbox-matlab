function effectSizes = get_lme_effect_sizes(lme)
% GET_LME_EFFECT_SIZES Computes effect sizes for a Linear Mixed Effects model.
%
%   effectSizes = GET_LME_EFFECT_SIZES(lme) takes a fitted LinearMixedModel 
%   object and returns a structure containing the raw Beta, Cohen's d 
%   approximation, Standardized Beta, and N (number of observations) for
%   each fixed effect term.
%
%   ERROR CONDITION:
%   This function checks for interaction terms (e.g., 'A:B'). If any are 
%   present, it throws an error as requested, because simple main effect 
%   calculations are misleading in the presence of interactions.
%
%   METHODS / FORMULAS:
%   1. Cohen's d Approximation:
%      Measures the shift in the response variable relative to the raw 
%      standard deviation of the data.
%      
%      Formula:  d = Beta / sigma_y
%
%      Where:
%        Beta    = The estimated fixed effect coefficient (Raw Estimate).
%        sigma_y = The standard deviation of the response variable (y).
%
%   2. Standardized Beta (Beta_std):
%      Measures the change in the outcome (in standard deviations) for a 
%      1 standard deviation change in the predictor.
%
%      Formula:  Beta_std = Beta * (sigma_x / sigma_y)
%
%      Where:
%        sigma_x = The standard deviation of the specific column in the 
%                  fixed effects design matrix corresponding to that term. 
%                  (For categorical variables, this is the SD of the 0/1 
%                  dummy vector).
%
%   3. N (Number of Observations):
%      For binary/dummy terms (including Intercept), this is the count of
%      observations where the term is 1.
%      For continuous variables (or non-binary columns), this is the total
%      number of observations used in the model.
%
%   INPUT:
%       lme - A fitted LinearMixedModel object (from fitlme).
%
%   OUTPUT:
%       effectSizes - A structure containing vectors for:
%           .TermNames   (Cell array of coefficient names)
%           .RawBeta     (The original estimates)
%           .CohensD     (The approximated Cohen's d)
%           .StdBeta     (The standardized coefficients)
%           .N           (The number of observations per level/term)
%
%   Example:
%       lme = fitlme(tbl, 'ReactionTime ~ Drug + (1|Subject)');
%       es = get_lme_effect_sizes(lme);

    %% 1. Input Validation
    if ~isa(lme, 'LinearMixedModel')
        error('Input must be a LinearMixedModel object created by fitlme.');
    end

    %% 2. Check for Interactions
    % We look at the coefficient names. In MATLAB, interactions usually 
    % appear as 'Var1:Var2'.
    coeffNames = lme.CoefficientNames;
    
    % Check if any name contains a colon ':', implying an interaction
    if any(contains(coeffNames, ':'))
        error('This function does not handle interactions. Please simplify your model or calculate simple effects manually.');
    end

    %% 3. Retrieve Data and Design Matrix
    % Get the response variable standard deviation (sigma_y)
    yName = lme.ResponseName;
    % We access the data table stored inside the object
    if isprop(lme, 'Variables')
        allData = lme.Variables;
        yData = allData.(yName);
        % Remove NaNs if any, though fitlme usually handles this
        sigma_y = std(yData, 'omitnan');
    else
        error('Could not access variables from the LME object.');
    end

    % Get the Fixed Effects Design Matrix (X)
    % This matrix contains the actual columns used for regression,
    % including the column of 1s for intercept and 0/1s for dummy vars.
    X = designMatrix(lme, 'Fixed');
    
    % Get the estimates (Beta)
    [betaVector, ~] = fixedEffects(lme);
    
    %% 4. Calculate Effect Sizes
    numTerms = length(betaVector);
    
    % Pre-allocate
    cohensD = zeros(numTerms, 1);
    stdBeta = zeros(numTerms, 1);
    N = zeros(numTerms, 1);
    
    for i = 1:numTerms
        beta = betaVector(i);
        
        % Calculate sigma_x for this specific term
        % X(:, i) is the column of the design matrix for this coefficient
        col = X(:, i);
        sigma_x = std(col, 'omitnan');
        
        % --- Calculation 1: Cohen's d Approximation ---
        cohensD(i) = beta / sigma_y;
        
        % --- Calculation 2: Standardized Beta ---
        % Note: For the Intercept, sigma_x is 0 (std of a column of 1s),
        % so StdBeta will correctly be 0.
        stdBeta(i) = beta * (sigma_x / sigma_y);

        % --- Calculation 3: N (Number of Observations) ---
        % Heuristic: If the column is binary (only 0s and 1s), we assume it
        % represents a group/level or intercept, so N is the count of 1s.
        % Otherwise (continuous or complex contrast), N is the total sample size.

        colClean = col(~isnan(col));
        if all(colClean == 0 | colClean == 1)
            N(i) = sum(colClean);
        else
            N(i) = length(colClean);
        end
    end

    %% 5. Pack into Structure
    effectSizes.TermNames = coeffNames';
    effectSizes.RawBeta = betaVector;
    effectSizes.CohensD = cohensD;
    effectSizes.StdBeta = stdBeta;
    effectSizes.N = N;
    effectSizes.observation = yData;

end
