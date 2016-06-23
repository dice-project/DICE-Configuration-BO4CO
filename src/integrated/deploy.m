function [deployment_id,blueprint_id,status]=deploy(config_name)
% deploys a topology (system) with a blueprint provided on the testing cluster
% I got the inspiration for this from http://www.mathworks.com/matlabcentral/fileexchange/27189-urlreadpost-url-post-method-with-binary-file-uploading/content/urlreadpost.m

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global config_folder deployment_service storm topology

% this make the code mcr compatible for global vars
if ~isdeployed
    dirpath=config_folder;
    deployment_service_=deployment_service;
    topology_=topology;
else
    dirpath=getmcruserdata('config_folder');
    deployment_service_=getmcruserdata('deployment_service');
    topology_=getmcruserdata('topology');
end
% retrieve the yaml file
yaml_file=strcat(dirpath,config_name);
%configs = ReadYaml(yaml_file);
fileID = fopen(yaml_file,'r');
content = fscanf(fileID,'%c');
fclose(fileID);

% runs the deployment service to deploy the system with the current config
eol = [char(13),char(10)];
boundary='------------------------7pooyan7';
service_url = [deployment_service_.URL '/containers/' deployment_service_.container '/blueprint'];
options = weboptions('Timeout',30,'KeyName','Authorization','KeyValue',['Token ',get_token()],'MediaType',['multipart/form-data; boundary=' boundary]);
data=['--' boundary eol];
data=[data 'Content-Disposition: form-data; name="file"; filename="' config_name '"',eol];
data=[data 'Content-Type: application/octet-stream',eol];
data=[data eol content eol];
data=[data '--' boundary '--' eol];

% call the restfull api and return the status
response = webwrite(service_url,data,options);

blueprint_id=response.blueprint.id;

% wait until the deployment service deploys the system
service_url = [deployment_service_.URL '/blueprints/' blueprint_id];
options = weboptions('Timeout',30,'KeyName','Authorization','KeyValue',['Token ',get_token()]);
response = webread(service_url,options);
status=response.state_name;
while ~strcmp(status,'deployed')
    pause(60);
    response = webread(service_url,options);
    status=response.state_name;
    if strcmp(status,'error')
        deployment_id='';
        return
    end
end

% this searchers through the output to locate the infromation about the
% topology which is just deployed
output_response=response.outputs;
outputs_filed_names=fieldnames(output_response);
for i=1:length(outputs_filed_names)
if ~isempty(strfind(lower(outputs_filed_names{i}),lower(topology_)))
    deployment_info=getfield(output_response,outputs_filed_names{i});
end
end

deployment_id=deployment_info.value;

% set the ip address of storm UI
if ~isdeployed
    storm = response.outputs.storm_nimbus_address.value;
else
    setmcruserdata('storm',response.outputs.storm_nimbus_address.value);
end

end