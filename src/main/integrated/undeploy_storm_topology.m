function [status]=undeploy_storm_topology(deployment_id)
% Kills a running topology.

% Authors: Pooyan Jamshidi (pooyan.jamshidi@gmail.com)
% The code is released under the FreeBSD License.
% Copyright (C) 2016 Pooyan Jamshidi, Imperial College London

global storm
if isdeployed
    ip = getmcruserdata('storm');
else ip=storm;
end
wait_time=10; % Wait time before rebalance happens
api='/api/v1/topology/';
url=[ip api deployment_id '/kill/' num2str(wait_time)];
options = weboptions('RequestMethod','post');
try
data = webread(url,options);
catch ME
    status=0;
    warning(ME.message);
    return
end
if strcmp(data.status,'success')
    status=1;   
else
    status=0;  
end

end