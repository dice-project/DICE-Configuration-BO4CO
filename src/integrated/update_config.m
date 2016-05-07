function [updated_config_name]=update_config(setting)
% this updates the configuration parameters in the main YAML file
% setting = [10 12 1], p1=10, p2=12, p3=1
% params_name={'component.spout_num','topology.max.spout.pending','topology.sleep.spout.wait.strategy.time.ms'}
% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global topology options config_template
% list of parameters' name
for i=1:length(options)
    params_name{i}=options{1,i};
end

% retrieve the configuration template with (default) values
dirpath='./config/';
yaml_file=strcat(dirpath,config_template);
configs = ReadYaml(yaml_file);

% update the parameters with the setting values
updated_config=configs;
for i=1:length(params_name)
    updated_config=setfield(updated_config,char(params_name(i)),setting(i));
end

% create a timestamped file name
updated_config_name=strcat(topology,'_config_',num2str(datenum(datetime('now')),'%bu'));
updated_config_file=strcat(dirpath,updated_config_name,'.yaml');

WriteYaml(updated_config_file,updated_config);

end