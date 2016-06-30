function [params, runConfig, services, application] = readConfig(yaml_file)
% Reads the configuration file and extract appropriate infromation
% about the experiments to run and the parameters and apporpriate options

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London
% Reference: https://github.com/ziyuw/rembo/blob/master/src/utils/readConfig.m

% read configuration file and extract the fields
configs = ReadYaml(yaml_file);
names = fieldnames(configs);
num = length(names);

% extract the information about the experiment
for i=1:num
    if strcmp(names{i}, 'runexp')
        runConfig = getfield(configs, names{i});
        names = [names(1:i-1), names(i+1:end)];
        break
    end
end

% extract the information about the services
for i=1:num
    if strcmp(names{i}, 'services')
        services = getfield(configs, names{i});
        names = [names(1:i-1), names(i+1:end)];
        break
    end
end

% extract the information about the application
for i=1:num
    if strcmp(names{i}, 'application')
        application = getfield(configs, names{i});
        names = [names(1:i-1), names(i+1:end)];
        break
    end
end

% extract information about parameters
vars = getfield(configs, names{1});
num = length(vars);
param_bounds = zeros(num, 2);
param_options = cell(num,2);
discrete_indices = zeros(0, 0);
log_indices = zeros(0, 0);
categorical_indices = zeros(0, 0);
for i=1:num
    field = vars{i};
    param_bounds(i, 1) = field.lowerbound;
    param_bounds(i, 2) = field.upperbound;
    param_options(i, 1) = cellstr(field.paramname);
    param_options(i, 2) = field.options;
    
    
    if isfield(field, 'integer') && field.integer
        discrete_indices(length(discrete_indices)+1) = i;
    end
    
    if isfield(field, 'categorical') && field.categorical
        categorical_indices(length(categorical_indices)+1) = i;
    end
    
    if isfield(field, 'logscale') && field.logscale
        log_indices(length(log_indices)+1) = i;
    end
end

param_bounds(log_indices, :) = log(param_bounds(log_indices, :));


params.high_dim = size(param_bounds, 1);
params.param_bounds = param_bounds';
params.param_options = param_options';
params.log_indices = log_indices;
params.discrete_indices = discrete_indices;
params.categorical_indices = categorical_indices;
params.param_range = params.param_bounds(2, :) - params.param_bounds(1, :);
params.param_range(discrete_indices) = params.param_range(discrete_indices) + 1;
params.param_bounds(1, discrete_indices) = ...
    params.param_bounds(1, discrete_indices) - 0.5;

end