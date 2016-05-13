function init()
global exp_name domain options topology config_template config_folder save_folder deployment_service ci_service mon_service
config % global parameters initialized

% read configuration parameters
yamlfile='conf/expconfig.yaml';
[params, runConfig, services] = readConfig(yamlfile); % Read parameter settings both for the experimental runs and configuration parameters

if ~isdeployed
    topology=runConfig.topologyName;
    % init the experiment name with time stamp
    exp_name=strcat(topology,'_exp_',num2str(datenum(datetime('now')),'%bu'));
    
    config_template=runConfig.conf;
    config_folder=runConfig.confFolder;
    save_folder=runConfig.saveFolder;
    
    options=params.param_options;
    domain=options2domain(options);
    
    deployment_service=services.deploymentServiceURL;
    ci_service=services.continuousIntegrationURL;
    mon_service=services.monitoringURL;
else  
    setmcruserdata('topology',runConfig.topologyName);
    setmcruserdata('exp_name',strcat(topology,'_exp_',num2str(datenum(datetime('now')),'%bu')));

    setmcruserdata('config_template',runConfig.conf);
    setmcruserdata('config_folder',runConfig.confFolder);
    setmcruserdata('save_folder',runConfig.saveFolder);

    setmcruserdata('options',params.param_options);
    setmcruserdata('domain',options2domain(options));

    setmcruserdata('deployment_service',services.deploymentServiceURL);
    setmcruserdata('ci_service',services.continuousIntegrationURL);
    setmcruserdata('mon_service',services.monitoringURL);
    
end

%setting=domain2option(options,[1 5 1 3 1 1]);