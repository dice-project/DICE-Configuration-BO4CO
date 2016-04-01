function init()
config % global parameters initialized

% read configuration parameters
yamlfile='cnfg/expconfig.yaml';
[params, runConfig] = readConfig(yamlfile);        % Read in parameter settings.
