% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

% initilize the global variables
init();

% retrieve some settings
global domain exp_budget initial_design exp_name summary_folder
if ~isdeployed
    domain_=domain;
    maxIter=exp_budget;
    nInit=initial_design;
    exp_name_=exp_name;
    summary_folder_=summary_folder;
else
    domain_=getmcruserdata('domain');
    maxIter=getmcruserdata('exp_budget');
    nInit=getmcruserdata('initial_design');
    exp_name_=getmcruserdata('exp_name');
    summary_folder_=getmcruserdata('summary_folder');
end
expData = []; % init matrix saving experimental data

%% this is the analytical function we want to find it's minimum (a wrapper for the response function)
% domain represents the domain of the function
d = size(domain_, 1); % dimension of the space

%% create the grid
%[xTest, xTestDiff, nTest, nTestPerDim] = makeGrid(xRange, nMinGridPoints);

%% initialize the prior
gps = covarianceKernelFactory(12, d);

%% initial samples from the Latin Hypercube design
% (this section should be genralized in a way to replace any DoE that gives initial design such as random, etc...)
maxIter=maxIter-nInit;

%obsX = lhsdesign(d, nInit)';
obsX = lhsdesign4grid(d, nInit, domain_);
%obsX = unirnddesign4grid(d, nInit, domain);
obsY = zeros(size(obsX, 1), 1);

for k = 1:size(obsX, 1)
    obsY(k) = f(obsX(k, :));
end

%% Bayesian optimization loop (for locating minimizer)
for k = 1:maxIter
    % every 10 sec check whether to stop or pause or continue running
    while 1
        switch getmcruserdata('mode')
            case 'running'
                break
            case 'pause'
                continue
            case 'stop'
                exit
        end
        pause(10);
    end
    % criterial to evaluate in order to find where to sample next
    [nextX, dummy1, xTest, m, s, z, ef,h,et] = boLCB(domain_, obsX, obsY, gps);
    
    % evaluate at the suggested point
    nextY = f(nextX);
    
    % save the measurement pair and CIs
    obsX = [obsX; nextX];
    obsY = [obsY; nextY];   
end

% saving the replication data
expData=[expData obsX obsY];
save([summary_folder_ exp_name_ '.mat'],expData);
%% update the config with what has been found
get_config();