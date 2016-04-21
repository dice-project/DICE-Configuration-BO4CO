function init()
global exp_name domain options
config % global parameters initialized

% read configuration parameters
yamlfile='conf/expconfig.yaml';
[params, runConfig] = readConfig(yamlfile); % Read parameter settings both for the experimental runs and configuration parameters


% init the experiment name
exp_name=strcat(runConfig.topologyName,'_exp_',num2str(datenum(datetime('now')),'%bu'));

options=params.param_options;
domain=options2domain(options);
setting=domain2option(options,[1 5 1 3 1 1]);