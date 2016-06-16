function [status]=undeploy(blueprint_id)
% undeploys a topology (system) that is already deployed on the testing cluster

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

% runs the deployment service to deploy the system with the current config
global deployment_service
if ~isdeployed
    deployment_service_=deployment_service;
else
    deployment_service_=getmcruserdata('deployment_service');
end
service_url = [deployment_service_.URL '/blueprints/' blueprint_id];

% call the restfull api and return the status
%status = webread(service_url,'sys_name',system_name,options);


header = http_createHeader('Authorization',['Token ',get_token()]);
[status,extras]=urlread2(service_url,'DELETE',[],header);
end