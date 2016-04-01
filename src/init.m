function init()
config % global parameters initialized

% read configuration parameters
yamlfile='cnfg/expconfig.yaml';
[params, runConfig] = readConfig(yamlfile); % Read parameter settings both for the experimental runs and configuration parameters
