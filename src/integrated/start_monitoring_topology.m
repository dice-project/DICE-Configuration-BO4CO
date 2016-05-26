function [status]=start_monitoring_topology(deployment_id)
% updates the monitoring platform to start monitoring the topology deployment_id
% is status==1 then successful if 0 unsuccessful

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global mon_service
if isdeployed
    ip = getmcruserdata('mon_service');
else
    ip=mon_service;
end

[mon_ls_config]=get_logstash_config();

api='/dmon/v1/overlord/core/ls/config';
url=[ip api];

api_post='/dmon/v1/overlord/core/ls';
url_post=[ip api_post];

options = weboptions('RequestMethod','post');

if ~isempty(mon_ls_config.LSInstances)
    new_ls_config = struct('ESClusterName',mon_ls_config.LSInstances.ESClusterName,'HostFQDN',mon_ls_config.LSInstances.HostFQDN,'LSCoreStormTopology',deployment_id);
    header = http_createHeader('Content-Type','application/json');
    [status,extras]=urlread2(url,'PUT',mls.internal.toJSON(new_ls_config),header);
    status=extras.isGood;
    status = webwrite(url_post,options);    
end

end