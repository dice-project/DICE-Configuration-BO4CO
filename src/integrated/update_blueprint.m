function updated_blueprint_name=update_blueprint(setting)
% this is a wrapper for update blueprint command of deployment service
% see this for more information: https://github.com/dice-project/DICE-Deployment-Service/blob/master/doc/configuration-optimization-process.md

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global blueprint config_folder
if ~isdeployed
    blueprint_=blueprint;
    config_folder_=config_folder;
else
    blueprint_ = getmcruserdata('blueprint');
    config_folder_=getmcruserdata('config_folder');
end
configuration_description_file='./conf/expconfig.yaml';
current_index=length(dir([config_folder_ 'blueprint*.yaml']));
blueprint_template=[config_folder_ blueprint_];
updated_blueprint_name=['blueprint_' num2str(current_index+1) '.yaml'];
copyfile(blueprint_template, [config_folder_ updated_blueprint_name],'f');

intermediate_json='values.json';

setting_struct=struct('config',{num2cell(setting)});
fileID = fopen([config_folder_ intermediate_json],'w');
fprintf(fileID,mls.internal.toJSON(setting_struct));
fclose(fileID);

% prepare the command to be executed
cli='update-blueprint-parameters.py';
cmd=[cli ' -o ' configuration_description_file ' -c ' ...
    [config_folder_ intermediate_json] ' -b ' blueprint_template ' -O ' [config_folder_ updated_blueprint_name] ' --json'];
system(cmd);
end