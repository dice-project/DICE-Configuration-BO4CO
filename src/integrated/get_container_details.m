function [nimbus_ip,deployment_id,blueprint_id,status]=get_container_details()
% collectrs information about the deployment inside the CO container
% CO uses this for checking whether any blueprint is deployed or not and
% getting the nimbus ip for ssh into in order to submit topology

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global deployment_service topology

% this make the code mcr compatible for global vars
if ~isdeployed
    deployment_service_=deployment_service;
    topology_=topology;
else
    deployment_service_=getmcruserdata('deployment_service');
    topology_=getmcruserdata('topology');
end
deployment_info=struct([]);
blueprint_id='';
nimbus_ip='';
deployment_id='';

% wait until the deployment service deploys the system
service_url = [deployment_service_.URL '/containers/' deployment_service_.container];
options = weboptions('Timeout',30,'KeyName','Authorization','KeyValue',['Token ',get_token()]);
response = webread(service_url,options);

status=response.blueprint.state_name;
if strcmp(status,'deployed')
    blueprint_id=response.blueprint.id;
    nimbus_ip=response.blueprint.outputs.storm_nimbus_address.value;
    
    output_response=response.blueprint.outputs;
    outputs_filed_names=fieldnames(output_response);
    for i=1:length(outputs_filed_names)
        if ~isempty(strfind(lower(outputs_filed_names{i}),lower(topology_)))
            deployment_info=getfield(output_response,outputs_filed_names{i});
        end
    end
    if ~isempty(deployment_info)
        deployment_id=deployment_info.value;
    end
end


end