% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

%% adding the BO4CO paths and the dependencies to the search path
setup();

%% initilize the global variables
init();

% retrieve the settings from the input file specified by testers
global domain exp_budget initial_design exp_name summary_folder mode deployment_service
if ~isdeployed
    domain_=domain;
    maxIter=exp_budget;
    nInit=initial_design;
    exp_name_=exp_name;
    summary_folder_=summary_folder;
    deployment_service_=deployment_service;
else
    domain_=getmcruserdata('domain');
    maxIter=getmcruserdata('exp_budget');
    nInit=getmcruserdata('initial_design');
    exp_name_=getmcruserdata('exp_name');
    summary_folder_=getmcruserdata('summary_folder');
    deployment_service_=getmcruserdata('deployment_service');
end

% domain represents the domain of the configuration parameters
% dimension of the space (number of parameters considered in the 'vars' section of the input YAML file)
d = size(domain_, 1);

% create the grid
%[xTest, xTestDiff, nTest, nTestPerDim] = makeGrid(xRange, nMinGridPoints);

%% verify whether deployment service and other depedent services are available and accessible
if ~is_deployment_container_exists()
    fprintf('the container %s is not accessible \n', deployment_service_.container);
    return
end

%% initialize the prior
gps = covarianceKernelFactory(12, d);

%% initial samples from the Latin Hypercube design (initial design)
% this is genralized in a way that experimenter can replace any DoE that
% gives initial design such as random, uniform, etc...)
maxIter=maxIter-nInit;

%obsX = lhsdesign(d, nInit)';
obsX = lhsdesign4grid(d, nInit, domain_);
%obsX = unirnddesign4grid(d, nInit, domain);

obsY = zeros(size(obsX, 1), 1);

for k = 1:size(obsX, 1)
    obsY(k) = f(obsX(k, :));
end

% during the measurements may be some iterations fail and we need to
% exclude them from the observation list
k=1;
while k<=nInit
    if obsY(k)<0
        obsY(k)=[];
        obsX(k, :)=[];
        maxIter=maxIter+1;
        nInit=nInit-1;
    else k=k+1;
    end
end

%% Bayesian optimization loop (for locating minimizer), iterative experiments are conducted here
for k = 1:maxIter
    % every 10 sec check whether to stop or pause or continue running
    % the reason for this is that at some point the tester may want to stop
    % the optimization process and free up the testing environment for
    % another testing activity in DevOps pipeline
    while 1
        if ~isdeployed
            exec_mode = mode;
        else
            exec_mode = getmcruserdata('mode');
        end
        switch exec_mode
            case 'running'
                break
            case 'pause'
                continue
            case 'stop'
                exit
        end
        pause(10);
    end
    % criteria to evaluate in order to find where to sample next
    [nextX, dummy1, xTest, m, s, z, ef,h,et] = boLCB(domain_, obsX, obsY, gps);
    
    % evaluate at the suggested point
    nextY = f(nextX);
    
    if nextY>0 % only if the measurement were successful add to the observation list
        % save the measurement pair and CIs
        obsX = [obsX; nextX];
        obsY = [obsY; nextY];
    else % the measurement were unsuccessful because of deployment failure so we did not consume the budget
        maxIter=maxIter+1;
    end
end

%% Result: at this point the optimum configuration within the experimental budget is found

% saving the replication data
expData=[obsX obsY];
save([summary_folder_ exp_name_ '.mat'],'expData');
% update the config file with what has been found
[config_file]=get_config();
fprintf('optimum configuration file is available: %s \n',config_file);
[optimum_performance]=get_optimum_performance();
fprintf('optimum performance data is available: %s \n',optimum_performance);