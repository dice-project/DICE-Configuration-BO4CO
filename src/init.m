function init()
global exp_name domain options topology config_template
config % global parameters initialized

% read configuration parameters
yamlfile='conf/expconfig.yaml';
[params, runConfig] = readConfig(yamlfile); % Read parameter settings both for the experimental runs and configuration parameters

topology=runConfig.topologyName;
% init the experiment name with time stamp
exp_name=strcat(topology,'_exp_',num2str(datenum(datetime('now')),'%bu'));

config_template=runConfig.conf;

options=params.param_options;
domain=options2domain(options);

setting=domain2option(options,[1 5 1 3 1 1]);